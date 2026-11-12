import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/orders/data/datasources/orders_data.dart';

void main() {
  testWidgets('supplier creates a shipment request and accepts a driver bid', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.orders);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('10 KW Solar Panel').first);
    await tester.pumpAndSettle();

    expect(find.text('Create Shipping Request'), findsOneWidget);
    expect(find.text('Self Pickup (My Vehicle)'), findsOneWidget);
    expect(find.text('Track Order'), findsOneWidget);

    await tester.tap(find.text('Create Shipping Request'));
    await tester.pumpAndSettle();
    expect(find.text('Preferred Vehicle Type'), findsOneWidget);
    for (final imagePath in [
      'assets/solarimages/minitruck.png',
      'assets/solarimages/opentrack.png',
      'assets/solarimages/container.png',
    ]) {
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == imagePath,
        ),
        findsOneWidget,
      );
    }

    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.text('Search Driver'));
    await tester.pumpAndSettle();
    expect(find.text('Pickup location is required'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Pune, Maharashtra');
    await tester.tap(find.text('Search Driver'));
    await tester.pumpAndSettle();
    expect(find.text('Bids Received'), findsOneWidget);
    final bidAvatar = tester.widget<CircleAvatar>(
      find.byKey(const ValueKey('received-bid-avatar-1')),
    );
    expect(
      (bidAvatar.backgroundImage! as AssetImage).assetName,
      'assets/solarimages/avater.png',
    );

    await tester.tap(find.text('View Details').first);
    await tester.pumpAndSettle();
    expect(find.text('Price Breakup'), findsOneWidget);
    expect(find.text('Reject Bid'), findsOneWidget);
    expect(find.text('Accept Bid'), findsOneWidget);
    final detailsAvatar = tester.widget<CircleAvatar>(
      find.byKey(const ValueKey('received-bid-details-avatar')),
    );
    expect(
      (detailsAvatar.backgroundImage! as AssetImage).assetName,
      'assets/solarimages/avater.png',
    );

    await tester.tap(find.text('Accept Bid'));
    await tester.pumpAndSettle();

    expect(find.text('Bids Received'), findsOneWidget);
    expect(find.text('Create Shipping Request'), findsNothing);
    expect(OrdersData.hasShippingRequest(OrdersData.orders.first.id), isTrue);
  });
}
