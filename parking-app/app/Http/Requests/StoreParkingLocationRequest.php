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
        return [
            'name' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'city' => 'nullable|string|max:100',
            'lat' => 'required|numeric',
            'lng' => 'required|numeric',
            'price_per_hour' => 'required|numeric|min:0',
            'total_slots' => 'required|integer|min:0',
            'available_spots' => 'nullable|integer|min:0',
            'features' => 'nullable|array',
        ];
    }

     /**
     * Prepare the data for validation.
     *
     * @return void
     */
    protected function prepareForValidation()
    {
        if (!$this->has('available_spots') && $this->has('total_slots')) {
            $this->merge([
                'available_spots' => $this->total_slots,
            ]);
        }
    }
}
