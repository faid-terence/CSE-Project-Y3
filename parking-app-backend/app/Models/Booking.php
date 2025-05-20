<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    use HasFactory;
    

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
    

    protected $casts = [
        'start_time' => 'datetime',
        'end_time' => 'datetime',
        'duration_hours' => 'integer',
        'total_price' => 'decimal:2',
    ];
    
    /**
     * The status of the booking.
     */
    const STATUS_BOOKED = 'booked';
    const STATUS_IN_PROGRESS = 'in_progress';
    const STATUS_COMPLETED = 'completed';
    const STATUS_CANCELLED = 'cancelled';
    

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
    
  
    public function scopeActive($query)
    {
        return $query->whereIn('status', [self::STATUS_BOOKED, self::STATUS_IN_PROGRESS]);
    }
    

    public function isActive()
    {
        return in_array($this->status, [self::STATUS_BOOKED, self::STATUS_IN_PROGRESS]);
    }
    

    public function canBeExtended()
    {
        return $this->isActive() && !now()->isAfter($this->end_time);
    }
    
    public function canBeCancelled()
    {
        return $this->status === self::STATUS_BOOKED && now()->isBefore($this->start_time);
    }
}
