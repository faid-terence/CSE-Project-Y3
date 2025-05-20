import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_app/models/api_response.dart';
import 'package:parking_app/models/parking.dart';
import 'package:parking_app/services/dio_client/dio_client.dart';

class ParkingService {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ParkingService(this._dioClient);

  // Get all parkings
  Future<ApiResponse<List<Parking>>> getAllParkings() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.get('/api/parkings');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final List<dynamic>? parkingData = responseData['data'];

        if (parkingData != null) {
          final parkings =
              parkingData.map((json) => Parking.fromJson(json)).toList();
          return ApiResponse.success(
            parkings,
            message: message ?? 'Parkings fetched successfully',
          );
        }

        return ApiResponse.error('No parkings found');
      }

      return ApiResponse.error('Failed to fetch parkings');
    } on DioException catch (e) {
      debugPrint('Get parkings error: ${e.message}');
      String message = 'Failed to fetch parkings';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error fetching parkings: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Get a specific parking by ID
  Future<ApiResponse<Parking>> getParkingById(int id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.get('/api/parkings/$id');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? parkingData = responseData['data'];

        if (parkingData != null) {
          final parking = Parking.fromJson(parkingData);
          return ApiResponse.success(
            parking,
            message: message ?? 'Parking fetched successfully',
          );
        }

        return ApiResponse.error('Parking not found');
      }

      return ApiResponse.error('Failed to fetch parking');
    } on DioException catch (e) {
      debugPrint('Get parking error: ${e.message}');
      String message = 'Failed to fetch parking';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error fetching parking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Book a parking spot
  Future<ApiResponse<Map<String, dynamic>>> bookParking({
    required int parkingId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.post(
        '/api/bookings',
        data: {
          'parking_id': parkingId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? bookingData = responseData['data'];

        return ApiResponse.success(
          bookingData ?? {'booking_id': responseData['booking_id']},
          message: message ?? 'Booking successful',
        );
      }

      return ApiResponse.error('Failed to book parking');
    } on DioException catch (e) {
      debugPrint('Booking error: ${e.message}');
      String message = 'Failed to book parking';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error during booking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Helper method to get the authentication token
  Future<String?> _getToken() async {
    return _secureStorage.read(key: 'auth_token');
  }
}
