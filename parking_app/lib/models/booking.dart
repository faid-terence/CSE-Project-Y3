import 'package:parking_app/models/parking.dart';
import 'package:parking_app/models/vehicle.dart';

class Booking {
  final int id;
  final int userId;
  final int parkingLocationId;
  final int vehicleId;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int durationHours;
  final double totalPrice;
  final Parking parkingLocation;
  final Vehicle vehicle;

  Booking({
    required this.id,
    required this.userId,
    required this.parkingLocationId,
    required this.vehicleId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.durationHours,
    required this.totalPrice,
    required this.parkingLocation,
    required this.vehicle,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      parkingLocationId: json['parking_location_id'] as int,
      vehicleId: json['vehicle_id'] as int,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      durationHours: json['duration_hours'] as int,
      totalPrice: double.parse(json['total_price'] as String),
      parkingLocation: Parking.fromJson(
        json['parking_location'] as Map<String, dynamic>,
      ),
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );
  }
}
