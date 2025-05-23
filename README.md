# ParkWise - Smart Parking Solution 🅿️

ParkWise is a comprehensive parking application designed to streamline the process of finding and managing parking spaces. The project consists of a **Flutter-based mobile application** for users and a **Laravel-based backend system** for managing operations.

---

## ✨ Features

*(Add a brief list of your application's key features here. For example:)*
* User registration and login
* Real-time parking availability
* Booking and reservation of parking spots
* Payment integration
* Parking history
* Admin panel for managing parking lots and users

---

## 📂 Folder Structure

The repository is organized as follows:

.
├── parking_app/        # Frontend: Flutter Mobile Application
└── parking-app/        # Backend: Laravel API with SQLite


---

## 📱 Frontend (`parking_app`)

The mobile application is built using **Flutter**, providing a cross-platform experience for both Android and iOS users.

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
* [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
* An IDE like Android Studio (with Flutter plugin) or VS Code (with Flutter extension)

### Getting Started

1.  **Navigate to the frontend directory:**
    ```bash
    cd parking_app
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Configure API endpoint:**
    * Update the API base URL in your Flutter app's configuration file (e.g., `lib/config/api_config.dart`) to point to your running backend server (usually `http://localhost:8000/api` or your production URL).
4.  **Run the app:**
    ```bash
    flutter run
    ```
    (Ensure you have an emulator running or a device connected)

---

## ⚙️ Backend (`parking-app-backend`)

The backend is a RESTful API built with **Laravel** (PHP framework) and uses **SQLite** as its database.

### Prerequisites

* [PHP](https://www.php.net/downloads.php) (version compatible with your Laravel version, e.g., >= 8.1)
* [Composer](https://getcomposer.org/download/) (PHP package manager)
* [SQLite](https://www.sqlite.org/index.html)

### Getting Started

1.  **Navigate to the backend directory:**
    ```bash
    cd parking-app
    ```
2.  **Install PHP dependencies:**
    ```bash
    composer install
    ```
3.  **Copy the environment file:**
    ```bash
    cp .env.example .env
    ```
4.  **Generate an application key:**
    ```bash
    php artisan key:generate
    ```
5.  **Configure your `.env` file:**
    * Ensure `DB_CONNECTION` is set to `sqlite`.
    * By default, Laravel will look for `database/database.sqlite`. If it doesn't exist, you can create it:
        ```bash
        touch database/database.sqlite
        ```
6.  **Run database migrations (and seeders if you have them):**
    ```bash
    php artisan migrate --seed
    ```
7.  **Start the development server (usually on `http://localhost:8000`):**
    ```bash
    php artisan serve
    ```

---

## 🚀 Usage

1.  Ensure the **backend server** is running.
2.  Run the **Flutter mobile application** on an emulator or physical device.
3.  The mobile app should now be able to communicate with the backend API.

---

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Add some feature'`).
5.  Push to the branch (`git push origin feature/your-feature-name`).
6.  Open a Pull Request.

Please make sure to update tests as appropriate.

---

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.


---

Happy Parking! 🚗💨
