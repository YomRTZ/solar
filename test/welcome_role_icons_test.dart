import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _roleIconAssets = [
  'assets/icons/ic_vendor.png',
  'assets/icons/ic_supplier.png',
  'assets/icons/ic_transporter.png',
];

void main() {
  testWidgets('supplier, vendor, and transporter images render', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/ic_vendor.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 20),
                Image.asset(
                  'assets/icons/ic_supplier.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 20),
                Image.asset(
                  'assets/icons/ic_transporter.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final context = tester.element(find.byType(Scaffold));
    await tester.runAsync(() async {
      for (final asset in _roleIconAssets) {
        await precacheImage(AssetImage(asset), context);
      }
    });
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Row),
      matchesGoldenFile('goldens/welcome_role_icons.png'),
    );
  });
}
