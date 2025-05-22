<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up()
    {
        Schema::table("parking_locations", function (Blueprint $table) {
            $table
                ->integer("available_slots")
                ->default(1)
                ->nullable()
                ->change();
        });
    }

    public function down()
    {
        Schema::table("parking_locations", function (Blueprint $table) {
            $table->integer("available_slots")->nullable()->change();
        });
    }
};
