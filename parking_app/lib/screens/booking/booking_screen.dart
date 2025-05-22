import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/models/parking.dart';
import 'package:parking_app/models/payment_method.dart';
import 'package:parking_app/services/bookings/booking_service.dart';
import 'package:parking_app/services/dio_client/dio_client.dart';

class BookingScreen extends StatefulWidget {
  final Parking parking;

  const BookingScreen({super.key, required this.parking});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 2,
    minute: TimeOfDay.now().minute,
  );

  int _selectedVehicleIndex = 0;
  int _selectedPaymentIndex = 0;

  List<Vehicle> _vehicles = []; // Will be fetched
  bool _isLoadingVehicles = true;
  String? _vehicleError;
  late final BookingService _bookingService;

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      name: 'Visa ****4582',
      icon: Icons.credit_card,
      isDefault: true,
    ),
    PaymentMethod(name: 'PayPal', icon: Icons.paypal, isDefault: false),
    PaymentMethod(name: 'Apple Pay', icon: Icons.apple, isDefault: false),
  ];

  @override
  void initState() {
    super.initState();
    _bookingService = BookingService(DioClient('http://192.168.60.201:8000'));
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() {
      _isLoadingVehicles = true;
      _vehicleError = null;
    });

    // Mock vehicle fetching (replace with actual API call)
    // For now, use hardcoded vehicles to match your original code
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    setState(() {
      _vehicles = [
        Vehicle(
          id: 1,
          userId: 1,
          name: 'Tesla Model 3',
          licensePlate: 'CA-123-ABC',
          icon: 'electric-car',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Vehicle(
          id: 2,
          userId: 1,
          name: 'Honda Civic',
          licensePlate: 'CA-456-DEF',
          icon: 'car-sedan',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      _isLoadingVehicles = false;
    });

    // TODO: Replace with actual API call
    // final response = await _dioClient.get('/api/vehicles');
    // if (response.success) {
    //   _vehicles = response.data.map((json) => Vehicle.fromJson(json)).toList();
    // } else {
    //   _vehicleError = response.message;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total hours and price
    double totalHours = _calculateTotalHours();
    double totalPrice =
        totalHours *
        (widget.parking.pricePerHour / 1000); // Convert cents to dollars

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildParkingDetails(),
            const SizedBox(height: 16),
            _buildDateTimeSelection(),
            const SizedBox(height: 16),
            _buildVehicleSelection(),
            const SizedBox(height: 16),
            _buildPaymentMethod(),
            const SizedBox(height: 16),
            _buildPriceSummary(totalHours, totalPrice),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(totalPrice),
    );
  }

  Widget _buildParkingDetails() {
    // Mock rating and imageUrl
    const double rating = 4.5;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_parking,
                    size: 40,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.parking.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.parking.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '$rating',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '\$${(widget.parking.pricePerHour / 1000).toStringAsFixed(2)}/hr',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7F7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4CB8B3).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF4CB8B3),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.parking.availableSpots}/${widget.parking.totalSlots} parking spots available',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CB8B3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date & Time',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600]),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectTime(context, true),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _startTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.access_time, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End Time',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectTime(context, false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _endTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.access_time, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vehicle',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF4CB8B3),
                  size: 16,
                ),
                label: const Text(
                  'Add Vehicle',
                  style: TextStyle(color: Color(0xFF4CB8B3), fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _isLoadingVehicles
              ? const Center(child: CircularProgressIndicator())
              : _vehicleError != null
              ? Center(child: Text(_vehicleError!))
              : SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    final isSelected = index == _selectedVehicleIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVehicleIndex = index;
                        });
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF4CB8B3)
                                    : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color:
                              isSelected
                                  ? const Color(0xFFEDF7F7)
                                  : Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  vehicle.iconData,
                                  color:
                                      isSelected
                                          ? const Color(0xFF4CB8B3)
                                          : Colors.grey[600],
                                  size: 28,
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF4CB8B3),
                                    size: 20,
                                  ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              vehicle.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? const Color(0xFF4CB8B3)
                                        : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              vehicle.licensePlate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  // Handle add payment
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFF4CB8B3),
                  size: 16,
                ),
                label: const Text(
                  'Add New',
                  style: TextStyle(color: Color(0xFF4CB8B3), fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paymentMethods.length,
            itemBuilder: (context, index) {
              final payment = _paymentMethods[index];
              final isSelected = index == _selectedPaymentIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPaymentIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF4CB8B3)
                              : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? const Color(0xFFEDF7F7) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        payment.icon,
                        color:
                            isSelected
                                ? const Color(0xFF4CB8B3)
                                : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? const Color(0xFF4CB8B3)
                                        : Colors.black,
                              ),
                            ),
                            if (payment.isDefault) const SizedBox(height: 4),
                            if (payment.isDefault)
                              const Text(
                                'Default Payment Method',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF4CB8B3),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(double totalHours, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Parking Rate',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                '\$${(widget.parking.pricePerHour / 1000).toStringAsFixed(2)}/hour',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Duration',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                '${totalHours.toStringAsFixed(1)} hours',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Fee',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Text(
                '\$1.00',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${(totalPrice + 1.0).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CB8B3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            _confirmBooking();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CB8B3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'Confirm Booking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CB8B3)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CB8B3)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // Ensure end time is after start time
          if (_calculateTotalMinutes(_endTime) <=
              _calculateTotalMinutes(_startTime)) {
            _endTime = TimeOfDay(
              hour: (_startTime.hour + 2) % 24,
              minute: _startTime.minute,
            );
          }
        } else {
          // Only set end time if it's after start time
          if (_calculateTotalMinutes(picked) >
              _calculateTotalMinutes(_startTime)) {
            _endTime = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End time must be after start time'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    }
  }

  int _calculateTotalMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  double _calculateTotalHours() {
    int startMinutes = _calculateTotalMinutes(_startTime);
    int endMinutes = _calculateTotalMinutes(_endTime);

    // Handle case where end time is on the next day
    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60; // Add 24 hours
    }

    return (endMinutes - startMinutes) / 60.0;
  }

  void _confirmBooking() async {
    if (_vehicles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a vehicle'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    final response = await _bookingService.createBooking(
      parkingId: widget.parking.id,
      vehicleId: _vehicles[_selectedVehicleIndex].id,
      startTime: startDateTime,
      endTime: endDateTime,
    );

    if (response.success) {
      _showBookingConfirmation(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message!), backgroundColor: Colors.red),
      );
    }
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDF7F7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF4CB8B3),
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have successfully booked a parking spot at ${widget.parking.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildConfirmationDetail(
                        'Date',
                        DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                      ),
                      const SizedBox(height: 8),
                      _buildConfirmationDetail(
                        'Time',
                        '${_startTime.format(context)} - ${_endTime.format(context)}',
                      ),
                      const SizedBox(height: 8),
                      _buildConfirmationDetail(
                        'Vehicle',
                        _vehicles[_selectedVehicleIndex].name,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CB8B3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'View My Bookings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

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
