import 'package:flutter/material.dart';

class Vehicle {
  final int id;
  final int userId;
  final String name;
  final String licensePlate;
  final String icon; // API returns string like "car-sedan"
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.name,
    required this.licensePlate,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      licensePlate: json['license_plate'] as String,
      icon: json['icon'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Map string icon to IconData for UI
  IconData get iconData {
    switch (icon) {
      case 'car-sedan':
        return Icons.directions_car;
      case 'electric-car':
        return Icons.electric_car;
      default:
        return Icons.directions_car;
    }
  }
}
