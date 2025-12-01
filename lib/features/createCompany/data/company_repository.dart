import 'package:dio/dio.dart';
import 'models/company_model.dart';
import '../../../core/services/storage_service.dart';

class CompanyRepository {
  final String baseUrl = 'http://10.11.0.39:88/api/v1';
  late final Dio _dio;

  CompanyRepository() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ));
  }

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

  Future<bool> createCompany({
    required String name,
    required String phoneNo,
    required String description,
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
      };

      final response = await _dio.post('/Company', data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save to SharedPreferences after successful creation
        // Assuming the response contains the created company with ID
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
      return false;
    } on DioException catch (e) {
      throw Exception('Error creating company: ${e.message}');
    }
  }
}