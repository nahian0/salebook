// lib/features/sales/data/repositories/sales_repository.dart
import 'package:dio/dio.dart';
import '../models/sales_model.dart';

class SalesRepository {
  late final Dio dio;
  final String baseUrl;

  SalesRepository({
    Dio? dio,
    this.baseUrl = 'http://10.11.4.145:8088/api/v1',
  }) {
    this.dio = dio ?? Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  // Get sales list
  Future<List<SalesModel>> getSalesList({
    required int companyId,
    required int salId,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/Sales',
        queryParameters: {
          'companyId': companyId,
          'salId': salId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 200 && data['data'] != null) {
          final List<dynamic> salesList = data['data'];
          return salesList.map((json) => SalesModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch sales');
        }
      } else {
        throw Exception('Failed to fetch sales: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is taking too long to respond.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error fetching sales: $e');
    }
  }


}