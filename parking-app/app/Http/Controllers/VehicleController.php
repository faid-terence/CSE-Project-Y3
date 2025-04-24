<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreVehicleRequest;
use App\Http\Resources\VehicleResource;
use App\Models\Vehicle;
use Illuminate\Http\Request;

class VehicleController extends Controller
{
    public function index(Request $request)
    {
        $vehicles = $request->user()->vehicles;
        return VehicleResource::collection($vehicles);
    }

    public function store(StoreVehicleRequest $request)
    {
        $data = array_merge($request->validated(), ['user_id' => $request->user()->id]);
        $vehicle = Vehicle::create($data);
        return new VehicleResource($vehicle);
    }

    public function show($id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $this->authorize('view', $vehicle);
        return new VehicleResource($vehicle);
    }

    public function update(StoreVehicleRequest $request, $id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $this->authorize('update', $vehicle);
        $vehicle->update($request->validated());
        return new VehicleResource($vehicle);
    }

    public function destroy($id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $this->authorize('delete', $vehicle);
        $vehicle->delete();
        return response()->json(null, 204);
    }

    public function getUserVehicles(Request $request)
{
    $user = $request->user();
    $vehicles = $user->vehicles()->get();
    
    return response()->json([
        'status' => 'success',
        'data' => $vehicles
    ]);
}
}