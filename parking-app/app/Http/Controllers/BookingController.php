<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\ParkingLocation;
use App\Models\Vehicle;
use App\Http\Requests\StoreBookingRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class BookingController extends Controller
{
    /**
     * Display a listing of the user's bookings.
     */
    public function index()
    {
        // Modified to avoid using the relationship directly
        $userId = Auth::id();
        $bookings = Booking::where('user_id', $userId)
            ->with(['parkingLocation', 'vehicle'])
            ->latest()
            ->get();
            
        return response()->json([
            'data' => $bookings
        ]);
    }

    /**
     * Store a newly created booking.
     */
    public function store(StoreBookingRequest $request)
    {
        // Get the validated data
        $validated = $request->validated();
        
        // Get the parking location
        $parkingLocation = ParkingLocation::findOrFail($validated['parking_location_id']);
        
        // Check if the parking location has available spots
        if ($parkingLocation->total_slots <= 0) {
            return response()->json([
                'message' => 'No available parking spots at this location'
            ], 422);
        }
        
        // Check if vehicle belongs to the user using direct query
        $userId = Auth::id();
        $vehicle = Vehicle::where('user_id', $userId)
            ->where('id', $validated['vehicle_id'])
            ->firstOrFail();
        
        // Calculate the duration and total price - FIX: Use diffInHours() correctly
        $startTime = Carbon::parse($validated['start_time']);
        $endTime = Carbon::parse($validated['end_time']);
        $durationHours = $startTime->diffInHours($endTime);  // Changed order to get positive value
        $totalPrice = $parkingLocation->price_per_hour * $durationHours;
        
        // Create the booking
        $booking = Booking::create([
            'user_id' => $userId,
            'parking_location_id' => $validated['parking_location_id'],
            'vehicle_id' => $validated['vehicle_id'],
            'start_time' => $startTime,
            'end_time' => $endTime,
            'duration_hours' => $durationHours,
            'total_price' => $totalPrice,
            'status' => 'booked',  // Changed from 'confirmed' to match enum values
        ]);
        
        // Decrement available spots
        $parkingLocation->decrement('total_slots');
        
        return response()->json([
            'message' => 'Booking created successfully',
            'data' => $booking->load(['parkingLocation', 'vehicle'])
        ], 201);
    }

    /**
     * Display the specified booking.
     */
    public function show(string $id)
    {
        // Modified to avoid using the relationship directly
        $userId = Auth::id();
        $booking = Booking::where('user_id', $userId)
            ->where('id', $id)
            ->with(['parkingLocation', 'vehicle'])
            ->firstOrFail();
            
        return response()->json([
            'data' => $booking
        ]);
    }

    /**
     * Extend an existing booking.
     */
    public function extend(Request $request, string $id)
    {
        $request->validate([
            'extend_hours' => 'required|integer|min:1|max:24',
        ]);
        
        // Find the booking using direct query
        $userId = Auth::id();
        $booking = Booking::where('user_id', $userId)
            ->where('id', $id)
            ->firstOrFail();
        
        // Check if booking is active
        if ($booking->status !== 'booked' || Carbon::parse($booking->end_time)->isPast()) {
            return response()->json([
                'message' => 'Cannot extend a completed or cancelled booking'
            ], 422);
        }
        
        // Get the parking location for price calculation
        $parkingLocation = ParkingLocation::findOrFail($booking->parking_location_id);
        
        // Calculate new end time and price
        $extendHours = $request->input('extend_hours');
        $newEndTime = Carbon::parse($booking->end_time)->addHours($extendHours);
        $additionalPrice = $parkingLocation->price_per_hour * $extendHours;
        
        // Update the booking
        $booking->update([
            'end_time' => $newEndTime,
            'duration_hours' => $booking->duration_hours + $extendHours,
            'total_price' => $booking->total_price + $additionalPrice,
        ]);
        
        return response()->json([
            'message' => 'Booking extended successfully',
            'data' => $booking->load(['parkingLocation', 'vehicle'])
        ]);
    }
}