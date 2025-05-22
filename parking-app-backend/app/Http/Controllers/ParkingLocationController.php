<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreParkingLocationRequest;
use App\Http\Resources\ParkingLocationResource;
use App\Models\ParkingLocation;
use App\Models\ParkingReview;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ParkingLocationController extends Controller
{
    public function index(Request $request)
    {
        $query = ParkingLocation::query();

        // Distance-based filtering (your existing code)
        if ($request->filled(["lat", "lng"])) {
            $lat = $request->float("lat");
            $lng = $request->float("lng");
            $radius = $request->input("radius", 10);

            $haversine = "(
                6371 * acos(
                    cos(radians($lat)) * cos(radians(lat)) * cos(radians(lng) - radians($lng))
                    + sin(radians($lat)) * sin(radians(lat))
                )
            )";
            $query
                ->select("*")
                ->selectRaw("{$haversine} AS distance")
                ->having("distance", "<", $radius)
                ->orderBy("distance");
        }

        // Search by name or address
        if ($request->filled("search")) {
            $search = $request->input("search");
            $query->where(function ($q) use ($search) {
                $q->where("name", "like", "%{$search}%")->orWhere(
                    "address",
                    "like",
                    "%{$search}%"
                );
            });
        }

        // Filter by features
        if (
            $request->filled("features") &&
            is_array($request->input("features"))
        ) {
            foreach ($request->input("features") as $feature) {
                $query->whereJsonContains("features", $feature);
            }
        }

        // Filter by minimum rating
        if ($request->filled("min_rating")) {
            $query->where("rating", ">=", $request->float("min_rating"));
        }

        // Filter by price range
        if ($request->filled("min_price")) {
            $query->where("price_per_hour", ">=", $request->float("min_price"));
        }
        if ($request->filled("max_price")) {
            $query->where("price_per_hour", "<=", $request->float("max_price"));
        }

        // Filter by availability
        if (
            $request->filled("available_only") &&
            $request->boolean("available_only")
        ) {
            $requiredSlots = $request->input("required_slots", 1);
            $query->available($requiredSlots);
        }

        // Sort options
        $sortBy = $request->input("sort_by", "name");
        $sortOrder = $request->input("sort_order", "asc");

        switch ($sortBy) {
            case "price":
                $query->orderBy("price_per_hour", $sortOrder);
                break;
            case "rating":
                $query->orderBy(
                    "rating",
                    $sortOrder === "asc" ? "desc" : "asc"
                );
                break;
            case "availability":
                $query->orderByRaw('COALESCE(available_spots, total_slots - (
                    SELECT COUNT(*)
                    FROM bookings
                    WHERE bookings.parking_location_id = parking_locations.id
                    AND bookings.status = "active"
                    AND bookings.start_time <= NOW()
                    AND bookings.end_time >= NOW()
                )) DESC');
                break;
            case "total_slots":
                $query->orderBy("total_slots", $sortOrder);
                break;
            default:
                if (!$request->filled(["lat", "lng"])) {
                    $query->orderBy("name", $sortOrder);
                }
        }

        // Pagination
        $perPage = $request->input("per_page", 15);
        if ($request->filled("paginate") && !$request->boolean("paginate")) {
            $parkings = $query->get();
            return ["data" => ParkingLocationResource::collection($parkings)];
        }

        $parkings = $query->paginate($perPage);

        return [
            "data" => ParkingLocationResource::collection($parkings->items()),
            "pagination" => [
                "current_page" => $parkings->currentPage(),
                "last_page" => $parkings->lastPage(),
                "per_page" => $parkings->perPage(),
                "total" => $parkings->total(),
                "from" => $parkings->firstItem(),
                "to" => $parkings->lastItem(),
            ],
        ];
    }

    public function show($id)
    {
        $parking = ParkingLocation::with([
            "reviews" => function ($query) {
                $query->with("user:id,name,email")->latest()->limit(10);
            },
        ])->findOrFail($id);

        return new ParkingLocationResource($parking);
    }

    public function store(StoreParkingLocationRequest $request)
    {
        $validated = $request->validated();

        // Set default available_spots if not provided
        if (!isset($validated["available_spots"])) {
            $validated["available_spots"] = $validated["total_slots"];
        }

        if (
            isset($validated["features"]) &&
            is_string($validated["features"])
        ) {
            $validated["features"] =
                json_decode($validated["features"], true) ?: [];
        }

        $parking = ParkingLocation::create($validated);

        return new ParkingLocationResource($parking);
    }

    public function update(StoreParkingLocationRequest $request, $id)
    {
        $parking = ParkingLocation::findOrFail($id);
        $validated = $request->validated();

        // Handle features conversion if needed
        if (
            isset($validated["features"]) &&
            is_string($validated["features"])
        ) {
            $validated["features"] =
                json_decode($validated["features"], true) ?: [];
        }

        // Validate available_spots doesn't exceed total_slots
        if (
            isset($validated["available_spots"]) &&
            isset($validated["total_slots"])
        ) {
            if ($validated["available_spots"] > $validated["total_slots"]) {
                return response()->json(
                    [
                        "message" =>
                            "Available spots cannot exceed total slots",
                        "errors" => [
                            "available_spots" => [
                                "Available spots cannot exceed total slots",
                            ],
                        ],
                    ],
                    422
                );
            }
        } elseif (isset($validated["available_spots"])) {
            if ($validated["available_spots"] > $parking->total_slots) {
                return response()->json(
                    [
                        "message" =>
                            "Available spots cannot exceed total slots",
                        "errors" => [
                            "available_spots" => [
                                "Available spots cannot exceed total slots",
                            ],
                        ],
                    ],
                    422
                );
            }
        }

        $parking->update($validated);

        return new ParkingLocationResource($parking->fresh());
    }

    public function destroy($id)
    {
        $parking = ParkingLocation::findOrFail($id);

        // Check if there are active bookings
        if (
            method_exists($parking, "activeBookings") &&
            $parking->activeBookings()->count() > 0
        ) {
            return response()->json(
                [
                    "message" =>
                        "Cannot delete parking location with active bookings",
                ],
                422
            );
        }

        $parking->delete();

        return response()->json(null, 204);
    }

    /**
     * Add or update a review for a parking location
     */
    public function addReview(Request $request, $id): JsonResponse
    {
        $request->validate([
            "rating" => "required|integer|between:1,5",
            "comment" => "nullable|string|max:500",
            "booking_id" => "nullable|exists:bookings,id",
        ]);

        $parking = ParkingLocation::findOrFail($id);

        // Assuming you have authentication middleware
        $userId = auth()->id();
        if (!$userId) {
            return response()->json(
                ["message" => "Authentication required"],
                401
            );
        }

        $review = ParkingReview::updateOrCreate(
            [
                "user_id" => $userId,
                "parking_location_id" => $id,
            ],
            [
                "rating" => $request->input("rating"),
                "comment" => $request->input("comment"),
                "booking_id" => $request->input("booking_id"),
            ]
        );

        return response()->json([
            "message" => "Review added successfully",
            "data" => $review->load("user:id,name,email"),
        ]);
    }

    /**
     * Get available features for filtering
     */
    public function getFeatures(): JsonResponse
    {
        try {
            $features = ParkingLocation::whereNotNull("features")
                ->pluck("features")
                ->flatten()
                ->unique()
                ->values()
                ->sort();

            return response()->json([
                "success" => true,
                "data" => $features,
            ]);
        } catch (\Exception $e) {
            return response()->json(
                [
                    "success" => false,
                    "message" => "Failed to retrieve features",
                ],
                500
            );
        }
    }

    /**
     * Get parking statistics
     */
    public function getStats(): JsonResponse
    {
        try {
            $stats = [
                "total_locations" => ParkingLocation::count(),
                "total_capacity" => ParkingLocation::sum("total_slots"),
                "average_price" => ParkingLocation::avg("price_per_hour"),
                "average_rating" => ParkingLocation::where(
                    "rating",
                    ">",
                    0
                )->avg("rating"),
                "top_features" => ParkingLocation::whereNotNull("features")
                    ->pluck("features")
                    ->flatten()
                    ->countBy()
                    ->sortDesc()
                    ->take(10),
            ];

            return response()->json([
                "success" => true,
                "data" => $stats,
            ]);
        } catch (\Exception $e) {
            return response()->json(
                [
                    "success" => false,
                    "message" => "Failed to retrieve statistics",
                ],
                500
            );
        }
    }

    /**
     * Update available spots for a parking location
     */
    public function updateAvailability(Request $request, $id): JsonResponse
    {
        $request->validate([
            "available_spots" => "required|integer|min:0",
        ]);

        $parking = ParkingLocation::findOrFail($id);

        if ($request->input("available_spots") > $parking->total_slots) {
            return response()->json(
                [
                    "message" => "Available spots cannot exceed total slots",
                ],
                422
            );
        }

        $parking->update([
            "available_spots" => $request->input("available_spots"),
        ]);

        return response()->json([
            "message" => "Availability updated successfully",
            "data" => new ParkingLocationResource($parking->fresh()),
        ]);
    }
}
