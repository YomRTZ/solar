# SolarTradeXHub

Flutter application for the SolarTradeXHub marketplace.

## Architecture

- `lib/app/routing/app_router.dart` is the centralized GoRouter configuration and
  applies the shared fade-and-slide transition to app routes.
- `lib/app/routing/app_routes.dart` contains route paths.
- `lib/app/routing/route_data.dart` defines typed data passed between routes.
- `lib/features/` follows a feature-first structure. Each feature keeps its
  `data/`, `domain/`, and `presentation/` code together; presentation pages and
  feature-specific widgets live under `presentation/`.
- `lib/core/` contains reusable app-wide widgets, theme values, and constants.
  App setup and navigation live under `lib/app/`.
- Feature code uses package imports (for example,
  `package:flutter_app/features/vendor/presentation/pages/vendor_home_screen.dart`).
  Feature-specific widgets are kept with their feature; only app-wide widgets
  are exported from `core/widgets/widgets.dart`.
- Home and Vendor keep their bottom-navigation tabs as local stateful shells so
  their existing tab state and behavior are preserved.

Navigate between app screens with GoRouter, for example:

```dart
context.push(AppRoutes.orderDetails, extra: order);
context.go(AppRoutes.home);
```

Routes that require data validate the route extra and raise a `FlutterError` if
it is absent or has the wrong type. Dialogs, bottom sheets, and back actions
continue to use `Navigator.pop`.
