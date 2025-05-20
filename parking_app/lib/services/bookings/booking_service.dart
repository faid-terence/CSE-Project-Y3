import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_app/models/api_response.dart';
import 'package:parking_app/models/booking.dart';
import 'package:parking_app/models/recent_parking.dart';
import 'package:parking_app/services/dio_client/dio_client.dart';

class BookingService {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  BookingService(this._dioClient);

  // Create a new booking
  Future<ApiResponse<Map<String, dynamic>>> createBooking({
    required int parkingId,
    required int vehicleId,
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
          'parking_location_id': parkingId,
          'vehicle_id': vehicleId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? bookingData = responseData['data'];

        return ApiResponse.success(
          bookingData ?? {'booking_id': responseData['id']},
          message: message ?? 'Booking successful',
        );
      }

      return ApiResponse.error('Failed to create booking');
    } on DioException catch (e) {
      debugPrint('Create booking error: ${e.message}');
      String message = 'Failed to create booking';
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

  // Get recent bookings
  Future<ApiResponse<List<RecentParking>>> getRecentParkings() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.get('/api/bookings');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final List<dynamic>? bookingData = responseData['data'];

        if (bookingData != null) {
          final recentParkings =
              bookingData
                  .map(
                    (json) => RecentParking.fromBooking(Booking.fromJson(json)),
                  )
                  .toList();
          return ApiResponse.success(
            recentParkings,
            message: message ?? 'Recent parkings fetched successfully',
          );
        }

        return ApiResponse.error('No recent parkings found');
      }

      return ApiResponse.error('Failed to fetch recent parkings');
    } on DioException catch (e) {
      debugPrint('Get recent parkings error: ${e.message}');
      String message = 'Failed to fetch recent parkings';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error fetching recent parkings: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Helper method to get the authentication token
  Future<String?> _getToken() async {
    return _secureStorage.read(key: 'auth_token');
  }
}
