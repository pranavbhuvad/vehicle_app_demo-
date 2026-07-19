# 24 CARRENTAL - Mobile Client

A modern, customer-facing vehicle booking mobile application built using **Flutter** and **Riverpod**. This application features a premium UI, robust local form validation, a dedicated profile management portal, and an intelligent network interceptor setup for smooth dummy/mock testing.

---

## 📱 Features Demonstrated

*   **Authentication & Validation Layer**: Complete customer registration and login flows with strict structural validators for email patterns, passwords, and 10-digit mobile numbers.
*   **Dynamic Customer Dashboard**: A premium, high-fidelity home workspace displaying personalized greetings, global vehicle provider banners, and centralized interactive entry points.
*   **End-to-End Rental Booking Pipeline**: 
    *   State, District, and Hub-based localization filters.
    *   Dynamic calendar date range picking and lease duration calculations.
    *   Responsive inventory listing maps parsing partner-owned vehicle details (Verna, XUV700, Altroz).
    *   Interactive booking checkouts returning clear layout success signals.
*   **"My Portal" Profile System**: A fully decoupled profile center rendering active user metadata, document tracking menus, and instant cross-controller session sign-outs.

---

## 🛠️ Tech Stack & Architectural Rules

*   **Architecture**: **Feature-First** structure separating data, presentation, and domain components cleanly to achieve maintainable codebase scaling.
*   **State Management**: **Riverpod** (`StateNotifierProvider` and standard `Provider`) to handle declarative state changes efficiently without UI tightly coupling.
*   **Networking Layer**: **Dio** client bundled with specialized debugging interceptors:
    *   *Console Interceptor*: Cleanly streams outgoing API request bodies, headers, and endpoints into the terminal.
    *   *Mock Interceptor*: Catches routes locally to inject stable dummy JSON schemas instantly, avoiding placeholder DNS lookup failures (`Failed host lookup`).
*   **Responsive Layouts**: Scaled systematically through `flutter_screenutil` relative to a baseline **375x812** design viewport to ensure layout fluidity across all Android & iOS devices.
*   **JSON Serialization**: Maintained via clean, manual contract parsing to prevent dependencies on bulky code generators like `freezed` or `json_serializable`.

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── constants/       # Global keys and local storage definitions
│   ├── network/         # ApiClient, custom Dio interceptors, and MockData store
│   ├── theme/           # AppColors and AppTheme system matching the design identity
│   └── utils/           # Centralized input validation utilities (Validators)
└── features/
    ├── auth/            # Presentation layers, Controllers, and Providers for Signup/Login
    ├── booking/         # Rental forms, Inventory views, and booking management
    └── profile/         # "My Portal" controllers and profile account screens