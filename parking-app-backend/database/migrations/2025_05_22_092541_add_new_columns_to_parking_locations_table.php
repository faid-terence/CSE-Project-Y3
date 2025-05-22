<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table("parking_locations", function (Blueprint $table) {
            $table->text("description")->nullable()->after("total_slots");
            $table->json("features")->nullable()->after("description");
            $table->decimal("rating", 2, 1)->default(0.0)->after("features");
            $table->integer("rating_count")->default(0)->after("rating");
            $table
                ->integer("available_slots")
                ->nullable()
                ->after("rating_count");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table("parking_locations", function (Blueprint $table) {
            $table->dropColumn([
                "description",
                "features",
                "rating",
                "rating_count",
                "available_slots",
            ]);
        });
    }
};
