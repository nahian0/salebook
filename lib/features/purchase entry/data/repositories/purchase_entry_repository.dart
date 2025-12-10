// lib/features/purchase/data/repositories/purchase_entry_repository.dart
import 'package:dio/dio.dart';
import '../models/purchase_model.dart';
import '../models/purchase_party_model.dart';

class PurchaseEntryRepository {
  late final Dio dio;
  final String baseUrl;

  PurchaseEntryRepository({
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

  // ==================== PURCHASE METHODS ====================

  /// Get purchase list
  Future<List<PurchaseModel>> getPurchaseList({
    required int companyId,
    required int purchaseId,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/Purchase',
        queryParameters: {
          'companyId': companyId,
          'purchaseId': purchaseId,
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

  /// Create new purchase
  Future<Map<String, dynamic>> createPurchase({
    required int companyId,
    required int purchasePartyId,
    required String purchasePartyName,
    required String purNo,
    required DateTime purchaseDate,
    required double totalAmount,
    required List<Map<String, dynamic>> purchaseDetails,
    String? remarks,
  }) async {
    try {
      final requestBody = {
        "id": 0,
        "companyId": companyId,
        "purchasePartyId": purchasePartyId,
        "purchasePartyName": purchasePartyName,
        "purNo": purNo,
        "purchaseDate": purchaseDate.toIso8601String(),
        "totalAmount": totalAmount,
        "remarks": remarks ?? "",
        "serialNo": 0,
        "purPurchaseDetails": purchaseDetails.map((detail) => {
          "id": 0,
          "purchaseMasterId": 0,
          "productDescription": detail['productDescription'] ?? "",
          "amount": detail['amount'] ?? 0,
          "remarks": detail['remarks'] ?? "",
        }).toList(),
      };

      final response = await dio.post(
        '$baseUrl/Purchase',
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
            'message': data['message'] ?? 'Purchase created successfully',
            'data': data['data'],
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to create purchase');
        }
      } else {
        throw Exception('Failed to create purchase: ${response.statusCode}');
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
      throw Exception('Error creating purchase: $e');
    }
  }

  // ==================== PURCHASE PARTY METHODS ====================

  /// Fetch all purchase parties from the API
  Future<PurchasePartyResponse> getAllPurchaseParties() async {
    try {
      final response = await dio.get('$baseUrl/Party/GetAllPurParty',
          queryParameters: {'partyId': 0}
      );

      if (response.statusCode == 200) {
        return PurchasePartyResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load purchase parties: ${response.statusCode}');
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
      throw Exception('Error fetching purchase parties: $e');
    }
  }

  /// Create a new purchase party
  Future<PurchasePartyModel?> createPurchaseParty(String partyName) async {
    try {
      final now = DateTime.now().toIso8601String();
      final request = CreatePurchasePartyRequest(
        name: partyName,
        createdAt: now,
        updatedAt: now,
        createdBy: 'user',
        updatedBy: 'user',
      );

      final response = await dio.post(
        '$baseUrl/Party/CreatePurParty',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if API returns the created party in data field
        if (response.data['data'] != null) {
          return PurchasePartyModel.fromJson(response.data['data']);
        }

        // If API doesn't return the party, create a temporary one
        return PurchasePartyModel(
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
        throw Exception('Failed to create purchase party: ${response.statusCode}');
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
      throw Exception('Error creating purchase party: $e');
    }
  }
}