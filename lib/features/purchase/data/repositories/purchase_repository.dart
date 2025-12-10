import 'package:dio/dio.dart';
import '../models/purchase_model.dart';

class PurchaseRepository {
  late final Dio dio;
  final String baseUrl;

  PurchaseRepository({
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

  // Get purchase list
  Future<List<PurchaseModel>> getPurchaseList({
    required int companyId,
    required int purId,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/Purchase',
        queryParameters: {
          'companyId': companyId,
          'purId': purId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 200 && data['data'] != null) {
          final List<dynamic> purchaseList = data['data'];
          return purchaseList.map((json) => PurchaseModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch purchases');
        }
      } else {
        throw Exception('Failed to fetch purchases: ${response.statusCode}');
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
      throw Exception('Error fetching purchases: $e');
    }
  }
}