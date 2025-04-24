<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    use HasFactory;
    
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',
        'parking_location_id',
        'vehicle_id',
        'start_time',
        'end_time',
        'status',
        'duration_hours',
        'total_price'
    ];
    
    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'start_time' => 'datetime',
        'end_time' => 'datetime',
        'duration_hours' => 'integer',
        'total_price' => 'decimal:2',
    ];
    
    /**
     * Possible booking statuses
     */
    const STATUS_BOOKED = 'booked';
    const STATUS_IN_PROGRESS = 'in_progress';
    const STATUS_COMPLETED = 'completed';
    const STATUS_CANCELLED = 'cancelled';
    
    /**
     * Get the user that owns the booking.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }
    
    /**
     * Get the parking location for this booking.
     */
    public function parkingLocation()
    {
        return $this->belongsTo(ParkingLocation::class);
    }
    
    /**
     * Get the vehicle for this booking.
     */
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class);
    }
    
    /**
     * Scope a query to only include active bookings.
     *
     * @param  \Illuminate\Database\Eloquent\Builder  $query
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function scopeActive($query)
    {
        return $query->whereIn('status', [self::STATUS_BOOKED, self::STATUS_IN_PROGRESS]);
    }
    
    /**
     * Check if booking is active
     *
     * @return bool
     */
    public function isActive()
    {
        return in_array($this->status, [self::STATUS_BOOKED, self::STATUS_IN_PROGRESS]);
    }
    
    /**
     * Check if booking can be extended
     *
     * @return bool
     */
    public function canBeExtended()
    {
        return $this->isActive() && !now()->isAfter($this->end_time);
    }
    
    /**
     * Check if booking can be cancelled
     *
     * @return bool
     */
    public function canBeCancelled()
    {
        return $this->status === self::STATUS_BOOKED && now()->isBefore($this->start_time);
    }
}
