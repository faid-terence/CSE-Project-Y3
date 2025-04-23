<?php


namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreParkingLocationRequest;
use App\Http\Resources\ParkingLocationResource;
use App\Models\ParkingLocation;
use Illuminate\Http\Request;

class ParkingLocationController extends Controller
{
    public function index(Request $request)
    {
        $query = ParkingLocation::query();

        if ($request->filled(['lat', 'lng'])) {
            $lat = $request->float('lat');
            $lng = $request->float('lng');
            $radius = $request->input('radius', 10);

            $haversine = "(
                6371 * acos(
                    cos(radians($lat)) * cos(radians(lat)) * cos(radians(lng) - radians($lng))
                    + sin(radians($lat)) * sin(radians(lat))
                )
            )";

            $query->select('*')
                  ->selectRaw("{$haversine} AS distance")
                  ->having('distance', '<', $radius);
        }

        return ParkingLocationResource::collection($query->paginate());
    }

    public function show($id)
    {
        $parking = ParkingLocation::findOrFail($id);
        return new ParkingLocationResource($parking);
    }

    public function store(StoreParkingLocationRequest $request)
    {
        $parking = ParkingLocation::create($request->validated());
        return new ParkingLocationResource($parking);
    }

    public function update(StoreParkingLocationRequest $request, $id)
    {
        $parking = ParkingLocation::findOrFail($id);
        $parking->update($request->validated());
        return new ParkingLocationResource($parking);
    }

    public function destroy($id)
    {
        $parking = ParkingLocation::findOrFail($id);
        $parking->delete();

        return response()->json(null, 204);
    }
}

