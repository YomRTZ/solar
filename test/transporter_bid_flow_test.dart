import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  testWidgets('transporter can bid on a job and return to dashboard', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.transporterHome);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Available Jobs'), findsOneWidget);
    await tester.tap(find.text('Bid Now').first);
    await tester.pumpAndSettle();

    expect(find.text('Place Bid'), findsOneWidget);
    expect(find.text('Rs. 30,000'), findsOneWidget);
    final submitBid = find.text('Submit Bid | Rs. 30,000');
    await tester.ensureVisible(submitBid);
    await tester.tap(submitBid);
    await tester.pumpAndSettle();

    expect(find.text('Bid Sent Successfully!'), findsOneWidget);
    await tester.tap(find.text('Go to dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Available Jobs'), findsOneWidget);
    await tester.tap(find.text('My Bids'));
    await tester.pumpAndSettle();

    expect(find.text('Bid Requested'), findsOneWidget);
    expect(find.text('Bid Rejected'), findsOneWidget);
    expect(find.text('Bid Approved'), findsOneWidget);

    final bidRouteStyle = tester
        .widget<Text>(find.text('Delhi → Mumbai').first)
        .style!;
    expect(bidRouteStyle.fontFamily, 'Poppins');
    expect(bidRouteStyle.fontSize, 12);
    expect(bidRouteStyle.fontWeight, FontWeight.w700);
    expect(bidRouteStyle.height, 1);
    expect(bidRouteStyle.color, const Color(0xFF000000));

    final bidTimeStyle = tester
        .widget<Text>(find.text('2 min ago').first)
        .style!;
    expect(bidTimeStyle.fontFamily, 'Poppins');
    expect(bidTimeStyle.fontSize, 10);
    expect(bidTimeStyle.fontWeight, FontWeight.w600);
    expect(bidTimeStyle.color, const Color(0xFF808080));

    final bidDetailLabelStyle = tester
        .widget<Text>(find.text('Vehicle').first)
        .style!;
    expect(bidDetailLabelStyle.fontFamily, 'Poppins');
    expect(bidDetailLabelStyle.fontSize, 10);
    expect(bidDetailLabelStyle.fontWeight, FontWeight.w700);
    expect(bidDetailLabelStyle.color, const Color(0xFF808080));

    final bidDetailValueStyle = tester
        .widget<Text>(find.text('Container').first)
        .style!;
    expect(bidDetailValueStyle.fontFamily, 'Poppins');
    expect(bidDetailValueStyle.fontSize, 10);
    expect(bidDetailValueStyle.fontWeight, FontWeight.w700);
    expect(bidDetailValueStyle.color, const Color(0xFF000000));

    const statusColors = {
      'Bid Requested': Color(0xFFFFCC00),
      'Bid Rejected': Color(0xFFFF0000),
      'Bid Approved': Color(0xFF34C759),
    };
    for (final entry in statusColors.entries) {
      final status = tester.widget<Text>(find.text(entry.key));
      expect(status.textAlign, TextAlign.right);
      expect(status.style!.fontFamily, 'Poppins_700');
      expect(status.style!.fontSize, 12);
      expect(status.style!.fontWeight, FontWeight.w700);
      expect(status.style!.height, 1);
      expect(status.style!.letterSpacing, 0);
      expect(status.style!.color, entry.value);
    }
  });

  testWidgets('transporter can verify an upcoming trip by OTP', (tester) async {
    final router = createAppRouter(initialLocation: AppRoutes.transporterHome);
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => AuthCubit()..updateMobileNumber('9899333112'),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My trips'));
    await tester.pumpAndSettle();
    expect(find.text('Upcoming'), findsOneWidget);

    final tripRouteStyle = tester
        .widget<Text>(find.text('Delhi → Mumbai').first)
        .style!;
    expect(tripRouteStyle.fontFamily, 'Poppins');
    expect(tripRouteStyle.fontSize, 12);
    expect(tripRouteStyle.fontWeight, FontWeight.w700);
    expect(tripRouteStyle.height, 1);
    expect(tripRouteStyle.color, const Color(0xFF000000));

    final tripDateStyle = tester.widget<Text>(find.text('Today')).style!;
    expect(tripDateStyle.fontFamily, 'Poppins');
    expect(tripDateStyle.fontSize, 10);
    expect(tripDateStyle.fontWeight, FontWeight.w600);
    expect(tripDateStyle.color, const Color(0xFF808080));

    final tripDetailLabelStyle = tester
        .widget<Text>(find.text('Vehicle').first)
        .style!;
    expect(tripDetailLabelStyle.fontFamily, 'Poppins');
    expect(tripDetailLabelStyle.fontSize, 10);
    expect(tripDetailLabelStyle.fontWeight, FontWeight.w700);
    expect(tripDetailLabelStyle.color, const Color(0xFF808080));

    final tripDetailValueStyle = tester
        .widget<Text>(find.text('Container').first)
        .style!;
    expect(tripDetailValueStyle.fontFamily, 'Poppins');
    expect(tripDetailValueStyle.fontSize, 10);
    expect(tripDetailValueStyle.fontWeight, FontWeight.w700);
    expect(tripDetailValueStyle.color, const Color(0xFF000000));

    for (final iconKey in [
      const ValueKey('transporter-trip-pickup-icon'),
      const ValueKey('transporter-trip-dropoff-icon'),
    ]) {
      final tripIcon = tester.widget<Image>(find.byKey(iconKey));
      expect(tripIcon.width, 18);
      expect(tripIcon.height, 18);
    }
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

    await tester.tap(find.text('Verify Delivery'));
    await tester.pumpAndSettle();
    expect(
      find.text('An Otp has been sent to +91 9899 333 112'),
      findsOneWidget,
    );

    for (var index = 0; index < 6; index++) {
      await tester.enterText(find.byType(TextField).at(index), '${index + 1}');
    }
    await tester.tap(find.text('Verify Otp'));
    await tester.pumpAndSettle();

    expect(find.text('Trip Verified'), findsOneWidget);
    expect(find.text('Start Navigation'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
    expect(find.byType(SvgPicture), findsNWidgets(2));
    await tester.tap(find.text('Start Navigation'));
    await tester.pumpAndSettle();
    expect(find.text('Received Qty'), findsOneWidget);
    expect(find.text('Condition'), findsOneWidget);
    expect(find.text('Upload Delivery Proof'), findsOneWidget);
    expect(find.text('Confirm Delivery'), findsOneWidget);
    final confirmDelivery = find.text('Confirm Delivery');
    await tester.ensureVisible(confirmDelivery);
    await tester.tap(confirmDelivery);
    await tester.pumpAndSettle();
    expect(find.text('Upload Delivery Proof is required'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Start Trip'), findsOneWidget);
    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Verify Delivery'), findsNothing);
  });

  testWidgets('delivery confirmation returns to transporter dashboard', (
    tester,
  ) async {
    final router = createAppRouter(
      initialLocation: AppRoutes.transporterDeliveryStatus,
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Delivered Successfully!'), findsOneWidget);
    expect(
      find.text('Delivery Status has been updated successfully!'),
      findsOneWidget,
    );

    await tester.tap(find.text('Go to dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Available Jobs'), findsOneWidget);
  });
}
