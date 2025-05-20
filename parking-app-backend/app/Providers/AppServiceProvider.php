<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Route;
use App\Models\User;

class AppServiceProvider extends ServiceProvider
{




    public function boot(): void
    {
        Gate::define('admin', function (User $user) {
            return $user->role === 'admin';
        });

        $this->registerApiRoutes();
    }
    
    protected function registerApiRoutes(): void
    {
        Route::prefix('api')
            ->middleware('api')
            ->namespace('App\\Http\\Controllers')
            ->group(base_path('routes/api.php'));
    }
}
