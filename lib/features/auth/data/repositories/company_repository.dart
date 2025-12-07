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
  Future<bool> createCompany({
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

      final response = await _dio.post('/Company', data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Company created successfully');

        // Save to SharedPreferences after successful creation
        if (response.data != null && response.data['data'] != null) {
          final companyData = response.data['data'];
          await StorageService.saveCompanyInfo(
            companyId: companyData['id'] ?? 1,
            companyName: name,
          );
        } else {
          // If response doesn't contain ID, save with a default
          await StorageService.saveCompanyInfo(
            companyId: 1,
            companyName: name,
          );
        }
        return true;
      }

      print('⚠️ Unexpected status code: ${response.statusCode}');
      return false;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
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
        'phoneNo': phoneNo,
        'deviceId': deviceId,
        'verificationCode': verificationCode,
      };

      print('📤 Updating company device');
      print('📦 Request body: $body');

      final response = await _dio.post('/Company/UpdateCompany', data: body);

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