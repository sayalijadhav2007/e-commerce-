# Gemini Code Assistant Context

This file provides context for the Gemini Code Assistant to understand the project and provide more relevant and accurate assistance.

## Project Overview

This is a Flutter-based dual-role delivery application that serves as a prototype for an intelligent delivery management system. The app has two main roles: a delivery driver and a manager. The core of the application is a priority-based order management system that uses a weighted scoring algorithm to prioritize delivery orders.

The application is built with a clean, feature-first architecture and uses the following technologies:

-   **Framework:** Flutter
-   **State Management:** Riverpod
-   **Navigation:** GoRouter
-   **Map Integration:** `flutter_map` with OpenStreetMap as the tile provider.
-   **Routing:** OSRM (Open Source Routing Machine) for real-time, road-based routing.

The project is designed to be a production-quality prototype, suitable for a hackathon, startup MVP, or product engineering showcase.

## Building and Running

### Get Dependencies
```sh
flutter pub get
```

### Run the App
```sh
# To run on Chrome
flutter run -d chrome

# To run on Linux
flutter run -d linux
```

## Development Conventions

### Architecture
The project follows a feature-first architecture, with a clear separation of the UI, application (business logic), and data layers.

-   `lib/features`: Contains the different screens of the app, such as the priority dashboard, order details, and map screen.
-   `lib/domain`: Contains the business models and repository interfaces.
-   `lib/data`: Contains the implementation of the repositories. A `MockOrderRepository` is used to generate random order data for simulation.
-   `lib/application`: Contains the business logic, including services like `PriorityService`, `MapService`, and `RouteService`.
-   `lib/core`: Contains the router, theme, and shared widgets.

### State Management
[Flutter Riverpod](https://riverpod.dev/) is used for dependency injection and state management. Providers are used to provide access to services and controllers, and to manage the state of the application.

### Navigation
[GoRouter](https://pub.dev/packages/go_router) is used for declarative, URL-based navigation.

### Map Integration
The application uses the [`flutter_map`](https://pub.dev/packages/flutter_map) package to display a map from OpenStreetMap. The map is used to visualize the delivery routes and the locations of the restaurants and customers.

### Routing
The application uses the [OSRM (Open Source Routing Machine)](http://project-osrm.org/) API to provide real-time, road-based routing. The `RouteService` is responsible for fetching the route from the OSRM API and decoding the polyline response. If the OSRM API is unavailable, the application falls back to a straight-line route.
