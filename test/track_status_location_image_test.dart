import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
