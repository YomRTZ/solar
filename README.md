# SolarTradeXHub

SolarTradeXHub is a Flutter marketplace app for solar suppliers and vendors. It
contains onboarding and verification flows, product management, catalog
browsing, RFQs, checkout, orders, profiles, and wallet screens.

## Requirements

- Flutter SDK with Dart SDK `^3.11.4` or compatible.
- Android Studio or an Android SDK for Android builds.
- macOS and Xcode for iOS builds.

## Setup and Commands

Run these commands from the repository root:

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

To build a smaller set of Android release APKs:

```sh
flutter build apk --release --split-per-abi --tree-shake-icons
```

`flutter run` requires a connected emulator or device. iOS builds require macOS
with Xcode configured. If generated build artifacts become stale, run
`flutter clean`, then `flutter pub get` before rebuilding.

## Project Structure

```text
lib/
  app/          App routing and route data
  core/         Shared widgets, validation, theme, and utilities
  features/     Feature-oriented application code
  main.dart     App startup and dependency providers
assets/
  fonts/        Bundled typefaces
  icons/        UI icons
  images/       Brand and screen imagery
  solarimages/  Product and marketplace imagery
test/           Widget, state, repository, and workflow tests
```

Feature code is grouped under `lib/features/<feature>/`; `data/`, `domain/`,
and `presentation/` folders are used where appropriate. Shared application
components live under `lib/core/`.

## Architecture and State

- `lib/app/routing/app_router.dart` defines GoRouter routes and shared page
  transitions. Route paths are constants in `app_routes.dart`; typed route
  payloads are in `route_data.dart`.
- Routes that require payloads validate their `extra` value and throw a
  `FlutterError` when the required type is missing. Use `context.push` when
  retaining the current page and `context.go` when replacing the location.
- BLoC/Cubit state is organized by feature. Marketplace navigation belongs to
  dashboard; catalog state belongs to catalog; checkout, RFQ filtering, and cart
  state belong to shopping.
- Product UI depends on the `ProductRepository` contract. The app currently
  provides `InMemoryProductRepository`, which supplies sample data and does not
  persist changes across app restarts. Replace this implementation to connect a
  backend or local database.
- Other workflow data sources also contain demo/in-memory data; the app is not
  connected to a production service.

Dialogs, sheets, and local back actions use Flutter's `Navigator` APIs.

## Shared UI and Forms

Import `package:flutter_app/core/widgets/widgets.dart` for shared components,
including `AppHeader`, `SecondAppHeader`, `AppContinueButton`, `AppTextField`,
`AppDropdownField`, `AppFileUploadField`, `AppFormSection`, and the reusable
product and catalog cards. Shared form validation helpers are exported from the
same barrel.

Wrap a form in `AppFormSection` to use the app's shared validation behavior.
`AppContinueButton` can validate the containing form before invoking its
callback. Custom inputs can use `AppFormValidation` and `AppFormErrorText`.

## Assets and Fonts

The asset directories are registered in `pubspec.yaml`. Use descriptive
lowercase names; icon files use the `ic_` prefix. Prefer SVG for scalable vector
icons, PNG when transparency is needed, and JPEG for photographs. Size and
compress images for their rendered dimensions, and check visual quality on a
device after optimization.

Bundled font families registered in `pubspec.yaml` are General Sans, Inter,
Nunito, Nunito Sans, Plus Jakarta Sans, and Roboto. Add font files to the
matching `assets/fonts/<family>/` directory and register their paths under
`flutter.fonts` in `pubspec.yaml`.

The iOS launch image catalog is under
`ios/Runner/Assets.xcassets/LaunchImage.imageset/`.

## Tests

Run the complete test suite with `flutter test`. The current tests cover:

- App startup on the splash screen.
- Product repository CRUD and query behavior.
- Marketplace navigation, shopping-cart, and checkout state.
- RFQ quote and order-status workflow.
