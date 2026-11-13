import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';
import 'package:flutter_app/features/orders/presentation/pages/track_status_screen.dart';

void main() {
  testWidgets('track status shows the location image in the In Transit row', (
    tester,
  ) async {
    const order = Order(
      id: 'location-image-test',
      productName: '10 KW Solar Panel',
      productImagePath: 'assets/solarimages/solar_panel_product.png',
      price: '45000',
      deliveryLocation: 'Pune, Maharashtra',
      buyer: 'Green Energy Installers',
      orderDate: '10 Sept 2026',
      status: OrderStatus.pending,
      quantity: 2,
      subtotal: 90000,
      gstPercent: 18,
    );
    await tester.pumpWidget(
      const MaterialApp(home: TrackStatusScreen(order: order)),
    );
    await tester.pumpAndSettle();

    expect(find.text('In Transit'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('in-transit-location-map')),
      findsOneWidget,
    );
  });

  testWidgets('supplier track status returns to the supplier dashboard', (
    tester,
  ) async {
    const order = Order(
      id: 'supplier-track-status-test',
      productName: '10 KW Solar Panel',
      productImagePath: 'assets/solarimages/solar_panel_product.png',
      price: '45000',
      deliveryLocation: 'Pune, Maharashtra',
      buyer: 'Green Energy Installers',
      orderDate: '10 Sept 2026',
      status: OrderStatus.pending,
      quantity: 2,
      subtotal: 90000,
      gstPercent: 18,
    );
    final router = createAppRouter(initialLocation: AppRoutes.home);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    router.push(AppRoutes.trackStatus, extra: order);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to dashboard'));
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.path, AppRoutes.home);
  });

  testWidgets('vendor track status returns to the vendor dashboard', (
    tester,
  ) async {
    const order = Order(
      id: 'vendor-track-status-test',
      productName: '10 KW Solar Panel',
      productImagePath: 'assets/solarimages/solar_panel_product.png',
      price: '45000',
      deliveryLocation: 'Pune, Maharashtra',
      buyer: 'Green Energy Installers',
      orderDate: '10 Sept 2026',
      status: OrderStatus.pending,
      quantity: 2,
      subtotal: 90000,
      gstPercent: 18,
    );
    final router = createAppRouter(initialLocation: AppRoutes.vendorMain);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    router.push(AppRoutes.vendorTrackStatus, extra: order);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to dashboard'));
    await tester.pumpAndSettle();

    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      AppRoutes.vendorMain,
    );
  });
}
