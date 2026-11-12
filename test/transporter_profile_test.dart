import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';

void main() {
  testWidgets('transporter profile route uses the dedicated avatar profile', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.transporterHome);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Transporter Information'), findsOneWidget);
    expect(find.byKey(const ValueKey('transporter-profile-avatar')), findsOneWidget);

    final avatar = tester.widget<Image>(
      find.byKey(const ValueKey('transporter-profile-avatar')),
    );
    expect((avatar.image as AssetImage).assetName, 'assets/solarimages/avater.png');
  });
}
