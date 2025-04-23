<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Route;
use App\Models\User;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Define admin gate
        Gate::define('admin', function (User $user) {
            return $user->role === 'admin';
        });
        
        // Explicitly register API routes
        $this->registerApiRoutes();
    }
    
    /**
     * Register API routes explicitly
     */
    protected function registerApiRoutes(): void
    {
        Route::prefix('api')
            ->middleware('api')
            ->namespace('App\\Http\\Controllers')
            ->group(base_path('routes/api.php'));
    }
}
