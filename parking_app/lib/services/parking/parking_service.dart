import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_app/models/api_response.dart';
import 'package:parking_app/models/parking.dart';
import 'package:parking_app/models/booking.dart';
import 'package:parking_app/services/dio_client/dio_client.dart';

class ParkingService {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ParkingService(this._dioClient);

  // =================== PARKING LOCATIONS ===================

  // Get all parkings (public endpoint)
  Future<ApiResponse<List<Parking>>> getAllParkings() async {
    try {
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

  // Get a specific parking by ID (public endpoint)
  Future<ApiResponse<Parking>> getParkingById(int id) async {
    try {
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

  // Create a new parking location (Admin only)
  Future<ApiResponse<Parking>> createParking({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int totalSpots,
    required double hourlyRate,
    String? description,
    List<String>? amenities,
    Map<String, dynamic>? operatingHours,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.post(
        '/api/parkings',
        data: {
          'name': name,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'total_spots': totalSpots,
          'hourly_rate': hourlyRate,
          if (description != null) 'description': description,
          if (amenities != null) 'amenities': amenities,
          if (operatingHours != null) 'operating_hours': operatingHours,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? parkingData = responseData['data'];

        if (parkingData != null) {
          final parking = Parking.fromJson(parkingData);
          return ApiResponse.success(
            parking,
            message: message ?? 'Parking location created successfully',
          );
        }

        return ApiResponse.error('Failed to create parking location');
      }

      return ApiResponse.error('Failed to create parking location');
    } on DioException catch (e) {
      debugPrint('Create parking error: ${e.message}');
      String message = 'Failed to create parking location';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error creating parking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Update a parking location (Admin only)
  Future<ApiResponse<Parking>> updateParking({
    required int id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? totalSpots,
    double? hourlyRate,
    String? description,
    List<String>? amenities,
    Map<String, dynamic>? operatingHours,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);

      // Build update data excluding null values
      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (address != null) updateData['address'] = address;
      if (latitude != null) updateData['latitude'] = latitude;
      if (longitude != null) updateData['longitude'] = longitude;
      if (totalSpots != null) updateData['total_spots'] = totalSpots;
      if (hourlyRate != null) updateData['hourly_rate'] = hourlyRate;
      if (description != null) updateData['description'] = description;
      if (amenities != null) updateData['amenities'] = amenities;
      if (operatingHours != null)
        updateData['operating_hours'] = operatingHours;

      final response = await _dioClient.dio.put(
        '/api/parkings/$id',
        data: updateData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? parkingData = responseData['data'];

        if (parkingData != null) {
          final parking = Parking.fromJson(parkingData);
          return ApiResponse.success(
            parking,
            message: message ?? 'Parking location updated successfully',
          );
        }

        return ApiResponse.error('Failed to update parking location');
      }

      return ApiResponse.error('Failed to update parking location');
    } on DioException catch (e) {
      debugPrint('Update parking error: ${e.message}');
      String message = 'Failed to update parking location';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error updating parking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Delete a parking location (Admin only)
  Future<ApiResponse<bool>> deleteParking(int id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.delete('/api/parkings/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        final responseData = response.data;
        final String? message = responseData?['message'];

        return ApiResponse.success(
          true,
          message: message ?? 'Parking location deleted successfully',
        );
      }

      return ApiResponse.error('Failed to delete parking location');
    } on DioException catch (e) {
      debugPrint('Delete parking error: ${e.message}');
      String message = 'Failed to delete parking location';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error deleting parking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // =================== BOOKINGS ===================

  // Get all user bookings
  Future<ApiResponse<List<Booking>>> getAllBookings() async {
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
          final bookings =
              bookingData.map((json) => Booking.fromJson(json)).toList();
          return ApiResponse.success(
            bookings,
            message: message ?? 'Bookings fetched successfully',
          );
        }

        return ApiResponse.error('No bookings found');
      }

      return ApiResponse.error('Failed to fetch bookings');
    } on DioException catch (e) {
      debugPrint('Get bookings error: ${e.message}');
      String message = 'Failed to fetch bookings';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error fetching bookings: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Get a specific booking by ID
  Future<ApiResponse<Booking>> getBookingById(int id) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);
      final response = await _dioClient.dio.get('/api/bookings/$id');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? bookingData = responseData['data'];

        if (bookingData != null) {
          final booking = Booking.fromJson(bookingData);
          return ApiResponse.success(
            booking,
            message: message ?? 'Booking fetched successfully',
          );
        }

        return ApiResponse.error('Booking not found');
      }

      return ApiResponse.error('Failed to fetch booking');
    } on DioException catch (e) {
      debugPrint('Get booking error: ${e.message}');
      String message = 'Failed to fetch booking';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error fetching booking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // Book a parking spot
  Future<ApiResponse<Booking>> bookParking({
    required int parkingId,
    required DateTime startTime,
    required DateTime endTime,
    int? vehicleId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);

      final Map<String, dynamic> bookingData = {
        'parking_id': parkingId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
      };

      if (vehicleId != null) {
        bookingData['vehicle_id'] = vehicleId;
      }

      if (additionalData != null) {
        bookingData.addAll(additionalData);
      }

      final response = await _dioClient.dio.post(
        '/api/bookings',
        data: bookingData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? bookingResponseData = responseData['data'];

        if (bookingResponseData != null) {
          final booking = Booking.fromJson(bookingResponseData);
          return ApiResponse.success(
            booking,
            message: message ?? 'Booking successful',
          );
        }

        return ApiResponse.error('Booking created but no data returned');
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

  // Extend a booking
  Future<ApiResponse<Booking>> extendBooking({
    required int bookingId,
    required DateTime newEndTime,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return ApiResponse.error('Not authenticated');
      }

      _dioClient.addAuthToken(token);

      final Map<String, dynamic> extendData = {
        'new_end_time': newEndTime.toIso8601String(),
      };

      if (additionalData != null) {
        extendData.addAll(additionalData);
      }

      final response = await _dioClient.dio.post(
        '/api/bookings/$bookingId/extend',
        data: extendData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final String? message = responseData['message'];
        final Map<String, dynamic>? bookingData = responseData['data'];

        if (bookingData != null) {
          final booking = Booking.fromJson(bookingData);
          return ApiResponse.success(
            booking,
            message: message ?? 'Booking extended successfully',
          );
        }

        return ApiResponse.error('Booking data not found');
      }

      return ApiResponse.error('Failed to extend booking');
    } on DioException catch (e) {
      debugPrint('Extend booking error: ${e.message}');
      String message = 'Failed to extend booking';
      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data['message'] != null) {
        message = e.response!.data['message'].toString();
      }
      return ApiResponse.error(message);
    } catch (e) {
      debugPrint('Unexpected error extending booking: $e');
      return ApiResponse.error('An unexpected error occurred');
    }
  }

  // =================== HELPER METHODS ===================

  // Helper method to get the authentication token
  Future<String?> _getToken() async {
    return _secureStorage.read(key: 'auth_token');
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear authentication token
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
