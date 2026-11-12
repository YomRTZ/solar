import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/app/routing/app_routes.dart';

void main() {
  testWidgets(
    'transporter home header uses the requested logo and icon margins',
    (tester) async {
      final router = createAppRouter(
        initialLocation: AppRoutes.transporterHome,
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      final header = tester.getRect(
        find.byKey(const ValueKey('transporter-dashboard-header')),
      );
      final logo = tester.getRect(
        find.byKey(const ValueKey('transporter-dashboard-logo')),
      );
      final notifications = tester.getRect(
        find.byKey(const ValueKey('transporter-dashboard-notifications')),
      );

      expect(logo.left - header.left, 19);
      expect(logo.top - header.top, 58);
      expect(header.bottom - logo.bottom, 15);
      expect(header.right - notifications.right, 22);
      expect(notifications.top - header.top, 73);
      expect(header.bottom - notifications.bottom, 28);

      final myBidsItem = find.byKey(
        const ValueKey('transporter-nav-item-My Bids'),
      );
      final myTripsItem = find.byKey(
        const ValueKey('transporter-nav-item-My trips'),
      );
      final homeItem = find.byKey(const ValueKey('transporter-nav-item-Home'));
      final profileItem = find.byKey(
        const ValueKey('transporter-nav-item-Profile'),
      );
      final myBidsItemRect = tester.getRect(myBidsItem);
      final myTripsItemRect = tester.getRect(myTripsItem);
      final homeItemRect = tester.getRect(homeItem);
      final profileItemRect = tester.getRect(profileItem);
      expect(myBidsItemRect.height, 75);
      expect(myTripsItemRect.height, 75);
      expect(myBidsItemRect.width, homeItemRect.width);
      expect(myTripsItemRect.width, homeItemRect.width);
      expect(myBidsItemRect.left - homeItemRect.right, 0);
      expect(myTripsItemRect.left - myBidsItemRect.right, 0);
      expect(profileItemRect.left - myTripsItemRect.right, 0);

      final myBidsIcon = tester.widget<Image>(
        find.byKey(const ValueKey('transporter-nav-my-bids-icon')),
      );
      final myTripsIcon = tester.widget<Image>(
        find.byKey(const ValueKey('transporter-nav-my-trips-icon')),
      );
      expect(myBidsIcon.width, 24);
      expect(myBidsIcon.height, 24);
      expect(myTripsIcon.width, 24);
      expect(myTripsIcon.height, 24);

      final myBidsIconRect = tester.getRect(
        find.byKey(const ValueKey('transporter-nav-my-bids-icon')),
      );
      final myBidsLabelRect = tester.getRect(find.text('My Bids'));
      expect(myBidsLabelRect.top - myBidsIconRect.bottom, 4);
      expect(myBidsLabelRect.center.dx, myBidsItemRect.center.dx);
      final myBidsLabelStyle = tester.widget<Text>(find.text('My Bids')).style!;
      expect(myBidsLabelStyle.fontFamily, 'Inter_500');
      expect(myBidsLabelStyle.fontSize, 10);
      expect(myBidsLabelStyle.fontWeight, FontWeight.w500);
      expect(myBidsLabelStyle.height, 1.8);
      expect(myBidsLabelStyle.letterSpacing, -0.17);
      expect(myBidsLabelStyle.color, const Color(0xFF030303));

      final newJobs = find.byKey(const ValueKey('metric-card-New Jobs'));
      final activeTrips = find.byKey(
        const ValueKey('metric-card-Active Trips'),
      );
      final completed = find.byKey(const ValueKey('metric-card-Completed'));
      final newJobsRect = tester.getRect(newJobs);
      final activeTripsRect = tester.getRect(activeTrips);
      final completedRect = tester.getRect(completed);

      expect(newJobsRect.size, const Size(102, 71));
      expect(activeTripsRect.size, const Size(102, 71));
      expect(completedRect.size, const Size(102, 71));
      expect(activeTripsRect.left - newJobsRect.right, 10);
      expect(completedRect.left - activeTripsRect.right, 10);

      final cardDecoration =
          tester.widget<Container>(newJobs).decoration! as BoxDecoration;
      expect(cardDecoration.border!.top.width, 0.5);
      expect(cardDecoration.border!.top.color, const Color(0xFFC6C6C6));
      expect(cardDecoration.borderRadius, BorderRadius.circular(8));

      final numberStyle = tester.widget<Text>(find.text('12')).style!;
      expect(numberStyle.fontFamily, 'Pacifico');
      expect(numberStyle.fontSize, 28);
      expect(numberStyle.fontWeight, FontWeight.w400);
      expect(numberStyle.letterSpacing, -0.56);
      expect(numberStyle.color, const Color(0xFF0E3977));

      final label = tester.widget<Text>(find.text('New Jobs'));
      expect(label.textAlign, TextAlign.center);
      expect(label.style!.fontSize, 10);
      expect(label.style!.fontWeight, FontWeight.w600);
      expect(label.style!.height, 1.3);
      expect(label.style!.color, const Color(0xFF000000));

      final availableJobs = tester.getRect(find.text('Available Jobs'));
      final firstJobCard = find.byKey(const ValueKey('available-job-card-0'));
      final secondJobCard = find.byKey(const ValueKey('available-job-card-1'));
      final firstJobCardRect = tester.getRect(firstJobCard);
      final secondJobCardRect = tester.getRect(secondJobCard);

      expect(availableJobs.top - completedRect.bottom, 26);
      expect(firstJobCardRect.top - availableJobs.bottom, 8);
      expect(firstJobCardRect.left, 15);
      expect(firstJobCardRect.right, header.right - 15);
      expect(firstJobCardRect.height, 134);
      expect(secondJobCardRect.top - firstJobCardRect.bottom, 10);

      final bidButton = find
          .byKey(const ValueKey('available-job-bid-button'))
          .first;
      final bidButtonRect = tester.getRect(bidButton);
      expect(bidButtonRect.width, closeTo(74.64286, 0.001));
      expect(bidButtonRect.height, 22);
      expect(bidButtonRect.top - firstJobCardRect.top, closeTo(86, 0.01));
      expect(
        firstJobCardRect.right - bidButtonRect.right - 1,
        closeTo(11.79, 0.01),
      );

      final bidButtonDecoration =
          tester.widget<Container>(bidButton).decoration! as BoxDecoration;
      expect(bidButtonDecoration.color, const Color(0xFF003A8A));
      expect(bidButtonDecoration.borderRadius, BorderRadius.circular(6));
      expect(bidButtonDecoration.border!.top.width, 1);
      expect(bidButtonDecoration.boxShadow, hasLength(2));

      final availableJobsStyle = tester
          .widget<Text>(find.text('Available Jobs'))
          .style!;
      expect(availableJobsStyle.fontFamily, 'Roboto');
      expect(availableJobsStyle.fontSize, 12.5);
      expect(availableJobsStyle.fontWeight, FontWeight.w700);
      expect(availableJobsStyle.height, 1);
      expect(availableJobsStyle.color, const Color(0xFF23201C));

      final routeStyle = tester
          .widget<Text>(find.text('Delhi → Mumbai').first)
          .style!;
      expect(routeStyle.fontFamily, 'Poppins');
      expect(routeStyle.fontSize, 12);
      expect(routeStyle.fontWeight, FontWeight.w700);
      expect(routeStyle.height, 1);

      final bidButtonTextStyle = tester
          .widget<Text>(find.text('Bid Now').first)
          .style!;
      expect(bidButtonTextStyle.fontFamily, 'Inter_500');
      expect(bidButtonTextStyle.fontSize, 11);
      expect(bidButtonTextStyle.fontWeight, FontWeight.w500);
      expect(bidButtonTextStyle.height, 1.4);
      expect(bidButtonTextStyle.letterSpacing, -0.11);
      expect(bidButtonTextStyle.color, Colors.white);

      final timeStyle = tester
          .widget<Text>(find.text('2 min ago').first)
          .style!;
      expect(timeStyle.fontFamily, 'Poppins');
      expect(timeStyle.fontSize, 10);
      expect(timeStyle.fontWeight, FontWeight.w600);
      expect(timeStyle.color, const Color(0xFF808080));

      final detailLabelStyle = tester
          .widget<Text>(find.text('Vehicle').first)
          .style!;
      expect(detailLabelStyle.fontFamily, 'Poppins');
      expect(detailLabelStyle.fontSize, 10);
      expect(detailLabelStyle.fontWeight, FontWeight.w700);
      expect(detailLabelStyle.color, const Color(0xFF808080));

      final detailValueStyle = tester
          .widget<Text>(find.text('Container').first)
          .style!;
      expect(detailValueStyle.fontFamily, 'Poppins');
      expect(detailValueStyle.fontSize, 10);
      expect(detailValueStyle.fontWeight, FontWeight.w700);
      expect(detailValueStyle.color, const Color(0xFF000000));
    },
  );
}
