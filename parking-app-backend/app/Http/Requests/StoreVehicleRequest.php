<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreVehicleRequest extends FormRequest
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
     * @return array<string,
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:50',
            'license_plate' => 'required|string|max:20|unique:vehicles',
            'icon' => 'nullable|string|max:255',
        ];
    }
}