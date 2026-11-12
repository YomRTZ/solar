import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_rfq_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';

void main() {
  testWidgets('RFQ request sheet shows breakup and can reject a bid', (
    tester,
  ) async {
    final router = createAppRouter(
      initialLocation: AppRoutes.catalogRfqRequests,
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('10 KW Solar Panel').first);
    await tester.pumpAndSettle();

    expect(find.text('Price Breakup'), findsOneWidget);
    expect(find.text('Base Fare'), findsOneWidget);
    expect(find.text('Loading Charges'), findsOneWidget);
    expect(find.text('Unloading Charges'), findsOneWidget);
    expect(find.text('Toll / Other Charges'), findsOneWidget);
    expect(find.text('Reject Bid'), findsOneWidget);
    expect(find.text('Accept Bid'), findsOneWidget);

    await tester.tap(find.text('Reject Bid'));
    await tester.pumpAndSettle();

    expect(
      CatalogRfqData.getById('rfq_001')?.status,
      CatalogRfqStatus.rejected,
    );
    CatalogRfqData.updateStatus('rfq_001', CatalogRfqStatus.received);
  });

  testWidgets('accepting a received bid proceeds to checkout', (tester) async {
    final router = createAppRouter(
      initialLocation: AppRoutes.catalogRfqRequests,
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('10 KW Solar Panel').first);
    await tester.pumpAndSettle();
    expect(
      CatalogRfqData.getById('rfq_001')?.status,
      CatalogRfqStatus.received,
    );
    final acceptButton = find.ancestor(
      of: find.text('Accept Bid'),
      matching: find.byType(ElevatedButton),
    );
    expect(tester.widget<ElevatedButton>(acceptButton).onPressed, isNotNull);
    await tester.ensureVisible(find.text('Accept Bid'));
    await tester.tap(find.text('Accept Bid'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout (Ui will be Different)'), findsOneWidget);
  });
}
