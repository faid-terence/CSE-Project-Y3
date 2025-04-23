<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\VehicleController;
use App\Http\Controllers\ParkingLocationController;
use App\Http\Controllers\BookingController;

// Public parking listings
Route::get('parkings', [ParkingLocationController::class, 'index']);
Route::get('parkings/{id}', [ParkingLocationController::class, 'show']);

// Authentication
Route::post('register', [AuthController::class, 'register']);
Route::post('login',    [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // Vehicles CRUD
    Route::apiResource('vehicles', VehicleController::class);

    // Bookings: list, view, create, extend
    Route::get('bookings',             [BookingController::class, 'index']);
    Route::get('bookings/{id}',        [BookingController::class, 'show']);
    Route::post('bookings',            [BookingController::class, 'store']);
    Route::post('bookings/{id}/extend', [BookingController::class, 'extend']);

    // Admin-only parking management (create/update/delete)
    Route::middleware('can:admin')->group(function () {
        Route::post('parkings',          [ParkingLocationController::class, 'store']);
        Route::put('parkings/{id}',      [ParkingLocationController::class, 'update']);
        Route::delete('parkings/{id}',   [ParkingLocationController::class, 'destroy']);
    });

    // Logout
    Route::post('logout', [AuthController::class, 'logout']);
});