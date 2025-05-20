class Parking {
  final int id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int pricePerHour;
  final int totalSlots;
  final int availableSpots;
  final String? city;

  Parking({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.pricePerHour,
    required this.totalSlots,
    required this.availableSpots,
    this.city,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      lat: json['lat'] is String ? double.parse(json['lat']) : json['lat'],
      lng: json['lng'] is String ? double.parse(json['lng']) : json['lng'],
      pricePerHour: json['price_per_hour'],
      totalSlots: json['total_slots'],
      availableSpots: json['available_spots'] ?? 0,
      city: json['city'],
    );
  }
}
