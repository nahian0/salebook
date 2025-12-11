import 'package:dio/dio.dart';
import '../models/company_model.dart';
import '../../../../core/services/storage_service.dart';

class CompanyRepository {
  final String baseUrl = 'http://10.11.4.145:8088/api/v1';
  late final Dio _dio;

  CompanyRepository() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return await StorageService.isLoggedIn();
  }

  /// Get all companies
  Future<CompanyResponse> getCompanies() async {
    try {
      final response = await _dio.get('/Company', queryParameters: {
        'companyId': null,
      });

      if (response.statusCode == 200) {
        final companyResponse = CompanyResponse.fromJson(response.data);

        // Save to SharedPreferences if company exists
        if (companyResponse.data.isNotEmpty) {
          final firstCompany = companyResponse.data.first;
          await StorageService.saveCompanyInfo(
            companyId: firstCompany.id,
            companyName: firstCompany.name,
          );
        }

        return companyResponse;
      } else {
        throw Exception('Failed to load companies');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching companies: ${e.message}');
    }
  }

  /// Login with phone number and device ID
  Future<LoginResult> loginWithPhone({
    required String phoneNo,
    required String deviceId,
  }) async {
    try {
      final body = {
        'phoneNo': phoneNo,
        'deviceId': deviceId,
      };

      print('📤 Sending login request');
      print('📦 Request body: $body');

      final response = await _dio.post(
        '/Company/Login',
        data: body,
        options: Options(
          validateStatus: (status) {
            // Accept both 200 and 400 as valid responses (don't throw exception)
            return status != null && (status == 200 || status == 400);
          },
        ),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // Check response status from API response body
      final responseStatus = response.data['status'];

      if (response.statusCode == 200 && responseStatus == 200) {
        print('✅ Login successful');

        // Save to SharedPreferences after successful login
        if (response.data != null && response.data['data'] != null) {
          final companyData = response.data['data'];
          await StorageService.saveCompanyInfo(
            companyId: companyData['id'] ?? 1,
            companyName: companyData['name'] ?? 'User',
          );
        }

        return LoginResult(success: true, isDifferentDevice: false);
      }

      // Check if it's a 400 error (different device)
      if (response.statusCode == 400 || responseStatus == 400) {
        print('⚠️ Different device detected');
        final message = response.data['message'] ?? 'Device Id Not Match';

        return LoginResult(
          success: false,
          isDifferentDevice: true,
          message: message == 'Device Id Not Match'
              ? 'আপনি ভিন্ন ডিভাইস থেকে লগইন করার চেষ্টা করছেন'
              : message,
          companyData: response.data['data'],
        );
      }

      print('⚠️ Unexpected response');
      return LoginResult(success: false, isDifferentDevice: false);

    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Status code: ${e.response?.statusCode}');
      print('❌ Response: ${e.response?.data}');

      throw Exception('Error during login: ${e.message}');
    } catch (e) {
      print('❌ General error: $e');
      throw Exception('Login failed: $e');
    }
  }

  /// Create new company with device ID
  /// Returns CreateCompanyResult to handle both success and existing company scenarios
  Future<CreateCompanyResult> createCompany({
    required String name,
    required String phoneNo,
    required String description,
    required String deviceId,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      final body = {
        'isActive': true,
        'isDelete': false,
        'createdAt': now,
        'updatedAt': now,
        'createdBy': 'user',
        'updatedBy': null,
        'name': name,
        'phoneNo': phoneNo,
        'description': description,
        'deviceId': deviceId,
      };

      print('📤 Sending create company request with deviceId: $deviceId');
      print('📦 Request body: $body');

      final response = await _dio.post(
        '/Company',
        data: body,
        options: Options(
          validateStatus: (status) {
            // Accept both success and 400 status codes
            return status != null && (status == 200 || status == 201 || status == 400);
          },
        ),
      );

      print('📥 HTTP Response status: ${response.statusCode}');
      print('📥 Response data: ${response.data}');

      // IMPORTANT: Check the API's internal status field, not just HTTP status
      final apiStatus = response.data['status'];
      final message = response.data['message'] ?? '';

      print('📥 API Status: $apiStatus');
      print('📥 API Message: $message');

      // Check if company already exists (status 400 in response body)
      if (apiStatus == 400) {
        print('⚠️ Company already exists with this phone number');

        String? existingCompanyName;
        if (response.data['data'] != null && response.data['data']['name'] != null) {
          existingCompanyName = response.data['data']['name'];
        }

        return CreateCompanyResult(
          success: false,
          alreadyExists: true,
          message: 'এই নম্বরটি ইতিমধ্যে নিবন্ধিত আছে',
          companyData: response.data['data'],
          phoneNo: phoneNo,
        );
      }

      // Success case - company created (status 200 in response body)
      if (apiStatus == 200 || apiStatus == 201) {
        print('✅ Company created successfully');

        if (response.data != null && response.data['data'] != null) {
          final companyData = response.data['data'];
          await StorageService.saveCompanyInfo(
            companyId: companyData['id'] ?? 1,
            companyName: name,
          );
        } else {
          await StorageService.saveCompanyInfo(
            companyId: 1,
            companyName: name,
          );
        }

        return CreateCompanyResult(
          success: true,
          alreadyExists: false,
          message: 'ইউজার সফলভাবে তৈরি হয়েছে!',
        );
      }

      print('⚠️ Unexpected API status: $apiStatus');
      return CreateCompanyResult(
        success: false,
        alreadyExists: false,
        message: message.isNotEmpty ? message : 'ইউজার তৈরি করতে ব্যর্থ',
      );

    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');

      // Handle 400 HTTP error
      if (e.response?.statusCode == 400 && e.response?.data != null) {
        final message = e.response!.data['message'] ?? '';

        if (message.toLowerCase().contains('exists')) {
          return CreateCompanyResult(
            success: false,
            alreadyExists: true,
            message: 'এই নম্বরটি ইতিমধ্যে নিবন্ধিত আছে',
            companyData: e.response!.data['data'],
            phoneNo: phoneNo,
          );
        }
      }

      throw Exception('Error creating company: ${e.message}');
    } catch (e) {
      print('❌ General error: $e');
      throw Exception('Error creating company: $e');
    }
  }

  /// Send verification code for device registration
  Future<SendCodeResult?> sendVerificationCode({
    required String phoneNo,
    required String deviceId,
  }) async {
    try {
      final body = {
        'phoneNo': phoneNo,
        'deviceId': deviceId,
      };

      print('📤 Sending verification code request');
      print('📦 Request body: $body');

      final response = await _dio.post('/Company/SendCode', data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Verification code sent successfully');
        print('📥 Response: ${response.data}');

        if (response.data != null && response.data['data'] != null) {
          final data = response.data['data'];
          return SendCodeResult(
            companyId: data['id'],
            verificationCode: data['verificationCode'],
            phoneNo: data['phoneNo'],
          );
        }
        return null;
      }

      print('⚠️ Unexpected status code: ${response.statusCode}');
      return null;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error sending verification code: ${e.message}');
    } catch (e) {
      print('❌ General error: $e');
      throw Exception('Error sending verification code: $e');
    }
  }

  /// Update company device ID after verification
  Future<bool> updateCompanyDevice({
    required int companyId,
    required String phoneNo,
    required String deviceId,
    required String verificationCode,
  }) async {
    try {
      final body = {
        'id': companyId,
        'deviceId': deviceId,
      };

      print('📤 Updating company device');
      print('📦 Request body: $body');

      final response = await _dio.post('/Company/UpdateCompanyDeviceId', data: body);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Device updated successfully');

        // Save to SharedPreferences after successful update
        if (response.data != null && response.data['data'] != null) {
          final companyData = response.data['data'];
          await StorageService.saveCompanyInfo(
            companyId: companyData['id'] ?? companyId,
            companyName: companyData['name'] ?? 'User',
          );
        } else {
          // If response doesn't contain data, just save with companyId
          await StorageService.saveCompanyInfo(
            companyId: companyId,
            companyName: 'User',
          );
        }

        return true;
      }

      print('⚠️ Unexpected status code: ${response.statusCode}');
      return false;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error updating device: ${e.message}');
    } catch (e) {
      print('❌ General error: $e');
      throw Exception('Error updating device: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    await StorageService.clearAll();
  }
}

/// Login result class to handle different login scenarios
class LoginResult {
  final bool success;
  final bool isDifferentDevice;
  final String? message;
  final Map<String, dynamic>? companyData;

  LoginResult({
    required this.success,
    required this.isDifferentDevice,
    this.message,
    this.companyData,
  });
}

/// Create company result class to handle creation scenarios
class CreateCompanyResult {
  final bool success;
  final bool alreadyExists;
  final String message;
  final Map<String, dynamic>? companyData;
  final String? phoneNo;

  CreateCompanyResult({
    required this.success,
    required this.alreadyExists,
    required this.message,
    this.companyData,
    this.phoneNo,
  });
}

/// Send code result class
class SendCodeResult {
  final int companyId;
  final String verificationCode;
  final String phoneNo;

  SendCodeResult({
    required this.companyId,
    required this.verificationCode,
    required this.phoneNo,
  });
}