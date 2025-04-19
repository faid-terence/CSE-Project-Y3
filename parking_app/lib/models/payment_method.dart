import 'package:flutter/material.dart';

class PaymentMethod {
  final String name;
  final IconData icon;
  final bool isDefault;

  PaymentMethod({
    required this.name,
    required this.icon,
    required this.isDefault,
  });
}
