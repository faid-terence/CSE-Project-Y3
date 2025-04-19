class ParkingLocation {
  final String name;
  final String address;
  final String distance;
  final String price;
  final int available;
  final int total;
  final double rating;
  final String imageUrl;

  ParkingLocation({
    required this.name,
    required this.address,
    required this.distance,
    required this.price,
    required this.available,
    required this.total,
    required this.rating,
    required this.imageUrl,
  });
}
