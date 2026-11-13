import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/orders/data/datasources/order_dispatch_updates.dart';
import 'package:flutter_app/features/orders/data/datasources/orders_data.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';


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
        return 'Out for delivery';
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

  bool get isActive => dateTime != null || subText != null;
}


class TrackStatusScreen extends StatelessWidget {
  static const _inTransitMapPath =
      'assets/solarimages/Location_screen_confirm.jpg';

  final Order order;
  final bool isVendor;

  const TrackStatusScreen({super.key, required this.order, this.isVendor = false});

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
            const SecondAppHeader(title: 'Track Status'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Build timeline rows
                    ..._buildTimeline(),
                    const SizedBox(height: 36),

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
    final currentOrder = OrdersData.getById(order.id) ?? order;
    final dispatchUpdate = OrderDispatchUpdates.forOrder(currentOrder.id);
    final hasProgress =
        currentOrder.status == OrderStatus.dispatched ||
        currentOrder.status == OrderStatus.delivered;
    final isDelivered = currentOrder.status == OrderStatus.delivered;
    
    // For vendor route only: remove image and keep "In Transit" text
    if (isVendor) {
      final events = isDelivered
          ? const [
              TrackEvent(
                step: TrackStep.orderConfirmed,
                dateTime: '18 Oct 2026 | 09:10 AM',
              ),
              TrackEvent(
                step: TrackStep.dispatched,
                dateTime: '20 Oct 2026 | 09:10 AM',
              ),
              TrackEvent(
                step: TrackStep.inTransit,
                dateTime: '18 Oct 2026 | 09:10 AM',
                // No image for vendor route
              ),
              TrackEvent(
                step: TrackStep.delivered,
                subText: 'Share OTP - 3212 on delivery',
              ),
            ]
          : [
              TrackEvent(
                step: TrackStep.orderConfirmed,
                dateTime: currentOrder.orderDate,
              ),
              TrackEvent(
                step: TrackStep.dispatched,
                dateTime: dispatchUpdate?.dispatchDate,
                imagePaths: dispatchUpdate?.proofImageAssetPath == null
                    ? const []
                    : [dispatchUpdate!.proofImageAssetPath!],
                imageBytes: dispatchUpdate?.proofImageBytes,
                subText: dispatchUpdate == null
                    ? null
                    : 'Transporter: ${dispatchUpdate.transporter} · Tracking Number: ${dispatchUpdate.trackingNumber}',
              ),
              TrackEvent(
                step: TrackStep.inTransit,
                dateTime: hasProgress ? dispatchUpdate?.dispatchDate : null,
                // No image for vendor route
              ),
              const TrackEvent(step: TrackStep.delivered),
            ];

      final widgets = <Widget>[];
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        final isLast = i == events.length - 1;
        widgets.add(_TimelineRow(
          event: event,
          showConnector: !isLast,
          isDeliveredStatus: isDelivered,
          isVendor: true,
        ));
      }
      return widgets;
    }
    
    // Supplier route (original behavior - DO NOT CHANGE)
    final events = isDelivered
        ? const [
            TrackEvent(
              step: TrackStep.orderConfirmed,
              dateTime: '18 Oct 2026 | 09:10 AM',
            ),
            TrackEvent(
              step: TrackStep.dispatched,
              dateTime: '20 Oct 2026 | 09:10 AM',
            ),
            TrackEvent(
              step: TrackStep.inTransit,
              dateTime: '18 Oct 2026 | 09:10 AM',
              // No image when delivered
            ),
            TrackEvent(
              step: TrackStep.delivered,
              subText: 'Share OTP - 3212 on delivery',
            ),
          ]
        : [
            TrackEvent(
              step: TrackStep.orderConfirmed,
              dateTime: currentOrder.orderDate,
            ),
            TrackEvent(
              step: TrackStep.dispatched,
              dateTime: dispatchUpdate?.dispatchDate,
              imagePaths: dispatchUpdate?.proofImageAssetPath == null
                  ? const []
                  : [dispatchUpdate!.proofImageAssetPath!],
              imageBytes: dispatchUpdate?.proofImageBytes,
              subText: dispatchUpdate == null
                  ? null
                  : 'Transporter: ${dispatchUpdate.transporter} · Tracking Number: ${dispatchUpdate.trackingNumber}',
            ),
            TrackEvent(
              step: TrackStep.inTransit,
              dateTime: hasProgress ? dispatchUpdate?.dispatchDate : null,
              imagePaths: const [_inTransitMapPath],
            ),
            const TrackEvent(step: TrackStep.delivered),
          ];

    final widgets = <Widget>[];
    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      final isLast = i == events.length - 1;
      widgets.add(_TimelineRow(
        event: event,
        showConnector: !isLast,
        isDeliveredStatus: isDelivered,
        isVendor: false,
      ));
    }
    return widgets;
  }
}


class _TimelineRow extends StatelessWidget {
  final TrackEvent event;
  final bool showConnector;
  final bool isDeliveredStatus;
  final bool isVendor;

  const _TimelineRow({
    required this.event,
    required this.showConnector,
    this.isDeliveredStatus = false,
    this.isVendor = false,
  });

  static const _activeBlue = Color(0xFF003A8A);
  static const _inactiveGrey = Color(0xFF808080);

  @override
  Widget build(BuildContext context) {
    final isActive = event.isActive;
    // All active steps use #003A8A; inactive steps use grey
    final titleColor = isActive ? _activeBlue : _inactiveGrey;
    final subTextColor = isActive ? _activeBlue : _inactiveGrey;
    final dateColor = isActive ? _activeBlue : _inactiveGrey;
    final timelineColor = isActive ? _activeBlue : _inactiveGrey;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                        'assets/icons/ic_timeline_marker.svg',
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                          timelineColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      switch (event.step) {
                        TrackStep.orderConfirmed => SvgPicture.asset(
                          'assets/icons/ic_status_location_confirmed.svg',
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                            timelineColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        TrackStep.dispatched => Image.asset(
                          'assets/icons/ic_status_dispatched.png',
                          width: 18,
                          height: 18,
                          color: timelineColor,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                        TrackStep.inTransit => SvgPicture.asset(
                          'assets/icons/ic_delivery_truck.svg',
                          width: 18,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            timelineColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        TrackStep.delivered => SvgPicture.asset(
                          'assets/icons/ic_status_delivered.svg',
                          width: 16.56,
                          height: 19.1427,
                          colorFilter: ColorFilter.mode(
                            timelineColor,
                            BlendMode.srcIn,
                          ),
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
                    // Only change text for supplier (when NOT vendor) and delivered
                    event.step == TrackStep.inTransit && isDeliveredStatus && !isVendor
                        ? 'Reached your nearest hub'
                        : event.step.title,
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
                        color: dateColor,
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

                  if (event.step == TrackStep.inTransit &&
                      event.imagePaths.isNotEmpty &&
                      !isDeliveredStatus) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        event.imagePaths.first,
                        key: const ValueKey('in-transit-location-map'),
                        width: double.infinity,
                        height: 128,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 128,
                          color: const Color(0xFFF1F3F5),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.map_outlined,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                    ),
                  ]
                  // Dispatch photo thumbnails
                  else if (event.imagePaths.isNotEmpty ||
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
