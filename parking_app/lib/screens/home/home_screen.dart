import 'package:flutter/material.dart';
import 'package:parking_app/models/parking_location.dart';
import 'package:parking_app/models/recent_parking.dart';
import 'package:parking_app/screens/booking/booking_screen.dart';
import 'package:parking_app/screens/booking/my_bookings_screen.dart';
import 'package:parking_app/screens/home/profile_screen.dart';
import 'package:parking_app/screens/home/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildHomeContent(),
      const SearchScreen(),
      const BookingsScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildNearbyParkings(),
            _buildRecentParkings(),
          ],
        ),
      ),
    );
  }

  // List of nearby parking locations
  final List<ParkingLocation> _nearbyParkings = [
    ParkingLocation(
      name: 'City Center Parking',
      address: '123 Main St, Downtown',
      distance: '0.5',
      price: '2.50',
      available: 8,
      total: 20,
      rating: 4.7,
      imageUrl: 'assets/images/parking_1_thumb.png',
    ),
    ParkingLocation(
      name: 'West Plaza Garage',
      address: '456 Oak Ave, Westside',
      distance: '0.8',
      price: '3.00',
      available: 15,
      total: 45,
      rating: 4.5,
      imageUrl: 'assets/images/parking_2_thumb.png',
    ),
    ParkingLocation(
      name: 'North Station Parking',
      address: '789 Pine Rd, Northside',
      distance: '1.2',
      price: '2.00',
      available: 5,
      total: 30,
      rating: 4.2,
      imageUrl: 'assets/images/parking_3_thumb.png',
    ),
  ];

  // List of recent parkings
  final List<RecentParking> _recentParkings = [
    RecentParking(
      name: 'Shopping Mall Parking',
      date: 'Yesterday, 15:30',
      price: '4.50',
      imageUrl: 'assets/images/parking_recent_1.png',
    ),
    RecentParking(
      name: 'Airport Terminal Parking',
      date: 'Apr 15, 2025, 08:20',
      price: '12.75',
      imageUrl: 'assets/images/parking_recent_2.png',
    ),
  ];

  void navigateToBooking(
    BuildContext context,
    ParkingLocation parkingLocation,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(parkingLocation: parkingLocation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF4CB8B3),
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookings',
            tooltip: "View your bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Location',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF4CB8B3),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'San Francisco, CA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Handle profile tap
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4CB8B3),
                      width: 2,
                    ),
                  ),
                  child: Icon(Icons.person, color: Colors.grey[700], size: 30),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600], size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Search for parking',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4CB8B3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.filter_list, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyParkings() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby Parking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Handle see all tap
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4CB8B3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _nearbyParkings.length,
              itemBuilder: (context, index) {
                return _buildParkingCard(_nearbyParkings[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingCard(ParkingLocation parking) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parking image
          SizedBox(
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.local_parking,
                      color: Colors.grey[500],
                      size: 40,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            parking.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parking.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          parking.address,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip('${parking.distance} km'),
                      const SizedBox(width: 8),
                      _buildInfoChip('\$${parking.price}/hr'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${parking.available}/${parking.total} spots',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CB8B3),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CB8B3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            navigateToBooking(context, parking);
                          },
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildRecentParkings() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Parkings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Handle see all tap
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4CB8B3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._recentParkings.map((parking) => _buildRecentParkingItem(parking)),
        ],
      ),
    );
  }

  Widget _buildRecentParkingItem(RecentParking parking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.local_parking,
                color: Colors.grey[500],
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parking.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  parking.date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${parking.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CB8B3),
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  // Handle rebook action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4CB8B3),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  minimumSize: const Size(0, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Color(0xFF4CB8B3)),
                  ),
                ),
                child: const Text(
                  'Rebook',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
