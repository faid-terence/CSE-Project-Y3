<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreParkingLocationRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $rules = [
            "name" => "required|string|max:255",
            "address" => "required|string|max:500",
            "lat" => "required|numeric|between:-90,90",
            "lng" => "required|numeric|between:-180,180",
            "price_per_hour" => "required|numeric|min:0",
            "total_slots" => "required|integer|min:1",
            "description" => "nullable|string|max:1000",
            "features" => "nullable|array",
            "features.*" => "string|max:100",
            "available_spots" => "nullable|integer|min:0",
        ];
        if ($this->isMethod("PUT") || $this->isMethod("PATCH")) {
            $rules = array_map(function ($rule) {
                if (is_string($rule) && strpos($rule, "required") === 0) {
                    return "sometimes|" . substr($rule, 9);
                }
                return $rule;
            }, $rules);
        }

        return $rules;
    }

    /**
     * Get custom validation messages
     */
    public function messages(): array
    {
        return [
            "name.required" => "Parking location name is required",
            "address.required" => "Address is required",
            "lat.required" => "Latitude is required",
            "lng.required" => "Longitude is required",
            "lat.between" => "Latitude must be between -90 and 90",
            "lng.between" => "Longitude must be between -180 and 180",
            "price_per_hour.required" => "Price per hour is required",
            "price_per_hour.min" => "Price per hour must be at least 0",
            "total_slots.required" => "Total slots is required",
            "total_slots.min" => "Total slots must be at least 1",
            "available_spots.min" => "Available spots cannot be negative",
            "features.array" => "Features must be an array",
            "features.*.string" => "Each feature must be a string",
            "features.*.max" => "Each feature cannot exceed 100 characters",
            "description.max" => "Description cannot exceed 1000 characters",
        ];
    }

    /**
     * Configure the validator instance.
     */
    public function withValidator($validator)
    {
        $validator->after(function ($validator) {
            // available_spots cannot exceed total_slots
            if ($this->filled(["available_spots", "total_slots"])) {
                if (
                    $this->input("available_spots") >
                    $this->input("total_slots")
                ) {
                    $validator
                        ->errors()
                        ->add(
                            "available_spots",
                            "Available spots cannot exceed total slots"
                        );
                }
            }
        });
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation()
    {
        if ($this->has("features") && is_string($this->input("features"))) {
            $this->merge([
                "features" => json_decode($this->input("features"), true) ?: [],
            ]);
        }

        // Ensure numeric values are properly cast
        if ($this->has("lat")) {
            $this->merge(["lat" => (float) $this->input("lat")]);
        }
        if ($this->has("lng")) {
            $this->merge(["lng" => (float) $this->input("lng")]);
        }
        if ($this->has("price_per_hour")) {
            $this->merge([
                "price_per_hour" => (float) $this->input("price_per_hour"),
            ]);
        }
    }
}
