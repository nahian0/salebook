// lib/features/sales/data/repositories/sales_entry_repository.dart
import 'package:dio/dio.dart';
import '../../../sales/data/models/sales_model.dart';
import '../models/party_model.dart';

class SalesEntryRepository {
  late final Dio dio;
  final String baseUrl;

  SalesEntryRepository({
    Dio? dio,
    this.baseUrl = 'http://10.11.4.145:8088/api/v1',
  }) {
    this.dio = dio ?? Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  // ==================== SALES METHODS ====================

  /// Get sales list
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

  /// Create new sale
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

  // ==================== PARTY METHODS ====================

  /// Fetch all sale parties from the API
  Future<PartyResponse> getAllParties() async {
    try {
      final response = await dio.get('$baseUrl/Party/GetAllSalParty');

      if (response.statusCode == 200) {
        return PartyResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load parties: ${response.statusCode}');
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
      throw Exception('Error fetching parties: $e');
    }
  }

  /// Create a new sale party
  Future<PartyModel?> createParty(String partyName) async {
    try {
      final now = DateTime.now().toIso8601String();
      final request = CreatePartyRequest(
        name: partyName,
        createdAt: now,
        updatedAt: now,
        createdBy: 'user',
        updatedBy: 'user',
      );

      final response = await dio.post(
        '$baseUrl/Party/CreateSalParty',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if API returns the created party in data field
        if (response.data['data'] != null) {
          return PartyModel.fromJson(response.data['data']);
        }

        // If API doesn't return the party, create a temporary one
        return PartyModel(
          id: 0,
          companyId: 0,
          name: partyName,
          description: '',
          mobileNo: '',
          nid: '',
          address: '',
          isActive: true,
          isDelete: false,
          createdAt: now,
          updatedAt: now,
          createdBy: 'user',
          updatedBy: 'user',
        );
      } else {
        throw Exception('Failed to create party: ${response.statusCode}');
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
      throw Exception('Error creating party: $e');
    }
  }
}