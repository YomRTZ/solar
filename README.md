# SolarTradeXHub

Flutter application for the SolarTradeXHub marketplace.

## Architecture

- `lib/app/routing/app_router.dart` is the centralized GoRouter configuration and
  applies the shared fade-and-slide transition to app routes.
- `lib/app/routing/app_routes.dart` contains route paths.
- `lib/app/routing/route_data.dart` defines typed data passed between routes.
- `lib/features/` organizes screens by product feature. Shared UI components and
  theme values live under `lib/core/`; reusable app data and models live under
  `lib/data/` and `lib/models/`.
- Home and Tender keep their bottom-navigation tabs as local stateful shells so
  their existing tab state and behavior are preserved.

Navigate between app screens with GoRouter, for example:

```dart
context.push(AppRoutes.orderDetails, extra: order);
context.go(AppRoutes.home);
```

Routes that require data validate the route extra and raise a `FlutterError` if
it is absent or has the wrong type. Dialogs, bottom sheets, and back actions
continue to use `Navigator.pop`.
