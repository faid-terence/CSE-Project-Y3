<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\VehicleController;
use App\Http\Controllers\ParkingLocationController;
use App\Http\Controllers\BookingController;

Route::get('parkings', [ParkingLocationController::class, 'index']);
Route::get('parkings/{id}', [ParkingLocationController::class, 'show']);


Route::post('register', [AuthController::class, 'register']);
Route::post('login',    [AuthController::class, 'login']);


Route::middleware('auth:sanctum')->group(function () {
    Route::get('user/vehicles', [VehicleController::class, 'getUserVehicles']);
   
    Route::apiResource('vehicles', VehicleController::class);

   
    Route::get('bookings',             [BookingController::class, 'index']);
    Route::get('bookings/{id}',        [BookingController::class, 'show']);
    Route::post('bookings',            [BookingController::class, 'store']);
    Route::post('bookings/{id}/extend', [BookingController::class, 'extend']);
    Route::middleware('can:admin')->group(function () {
        Route::post('parkings',          [ParkingLocationController::class, 'store']);
        Route::put('parkings/{id}',      [ParkingLocationController::class, 'update']);
        Route::delete('parkings/{id}',   [ParkingLocationController::class, 'destroy']);
    });
    Route::post('logout', [AuthController::class, 'logout']);
});