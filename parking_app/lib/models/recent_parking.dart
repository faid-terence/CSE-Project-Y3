import 'package:parking_app/models/booking.dart';

class RecentParking {
  final String name;
  final String date;
  final String price;
  final String imageUrl;

  RecentParking({
    required this.name,
    required this.date,
    required this.price,
    required this.imageUrl,
  });

  factory RecentParking.fromBooking(Booking booking) {
    return RecentParking(
      name: booking.parkingLocation.name,
      date: _formatDate(booking.startTime),
      price: (booking.totalPrice / 1000).toStringAsFixed(
        2,
      ), // Convert cents to dollars
      imageUrl: 'assets/images/parking_recent_${booking.parkingLocationId}.png',
    );
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day - 1) {
      return 'Yesterday, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day} ${_monthName(date.month)} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
