// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class BookingsScreen extends StatefulWidget {
//   const BookingsScreen({super.key});

//   @override
//   State<BookingsScreen> createState() => _BookingsScreenState();
// }

// class _BookingsScreenState extends State<BookingsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   // Sample booking data
//   final List<Booking> _activeBookings = [
//     Booking(
//       id: 'B-10023',
//       parkingName: 'City Center Parking',
//       address: '123 Main St, Downtown',
//       startDate: DateTime.now().add(const Duration(days: 1)),
//       endDate: DateTime.now().add(const Duration(days: 1, hours: 3)),
//       price: '7.50',
//       vehicle: 'Tesla Model 3',
//       licensePlate: 'CA-123-ABC',
//       status: BookingStatus.upcoming,
//     ),
//     Booking(
//       id: 'B-10019',
//       parkingName: 'Shopping Mall Parking',
//       address: '789 Retail Ave, Southside',
//       startDate: DateTime.now().add(const Duration(hours: 2)),
//       endDate: DateTime.now().add(const Duration(hours: 5)),
//       price: '9.00',
//       vehicle: 'Honda Civic',
//       licensePlate: 'CA-456-DEF',
//       status: BookingStatus.active,
//     ),
//   ];

//   final List<Booking> _pastBookings = [
//     Booking(
//       id: 'B-9984',
//       parkingName: 'Airport Terminal Parking',
//       address: '789 Airport Rd, North Terminal',
//       startDate: DateTime.now().subtract(const Duration(days: 3)),
//       endDate: DateTime.now()
//           .subtract(const Duration(days: 3))
//           .add(const Duration(hours: 8)),
//       price: '32.00',
//       vehicle: 'Tesla Model 3',
//       licensePlate: 'CA-123-ABC',
//       status: BookingStatus.completed,
//     ),
//     Booking(
//       id: 'B-9950',
//       parkingName: 'Downtown Plaza Garage',
//       address: '456 Market St, Downtown',
//       startDate: DateTime.now().subtract(const Duration(days: 5)),
//       endDate: DateTime.now()
//           .subtract(const Duration(days: 5))
//           .add(const Duration(hours: 4)),
//       price: '10.00',
//       vehicle: 'Honda Civic',
//       licensePlate: 'CA-456-DEF',
//       status: BookingStatus.completed,
//     ),
//     Booking(
//       id: 'B-9925',
//       parkingName: 'Hospital Visitor Parking',
//       address: '123 Health Rd, Eastside',
//       startDate: DateTime.now().subtract(const Duration(days: 7)),
//       endDate: DateTime.now()
//           .subtract(const Duration(days: 7))
//           .add(const Duration(hours: 1, minutes: 30)),
//       price: '3.75',
//       vehicle: 'Honda Civic',
//       licensePlate: 'CA-456-DEF',
//       status: BookingStatus.completed,
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'My Bookings',
//           style: TextStyle(color: Colors.black, fontSize: 18),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: const Color(0xFF4CB8B3),
//           unselectedLabelColor: Colors.grey[600],
//           indicatorColor: const Color(0xFF4CB8B3),
//           indicatorWeight: 3,
//           labelStyle: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//           tabs: const [Tab(text: 'Active'), Tab(text: 'Past')],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildBookingsList(_activeBookings, true),
//           _buildBookingsList(_pastBookings, false),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingsList(List<Booking> bookings, bool isActive) {
//     if (bookings.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.calendar_today_outlined,
//               size: 70,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               isActive ? 'No active bookings' : 'No past bookings',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               isActive
//                   ? 'Book a parking spot to see it here'
//                   : 'Your booking history will appear here',
//               style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             if (isActive)
//               ElevatedButton(
//                 onPressed: () {
//                   // Navigate to home screen
//                   Navigator.of(context).popUntil((route) => route.isFirst);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4CB8B3),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 child: const Text(
//                   'Find Parking',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: bookings.length,
//       itemBuilder: (context, index) {
//         return _buildBookingCard(bookings[index], isActive);
//       },
//     );
//   }

//   Widget _buildBookingCard(Booking booking, bool isActive) {
//     Color statusColor;
//     String statusText;

//     switch (booking.status) {
//       case BookingStatus.active:
//         statusColor = Colors.green;
//         statusText = 'Active';
//         break;
//       case BookingStatus.upcoming:
//         statusColor = const Color(0xFF4CB8B3);
//         statusText = 'Upcoming';
//         break;
//       case BookingStatus.completed:
//         statusColor = Colors.grey;
//         statusText = 'Completed';
//         break;
//       case BookingStatus.canceled:
//         statusColor = Colors.red;
//         statusText = 'Canceled';
//         break;
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFFEDF7F7),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Booking #${booking.id}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       _formatBookingDate(booking.startDate),
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: statusColor),
//                   ),
//                   child: Text(
//                     statusText,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: statusColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.local_parking,
//                         color: const Color(0xFF4CB8B3),
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             booking.parkingName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             booking.address,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildBookingDetail(
//                         'Date & Time',
//                         _formatDateTime(booking.startDate, booking.endDate),
//                         Icons.access_time,
//                       ),
//                     ),
//                     Container(height: 40, width: 1, color: Colors.grey[300]),
//                     Expanded(
//                       child: _buildBookingDetail(
//                         'Vehicle',
//                         '${booking.vehicle}\n${booking.licensePlate}',
//                         Icons.directions_car,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Total Amount',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       '\$${booking.price}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF4CB8B3),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (isActive) const SizedBox(height: 16),
//                 if (isActive) _buildActionButtons(booking),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingDetail(String title, String value, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.grey[600], size: 18),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(Booking booking) {
//     // Different button options based on status
//     if (booking.status == BookingStatus.active) {
//       return Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {
//                 // Handle extend booking
//                 _showExtendDialog(context, booking);
//               },
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: const Color(0xFF4CB8B3),
//                 side: const BorderSide(color: Color(0xFF4CB8B3)),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               child: const Text('Extend'),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 // Navigate to directions/map
//                 _showDirectionsDialog(context, booking);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF4CB8B3),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               child: const Text('Directions'),
//             ),
//           ),
//         ],
//       );
//     } else if (booking.status == BookingStatus.upcoming) {
//       return Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {
//                 // Handle cancel booking
//                 _showCancelDialog(context, booking);
//               },
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.red,
//                 side: const BorderSide(color: Colors.red),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               child: const Text('Cancel'),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 // Handle modify booking
//                 _showModifyDialog(context, booking);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF4CB8B3),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//               ),
//               child: const Text('Modify'),
//             ),
//           ),
//         ],
//       );
//     }

//     return const SizedBox(); // No buttons for past bookings
//   }

//   String _formatBookingDate(DateTime date) {
//     return DateFormat('EEE, MMM d, yyyy').format(date);
//   }

//   String _formatDateTime(DateTime startDate, DateTime endDate) {
//     String dateStr = DateFormat('MMM d, yyyy').format(startDate);
//     String startTimeStr = DateFormat('h:mm a').format(startDate);
//     String endTimeStr = DateFormat('h:mm a').format(endDate);

//     return '$dateStr\n$startTimeStr - $endTimeStr';
//   }

//   void _showExtendDialog(BuildContext context, Booking booking) {
//     int additionalHours = 1;
//     final endTime = DateFormat('h:mm a').format(booking.endDate);
//     String newEndTime = DateFormat(
//       'h:mm a',
//     ).format(booking.endDate.add(Duration(hours: additionalHours)));

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             double additionalCost =
//                 double.parse(booking.price) /
//                 booking.endDate.difference(booking.startDate).inHours *
//                 additionalHours;

//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Extend Parking Time',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Current end time: $endTime',
//                       style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'New end time: $newEndTime',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4CB8B3),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           onPressed:
//                               additionalHours > 1
//                                   ? () {
//                                     setState(() {
//                                       additionalHours--;
//                                       // Update newEndTime
//                                       final newEnd = booking.endDate.add(
//                                         Duration(hours: additionalHours),
//                                       );
//                                       newEndTime = DateFormat(
//                                         'h:mm a',
//                                       ).format(newEnd);
//                                     });
//                                   }
//                                   : null,
//                           icon: Icon(
//                             Icons.remove_circle,
//                             color:
//                                 additionalHours > 1 ? Colors.red : Colors.grey,
//                             size: 36,
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '$additionalHours hour${additionalHours > 1 ? "s" : ""}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed:
//                               additionalHours < 5
//                                   ? () {
//                                     setState(() {
//                                       additionalHours++;
//                                       // Update newEndTime
//                                       final newEnd = booking.endDate.add(
//                                         Duration(hours: additionalHours),
//                                       );
//                                       newEndTime = DateFormat(
//                                         'h:mm a',
//                                       ).format(newEnd);
//                                     });
//                                   }
//                                   : null,
//                           icon: Icon(
//                             Icons.add_circle,
//                             color:
//                                 additionalHours < 5
//                                     ? const Color(0xFF4CB8B3)
//                                     : Colors.grey,
//                             size: 36,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Additional Cost: \$${additionalCost.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             // Process extension
//                             // In a real app, this would call a service
//                             Navigator.of(context).pop();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Parking time extended successfully',
//                                 ),
//                                 backgroundColor: Color(0xFF4CB8B3),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4CB8B3),
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                           ),
//                           child: const Text(
//                             'Confirm',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showCancelDialog(BuildContext context, Booking booking) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.warning_amber_rounded,
//                   color: Colors.orange,
//                   size: 48,
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Cancel Booking',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Are you sure you want to cancel your booking at ${booking.parkingName}?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'You will receive a refund according to our cancellation policy.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.grey[700],
//                         side: BorderSide(color: Colors.grey[400]!),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                       ),
//                       child: const Text('Keep Booking'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Process cancellation
//                         Navigator.of(context).pop();
//                         // Update booking in state
//                         setState(() {
//                           final index = _activeBookings.indexOf(booking);
//                           if (index != -1) {
//                             _activeBookings[index] = Booking(
//                               id: booking.id,
//                               parkingName: booking.parkingName,
//                               address: booking.address,
//                               startDate: booking.startDate,
//                               endDate: booking.endDate,
//                               price: booking.price,
//                               vehicle: booking.vehicle,
//                               licensePlate: booking.licensePlate,
//                               status: BookingStatus.canceled,
//                             );
//                             // Move to past bookings
//                             _pastBookings.insert(0, _activeBookings[index]);
//                             _activeBookings.removeAt(index);
//                           }
//                         });
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Booking cancelled successfully'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                       ),
//                       child: const Text('Cancel Booking'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showModifyDialog(BuildContext context, Booking booking) {
//     // For simplicity, just show a dialog indicating that modification is a complex feature
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.edit, color: Color(0xFF4CB8B3), size: 48),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Modify Booking',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'This feature would allow changing date, time, or vehicle details for your booking at ${booking.parkingName}.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4CB8B3),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 12,
//                     ),
//                   ),
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showDirectionsDialog(BuildContext context, Booking booking) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Center(
//                     child: Icon(Icons.map, size: 64, color: Colors.grey[500]),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   booking.parkingName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   booking.address,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextButton.icon(
//                       onPressed: () {
//                         // Open in maps app
//                         Navigator.of(context).pop();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Opening in Maps app...'),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.map_outlined),
//                       label: const Text('Maps'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: const Color(0xFF4CB8B3),
//                       ),
//                     ),
//                     TextButton.icon(
//                       onPressed: () {
//                         // Copy address
//                         Navigator.of(context).pop();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Address copied to clipboard'),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.copy),
//                       label: const Text('Copy'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: const Color(0xFF4CB8B3),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Data models
// // class Booking {
// //   final String id;
// //   final String parkingName;
// //   final String address;
// //   final DateTime startDate;
// //   final DateTime endDate;
// //   final String price;
// //   final String vehicle;
// //   final String licensePlate;
// //   final BookingStatus status;

// //   Booking({
// //     required this.id,
// //     required this.parkingName,
// //     required this.address,
// //     required this.startDate,
// //     required this.endDate,
// //     required this.price,
// //     required this.vehicle,
// //     required this.licensePlate,
// //     required this.status,
// //   });
// // }

// enum BookingStatus { active, upcoming, completed, canceled }
