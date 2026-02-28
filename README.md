# Priority Delivery - A Real-Map-Aware Delivery Intelligence Platform

This Flutter-based application is a complete, multi-screen prototype of an intelligent delivery management system. It has been **upgraded from a proprietary map system to a fully open-source solution using OpenStreetMap**. The application now uses real map data from OpenStreetMap to influence delivery priority decisions, making it a more realistic and powerful prototype for a hackathon, startup MVP, or product engineering showcase.

This project is architected to be a production-quality prototype, built with a clean, feature-first architecture, using Riverpod for state management, and GoRouter for navigation. The map integration is done in a way that is both demo-friendly and easily extensible.

## Why OpenStreetMap?

The migration from Google Maps to OpenStreetMap was a strategic decision based on the following factors:

- **Cost:** OpenStreetMap is a fully free and open-source solution, which means there are no API key or billing requirements. This makes it an ideal choice for startups, hackathons, and open-source projects.
- **Customization:** OpenStreetMap provides a high degree of customization, allowing for a unique and branded map experience.
- **Community:** OpenStreetMap is a community-driven project with a large and active community, which means it is constantly being updated and improved.

While Google Maps offers a more polished and feature-rich experience, OpenStreetMap provides a solid and cost-effective foundation for a wide range of applications.

## The App Flow: A Complete User Experience

The application is designed to provide a comprehensive user experience, with multiple screens that serve different purposes, all connected to the core priority engine.

### 1. Home Screen
The landing page of the application. It provides a brief overview of the app's purpose and offers clear navigation to the main features.

### 2. Priority Dashboard
This is the core of the application. It displays a live, animated list of active orders, sorted by their calculated **Priority Score**. The highest-priority order is highlighted, making it clear which delivery should be handled next. The dashboard can be refreshed to simulate a new batch of orders. It also features a control to simulate different traffic conditions (Low, Medium, High), which directly impacts the priority scores.

### 3. All Orders Screen
A simple, clean list of all active orders. This screen provides a quick overview of every order in the system, and each item can be tapped to view more details.

### 4. Order Details Screen
This screen provides a deep dive into a single order. It shows not only the order details but also a complete breakdown of its priority score, explaining exactly **why** the order has its current priority.

### 5. Map Screen (OpenStreetMap Integration)
This screen provides a visual representation of the delivery route on a **real map from OpenStreetMap**. It shows:
- A marker for the pickup location.
- A marker for the drop-off location.
- A polyline route drawn between the two points, now based on **real road geometry** fetched from the OSRM API.
- A card with key information like distance, ETA, and current traffic level.
- A simulation of the driver's movement along the route.

### 6. Reviews & Ratings Screen
This screen explains and demonstrates the impact of customer ratings on the priority score. It shows a list of customers and their ratings, making it clear how loyalty is rewarded with higher priority.

### 7. Settings & Simulation Screen
This screen puts the user in control of the priority algorithm. It allows for real-time adjustment of the weights for each priority parameter (food urgency, distance, customer rating, and traffic), demonstrating the flexibility and extensibility of the system.

## Demo Authentication

**Note:** Authentication is mocked for demonstration purposes only.

To log in, use the following static credentials:
- **Username:** `sayali`
- **Password:** `sayali2007`

## How It Works: The Map-Aware Priority Logic

The core of this application is the priority scoring algorithm, located in `lib/application/services/priority_service.dart`. Each order is assigned a score based on a combination of weighted parameters, now including real map data and road-based routing.

The formula is:

```
Priority Score = (FoodUrgencyWeight * UrgencyMultiplier) + (DistanceFactor * DistanceMultiplier) + (CustomerRatingWeight * RatingMultiplier) - (TrafficFactor * TrafficMultiplier)
```

The multipliers are controlled by the user in the **Settings** screen.

### Parameters Used

1.  **Food Urgency (Weight: 5-30)**
    *   **High (30 pts):** For items that need to be delivered quickly.
    *   **Medium (15 pts):** For standard orders.
    *   **Low (5 pts):** For non-perishable items.

2.  **Distance Factor (Weight: 0-20)**
    *   This factor is calculated based on the **road distance** obtained from the OSRM routing API.
    *   Closer orders receive a higher score to maximize delivery efficiency.
    *   `< 2km`: 20 pts
    *   `< 5km`: 10 pts
    *   `< 10km`: 5 pts
    *   `> 10km`: 0 pts

3.  **Customer Rating (Weight: 0-10)**
    *   This rewards loyal and high-rated customers with faster service.
    *   `>= 4.5 stars`: 10 pts
    *   `>= 3.5 stars`: 5 pts
    *   `< 3.5 stars`: 0 pts

4.  **Simulated Traffic (Factor: 1.0-2.0)**
    *   This factor simulates the impact of traffic on delivery time and priority.
    *   **Low:** 1.0x ETA multiplier
    *   **Medium:** 1.5x ETA multiplier
    *   **High:** 2.0x ETA multiplier

## Routing vs. Distance Calculation

It is important to understand the difference between routing and distance calculation:

- **Distance Calculation:** This is the process of finding the straight-line distance between two points (also known as the Haversine distance). This is a quick and simple calculation, but it does not take into account the actual roads that a vehicle would travel on.
- **Routing:** This is the process of finding the optimal path between two points, based on the road network. This is a more complex calculation, but it provides a much more accurate estimate of the travel distance and time.

This application uses the **OSRM (Open Source Routing Machine)** API to provide real-time routing. If the OSRM API is unavailable, the application will fall back to using the Haversine distance for a less accurate, but still functional, estimate.

## Architecture & Tech Stack

*   **Architecture:** Feature-First Architecture, with a clear separation of UI, application (business logic), and data layers.
*   **State Management:** **Flutter Riverpod** is used for dependency injection and state management.
*   **Map Integration:** **flutter_map** for native map rendering on mobile and web, using OpenStreetMap as the tile provider.
*   **Routing:** **OSRM (Open Source Routing Machine)** for real-time, road-based routing.
*   **Data Access:** The **Repository Pattern** is used to decouple the application from the data source. A `MockOrderRepository` currently generates random order data for simulation.
*   **Navigation:** **GoRouter** for declarative, URL-based navigation.
*   **UI:** **Material 3** with a modern, clean design.

## How to Run

1.  **Get Dependencies:**
    ```sh
    flutter pub get
    ```

2.  **Run the App:**
    ```sh
    flutter run -d chrome
    # or
    flutter run -d linux
    ```

## Future Scope

This project provides a strong foundation that can be extended in several ways:

*   **Upgrade to a Commercial Routing API:** While OSRM is a great free solution, a commercial provider like the **Google Maps Directions API** or **Mapbox Directions API** would provide a more polished and feature-rich experience, including:
    *   **Higher Accuracy:** More accurate and detailed routes, with better handling of complex road networks.
    *   **Live Traffic:** Real-time traffic data for more accurate ETAs.
    *   **Advanced Features:** Turn-by-turn navigation, traffic-aware routing, and more.
*   **Backend Integration:** Replace the `MockOrderRepository` with a real implementation that fetches data from a backend API (e.g., a REST or GraphQL API).
*   **Live Location Tracking:** Integrate a live GPS feed for the driver's location and update the priority scores and ETA in real-time.
*   **More Priority Parameters:** Extend the formula to include other factors like order age, order value, and guaranteed delivery times.
*   **User Roles & Authentication:** Re-implement a proper authentication system for drivers and managers.
