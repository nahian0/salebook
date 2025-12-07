
import 'package:dio/dio.dart';
import '../model/party_model.dart';

class PartyRepository {
  static const String baseUrl = 'http://10.11.0.39:88/api/v1/Party';
  final Dio _dio;

  PartyRepository({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Fetch all sale parties from the API
  Future<PartyResponse> getAllParties() async {
    try {
      final response = await _dio.get('/GetAllSalParty');

      if (response.statusCode == 200) {
        return PartyResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load parties: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching parties: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
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
        createdBy: 'user', // You can update this with actual user info
        updatedBy: 'user',
      );

      final response = await _dio.post(
        '/CreateSalParty',
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
      throw Exception('Error creating party: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}