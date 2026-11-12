import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';

class TransporterDashboardScreen extends StatelessWidget {
  const TransporterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _DashboardHeader(topPadding: topPadding),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MetricCard(value: '12', label: 'New Jobs'),
                        SizedBox(width: 10),
                        _MetricCard(value: '02', label: 'Active Trips'),
                        SizedBox(width: 10),
                        _MetricCard(value: '20', label: 'Completed'),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 26, 0, 8),
                      child: Text(
                        'Available Jobs',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: 0,
                          color: Color(0xFF23201C),
                        ),
                      ),
                    ),
                    for (
                      var index = 0;
                      index < TransporterJob.sampleJobs.length;
                      index++
                    )
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AvailableJobCard(
                          key: ValueKey('available-job-card-$index'),
                          job: TransporterJob.sampleJobs[index],
                          onBidNow: () => context.push(
                            AppRoutes.transporterPlaceBid,
                            extra: TransporterJob.sampleJobs[index],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _TransporterNavigationBar(
          onMyBids: () => context.push(AppRoutes.transporterMyBids),
          onMyTrips: () => context.push(AppRoutes.transporterMyTrips),
          onProfile: () => context.push(AppRoutes.transporterProfile),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final double topPadding;

  const _DashboardHeader({required this.topPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('transporter-dashboard-header'),
      height: topPadding + 125,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: topPadding + 58,
            left: 19,
            child: Image.asset(
              'assets/images/solartradeshub_logo.png',
              key: const ValueKey('transporter-dashboard-logo'),
              width: 100,
              height: 52,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.wb_sunny_rounded,
                color: Colors.amber,
                size: 32,
              ),
            ),
          ),
          Positioned(
            top: topPadding + 73,
            right: 22,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications,
                  key: ValueKey('transporter-dashboard-notifications'),
                  color: Color(0xFFFFD21C),
                  size: 24,
                ),
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    width: 11,
                    height: 11,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF365D),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '1',
                      style: TextStyle(fontSize: 7, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;

  const _MetricCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('metric-card-$label'),
      width: 102,
      height: 71,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC6C6C6), width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 28,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: -0.56,
              color: Color(0xFF0E3977),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.3,
              letterSpacing: 0,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableJobCard extends StatelessWidget {
  final TransporterJob job;
  final VoidCallback onBidNow;

  const _AvailableJobCard({
    super.key,
    required this.job,
    required this.onBidNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 134,
      padding: const EdgeInsets.fromLTRB(9.82, 11, 11, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD8D8D8)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.route,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              Text(
                '2 min ago',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 0,
                  color: Color(0xFF808080),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _JobDetail(label: 'Vehicle', value: job.vehicle),
              const SizedBox(width: 18),
              _JobDetail(label: 'Weight', value: job.weight),
              const SizedBox(width: 18),
              _JobDetail(label: 'Date', value: job.date),
            ],
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          SizedBox(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rs. ${job.price}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF202020),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0.79),
                    child: _BidNowButton(onPressed: onBidNow),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BidNowButton extends StatelessWidget {
  const _BidNowButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);
    return Container(
      key: const ValueKey('available-job-bid-button'),
      width: 74.64286,
      height: 22,
      decoration: BoxDecoration(
        color: const Color(0xFF003A8A),
        border: Border.all(color: const Color(0x1FFFFFFF), width: 1),
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(color: Color(0xFF375DFB), spreadRadius: 1, blurRadius: 0),
          BoxShadow(
            color: Color(0x7A253EA7),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Center(
                  child: Text(
                    'Bid Now',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      letterSpacing: -0.11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobDetail extends StatelessWidget {
  final String label;
  final String value;

  const _JobDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
              color: Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransporterNavigationBar extends StatelessWidget {
  final VoidCallback onMyBids;
  final VoidCallback onMyTrips;
  final VoidCallback onProfile;

  const _TransporterNavigationBar({
    required this.onMyBids,
    required this.onMyTrips,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final items = <({String label, Widget icon, VoidCallback? onTap})>[
      (
        label: 'Home',
        icon: SvgPicture.asset(
          'assets/icons/ic_nav_home.svg',
          key: const ValueKey('transporter-nav-home-icon'),
          width: 24,
          height: 24,
        ),
        onTap: null,
      ),
      (
        label: 'My Bids',
        icon: Image.asset(
          'assets/icons/ic_Mybids.png',
          key: const ValueKey('transporter-nav-my-bids-icon'),
          width: 24,
          height: 24,
        ),
        onTap: onMyBids,
      ),
      (
        label: 'My trips',
        icon: Image.asset(
          'assets/icons/ic_My_Trips.png',
          key: const ValueKey('transporter-nav-my-trips-icon'),
          width: 24,
          height: 24,
        ),
        onTap: onMyTrips,
      ),
      (
        label: 'Profile',
        icon: Image.asset(
          'assets/icons/ic_nav_profile.png',
          key: const ValueKey('transporter-nav-profile-icon'),
          width: 24,
          height: 24,
        ),
        onTap: onProfile,
      ),
    ];

    return Container(
      height: 75 + bottomPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 75,
            child: Row(
              children: [
                for (var index = 0; index < items.length; index++)
                  Expanded(
                    child: GestureDetector(
                      key: ValueKey(
                        'transporter-nav-item-${items[index].label}',
                      ),
                      onTap: items[index].onTap,
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              index == 0
                                  ? const Color(0xFF003A8A)
                                  : const Color(0xFF6C7278),
                              items[index].icon is SvgPicture
                                  ? BlendMode.srcIn
                                  : BlendMode.srcATop,
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: items[index].icon,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            items[index].label,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              height: 18 / 10,
                              letterSpacing: -0.17,
                              color: index == 0
                                  ? const Color(0xFF003A8A)
                                  : const Color(0xFF030303),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
