# Repository Guidelines

## Project Structure & Module Organization
- `lib/`: Flutter source code. Feature-first layout.
  - `lib/features/`: UI screens (auth, dashboard, orders, map, settings, etc.).
  - `lib/application/`: Controllers, services, providers (business logic).
  - `lib/domain/`: Core models and interfaces.
  - `lib/data/`: Repository implementations and seed data.
  - `lib/core/`: Router, theme, shared widgets.
- `test/`: Flutter tests.
- Platform folders: `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`.
- Config: `pubspec.yaml`, `analysis_options.yaml`, `README.md`.

## Build, Test, and Development Commands
- `flutter pub get`: Install dependencies.
- `flutter run -d chrome`: Run the app on Chrome.
- `flutter run -d <device>`: Run on a connected device or emulator.
- `flutter test`: Run all tests in `test/`.
- `flutter analyze`: Static analysis with Dart/Flutter lints.

## Coding Style & Naming Conventions
- Dart/Flutter style via `flutter_lints` (see `analysis_options.yaml`).
- Indentation: 2 spaces.
- Files and folders: `snake_case` (e.g., `driver_assignment_screen.dart`).
- Classes/types: `PascalCase` (e.g., `OrderController`).
- Methods/fields: `camelCase` (e.g., `assignDriver`).
- Keep widgets small and composable; prefer `ConsumerWidget`/`ConsumerStatefulWidget` for Riverpod usage.

## Testing Guidelines
- Framework: `flutter_test`.
- Place tests in `test/` and mirror the `lib/` structure when possible.
- Naming: `*_test.dart` (e.g., `order_controller_test.dart`).
- Run `flutter test` before major changes.

## Commit & Pull Request Guidelines
- No strict commit format detected. Use clear, imperative messages (e.g., “Add SLA monitoring screen”).
- PRs should include:
  - Summary of changes
  - Screenshots or short clips for UI updates
  - Any new dependencies or migrations

## Configuration & Persistence Notes
- Persistence uses SQLite on mobile/desktop via `sqflite` + `sqflite_common_ffi`.
- Web falls back to `shared_preferences`.
- Map routing uses OSRM with cached routes; ensure network access for live routing.
