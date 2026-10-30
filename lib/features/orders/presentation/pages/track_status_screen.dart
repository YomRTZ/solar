import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/orders/data/datasources/order_dispatch_updates.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';

// ───────────────────────────────────────────────────────────────────────────── DATA MODEL

enum TrackStep { orderConfirmed, dispatched, inTransit, delivered }

extension TrackStepExt on TrackStep {
  String get title {
    switch (this) {
      case TrackStep.orderConfirmed:
        return 'Order Confirmed';
      case TrackStep.dispatched:
        return 'Dispatched';
      case TrackStep.inTransit:
        return 'In Transit';
      case TrackStep.delivered:
        return 'Delivered';
    }
  }

  IconData get icon {
    switch (this) {
      case TrackStep.orderConfirmed:
        return Icons.check_circle_outline_rounded;
      case TrackStep.dispatched:
        return Icons.local_shipping_outlined;
      case TrackStep.inTransit:
        return Icons.settings_outlined;
      case TrackStep.delivered:
        return Icons.shield_outlined;
    }
  }
}

class TrackEvent {
  final TrackStep step;
  final String? dateTime;
  final List<String> imagePaths;
  final Uint8List? imageBytes;
  final String? subText; // e.g. OTP line

  const TrackEvent({
    required this.step,
    this.dateTime,
    this.imagePaths = const [],
    this.imageBytes,
    this.subText,
  });

  bool get isActive =>
      step == TrackStep.delivered || dateTime != null || subText != null;
}

// ───────────────────────────────────────────────────────────────────────────── SCREEN

class TrackStatusScreen extends StatelessWidget {
  final Order order;

  // Demo events — in production this would come from the Order / API
  static final List<TrackEvent> _events = [
    const TrackEvent(
      step: TrackStep.orderConfirmed,
      dateTime: '18 Oct 2026 | 09:10 AM',
    ),
    TrackEvent(
      step: TrackStep.dispatched,
      dateTime: '20 Oct 2026 | 09:10 AM',
      imagePaths: [
        'assets/solarimages/03f133a91b6e5ade2638722f368e27d2f92f051b.png',
      ],
    ),
    TrackEvent(step: TrackStep.inTransit),
    TrackEvent(step: TrackStep.delivered),
  ];

  const TrackStatusScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────
            const SecondAppHeader(
              title: 'Track Status',
              centerContentVertically: false,
            ),

            // ── Timeline ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Build timeline rows
                    ..._buildTimeline(),
                    const SizedBox(height: 36),

                    // ── Back to dashboard ──────────────────
                    _DashboardButton(onTap: () => context.go(AppRoutes.home)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeline() {
    final dispatchUpdate = OrderDispatchUpdates.forOrder(order.id);
    final events = _events.map((event) {
      if (event.step != TrackStep.dispatched || dispatchUpdate == null) {
        return event;
      }

      return TrackEvent(
        step: TrackStep.dispatched,
        dateTime: dispatchUpdate.dispatchDate,
        imagePaths: dispatchUpdate.proofImageAssetPath == null
            ? const []
            : [dispatchUpdate.proofImageAssetPath!],
        imageBytes: dispatchUpdate.proofImageBytes,
        subText:
            'Transporter: ${dispatchUpdate.transporter} · Tracking Number: ${dispatchUpdate.trackingNumber}',
      );
    }).toList();

    final widgets = <Widget>[];
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final isLast = i == events.length - 1;
      widgets.add(_TimelineRow(event: event, showConnector: !isLast));
    }
    return widgets;
  }
}

// ───────────────────────────────────────────────────────────────────────────── TIMELINE ROW

class _TimelineRow extends StatelessWidget {
  final TrackEvent event;
  final bool showConnector;

  const _TimelineRow({required this.event, required this.showConnector});

  static const _activeBlue = Color(0xFF003A8A);
  static const _inactiveGrey = Color(0xFF808080);

  @override
  Widget build(BuildContext context) {
    final isActive = event.isActive;
    final titleColor = event.step == TrackStep.inTransit
        ? const Color(0xFF808080)
        : isActive
        ? _activeBlue
        : _inactiveGrey;
    final subTextColor = isActive ? _activeBlue : _inactiveGrey;
    final timelineColor =
        event.step == TrackStep.orderConfirmed ||
            event.step == TrackStep.dispatched
        ? _activeBlue
        : _inactiveGrey;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left column: icon + vertical connector ─────────
          SizedBox(
            width: 36,
            child: Column(
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Ellipse 65.svg',
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                          timelineColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      switch (event.step) {
                        TrackStep.orderConfirmed => SvgPicture.asset(
                          'assets/icons/location-tick1.svg',
                          width: 32,
                          height: 32,
                        ),
                        TrackStep.dispatched => Image.asset(
                          'assets/icons/shop.png',
                          width: 18,
                          height: 18,
                        ),
                        TrackStep.inTransit => SvgPicture.asset(
                          'assets/icons/truck-fast.svg',
                          width: 18,
                          height: 18,
                        ),
                        TrackStep.delivered => SvgPicture.asset(
                          'assets/icons/Vector1.svg',
                          width: 16.56,
                          height: 19.1427,
                        ),
                      },
                    ],
                  ),
                ),
                // Dashed vertical connector
                if (showConnector)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _DashedLine(color: timelineColor),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // ── Right column: title + date + images ────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showConnector ? 20 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  // Step title
                  Text(
                    event.step.title,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0,
                      color: titleColor,
                    ),
                  ),

                  // Date/time
                  if (event.dateTime != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      event.dateTime!,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.9,
                        letterSpacing: 0,
                        color: const Color(0xFF7A7A7A),
                      ),
                    ),
                  ],

                  // Sub text (e.g. OTP line)
                  if (event.subText != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      event.subText!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: subTextColor,
                      ),
                    ),
                  ],

                  // Dispatch photo thumbnails
                  if (event.imagePaths.isNotEmpty ||
                      event.imageBytes != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            event.imagePaths.length +
                            (event.imageBytes == null ? 0 : 1),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          if (index >= event.imagePaths.length) {
                            return _Thumbnail(bytes: event.imageBytes!);
                          }
                          return _Thumbnail(path: event.imagePaths[index]);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── DASHED VERTICAL

class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color),
      child: const SizedBox(width: 3),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0;
    const dashSpace = 4.0;
    double startY = 0;
    final cx = size.width / 2;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(cx, startY),
        Offset(cx, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

// ───────────────────────────────────────────────────────────────────────────── THUMBNAIL

class _Thumbnail extends StatelessWidget {
  final String? path;
  final Uint8List? bytes;

  const _Thumbnail({this.path, this.bytes});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: bytes != null
          ? Image.memory(bytes!, width: 56, height: 56, fit: BoxFit.cover)
          : Image.asset(
              path!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                width: 56,
                height: 56,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_outlined,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── BACK TO DASHBOARD

class _DashboardButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DashboardButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003D82),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Back to dashboard',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
