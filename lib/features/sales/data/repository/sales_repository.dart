// lib/features/sales/data/repositories/sales_repository.dart
import 'package:dio/dio.dart';
import '../model/sales_model.dart';

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

  // Create new sale
  Future<Map<String, dynamic>> createSale({
    required int companyId,
    required int salePartyId,
    required String salePartyName,
    required String saleNo,
    required DateTime saleDate,
    required double totalAmount,
    required double depositAmount,
    required List<Map<String, dynamic>> salesDetails,
    String? remarks,
  }) async {
    try {
      final requestBody = {
        "id": 0,
        "companyId": companyId,
        "salePartyId": salePartyId,
        "salePartyName": salePartyName,
        "saleNo": saleNo,
        "saleDate": saleDate.toIso8601String(),
        "totalAmount": totalAmount,
        "remarks": remarks ?? "",
        "depositAmount": depositAmount,
        "serialNo": 0,
        "salSalesDetails": salesDetails.map((detail) => {
          "id": 0,
          "salesMasterId": 0,
          "productDescription": detail['productDescription'] ?? "",
          "amount": detail['amount'] ?? 0,
          "remarks": detail['remarks'] ?? "",
        }).toList(),
      };

      final response = await dio.post(
        '$baseUrl/Sales',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data['status'] == 200 || data['status'] == 201) {
          return {
            'success': true,
            'message': data['message'] ?? 'Sale created successfully',
            'data': data['data'],
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to create sale');
        }
      } else {
        throw Exception('Failed to create sale: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is taking too long to respond.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response != null) {
        final errorData = e.response?.data;
        throw Exception(errorData['message'] ?? 'Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error creating sale: $e');
    }
  }
}