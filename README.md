# ZETRA EV Charging App

A premium, state-of-the-art Flutter mobile application for EV (Electric Vehicle) charging management, built using Clean Architecture principles, robust state management, and modern UI/UX design.

---

## 🚀 Key Features

*   **🔐 Authentication**: Secure user login, registration, and session management.
*   **💳 Wallet Management**: Digital wallet to manage payment methods, view balances, and top up.
*   **⚡ Smart Charging**: Real-time EV charging session tracking, charger status, and remote start/stop operations.
*   **📍 Station Finder**: Dynamic Google Maps integration to locate, filter, and view nearby charging stations.
*   **📜 Transaction & Charging History**: Detailed local storage records of all past charges and payment history.
*   **🔔 Real-time Notifications**: Custom notifications for charging status updates and alerts.
*   **👤 Profile Management**: User settings, vehicle profile details, and account preferences.

---

## 🛠️ Architecture & Tech Stack

The project strictly follows **Clean Architecture** patterns to ensure testability, maintainability, and scalability.

```
lib/
├── app/                 # Application-wide configurations (routing, themes, constants)
├── core/                # Core shared code (services, storage, network clients, extensions)
└── features/            # Feature-specific modules (auth, wallet, charging, history, profile, station, etc.)
    └── [feature_name]/
        ├── data/        # Repositories implementations, models, and data sources
        ├── domain/      # Entities, repository interfaces, and use cases
        └── presentation/# UI components (screens, widgets) and State Management (Bloc)
```

### Core Technologies Used
*   **Framework**: [Flutter SDK](https://flutter.dev) (Dart SDK `^3.4.0`)
*   **State Management**: `flutter_bloc` & `provider`
*   **Navigation & Routing**: `go_router`
*   **Dependency Injection**: `get_it` & `injectable`
*   **Local Database**: `drift` (SQLite) & `flutter_secure_storage`
*   **Networking**: `dio`
*   **Maps Integration**: `google_maps_flutter`
*   **QR Scanner**: `mobile_scanner`
*   **Monitoring**: `sentry_flutter`
*   **Code Generation**: `build_runner`, `freezed`, `json_serializable`, `drift_dev`, `injectable_generator`
*   **Testing**: `mocktail` & `bloc_test`

---

## ⚙️ Getting Started & Setup

### Prerequisites
Make sure you have the Flutter SDK installed and configured on your machine.
*   Flutter version: `^3.4.0` (or compatible)
*   Check setup: `flutter doctor`

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/siva-go/zetra.git
   cd zetra
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code files:**
   Since this project uses code generation for dependency injection, database tables, and immutable classes, run the build runner command:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application:**
   Ensure you have an emulator/simulator running or a physical device connected:
   ```bash
   flutter run
   ```

5. **Run automated tests:**
   To execute the unit and widget tests:
   ```bash
   flutter test
   ```

