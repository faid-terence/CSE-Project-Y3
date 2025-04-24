<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ParkingLocation extends Model
{
    protected $fillable = [
        'name',
        'address',
        'lat',
        'lng',
        'price_per_hour',
        'total_slots',
    ];

    public function bookings()
    {
        return $this->hasMany(Booking::class);
    }
}
