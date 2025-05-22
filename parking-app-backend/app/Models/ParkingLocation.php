<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ParkingLocation extends Model
{
    use HasFactory;

    protected $fillable = [
        "name",
        "address",
        "lat",
        "lng",
        "price_per_hour",
        "total_slots",
        "description",
        "features",
        "rating",
        "rating_count",
        "available_slots",
    ];

    protected $casts = [
        "lat" => "decimal:8",
        "lng" => "decimal:8",
        "price_per_hour" => "decimal:2",
        "rating" => "decimal:1",
        "features" => "array",
    ];

    protected $appends = ["calculated_available_slots", "occupancy_rate"];

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function reviews()
    {
        return $this->hasMany(ParkingReview::class);
    }

    // Get current active bookings
    public function activeBookings()
    {
        return $this->hasMany(Booking::class)
            ->where("status", "active")
            ->where("start_time", "<=", now())
            ->where("end_time", ">=", now());
    }

    // Calculate available slots based on active bookings
    public function getCalculatedAvailableSlotsAttribute()
    {
        if ($this->available_slots !== null) {
            return $this->available_slots;
        }

        $activeBookingsCount = $this->activeBookings()->count();
        return max(0, $this->total_slots - $activeBookingsCount);
    }

    // Calculate occupancy rate
    public function getOccupancyRateAttribute()
    {
        $available = $this->calculated_available_slots;
        return $this->total_slots > 0
            ? round(
                (($this->total_slots - $available) / $this->total_slots) * 100,
                1
            )
            : 0;
    }

    // Update rating based on reviews
    public function updateRating()
    {
        $reviews = $this->reviews();
        $averageRating = $reviews->avg("rating");
        $reviewCount = $reviews->count();

        $this->update([
            "rating" => $averageRating ? round($averageRating, 1) : 0,
            "rating_count" => $reviewCount,
        ]);
    }

    // Scope for filtering by features
    public function scopeWithFeatures($query, array $features)
    {
        return $query->whereJsonContains("features", $features);
    }

    // Scope for filtering by rating
    public function scopeWithMinRating($query, $minRating)
    {
        return $query->where("rating", ">=", $minRating);
    }

    // Scope for available parking only
    public function scopeAvailable($query, $requiredSlots = 1)
    {
        return $query->whereRaw(
            '
            COALESCE(available_slots, total_slots - (
                SELECT COUNT(*)
                FROM bookings
                WHERE bookings.parking_location_id = parking_locations.id
                AND bookings.status = "active"
                AND bookings.start_time <= NOW()
                AND bookings.end_time >= NOW()
            )) >= ?',
            [$requiredSlots]
        );
    }
}
