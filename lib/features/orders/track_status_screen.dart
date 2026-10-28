import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order.dart';
import '../home/home_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

enum TrackStep {
  orderConfirmed,
  dispatched,
  inTransit,
  outForDelivery,
  delivered,
}

extension TrackStepExt on TrackStep {
  String get title {
    switch (this) {
      case TrackStep.orderConfirmed:
        return 'Order Confirmed';
      case TrackStep.dispatched:
        return 'Dispatched';
      case TrackStep.inTransit:
        return 'In Transit';
      case TrackStep.outForDelivery:
        return 'Out for delivery';
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
      case TrackStep.outForDelivery:
        return Icons.check_circle_outline_rounded;
      case TrackStep.delivered:
        return Icons.shield_outlined;
    }
  }
}

class TrackEvent {
  final TrackStep step;
  final String? dateTime;
  final List<String> imagePaths;
  final String? subText; // e.g. OTP line

  const TrackEvent({
    required this.step,
    this.dateTime,
    this.imagePaths = const [],
    this.subText,
  });

  bool get isActive => dateTime != null || subText != null;
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

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
        'assets/images/photo_5979016740496674866_m.jpg',
        'assets/images/photo_5979016740496674867_y.jpg',
        'assets/images/photo_5979016740496674868_x.jpg',
        'assets/images/photo_5979016740496674891_x.jpg',
      ],
    ),
    const TrackEvent(
      step: TrackStep.inTransit,
      dateTime: '18 Oct 2026 | 09:10 AM',
    ),
    const TrackEvent(
      step: TrackStep.outForDelivery,
      subText: 'Share OTP - 3212 on delivery',
    ),
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
            _TrackHeader(),

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
                    _DashboardButton(
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                    ),
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
    final widgets = <Widget>[];
    for (int i = 0; i < _events.length; i++) {
      final event = _events[i];
      final isLast = i == _events.length - 1;
      widgets.add(
        _TimelineRow(
          event: event,
          showConnector: !isLast,
          // next event's active state determines if connector is active
          connectorActive: !isLast && _events[i + 1].isActive,
        ),
      );
    }
    return widgets;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _TrackHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 133,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 16, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Track Status',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TIMELINE ROW
// ─────────────────────────────────────────────────────────────────────────────

class _TimelineRow extends StatelessWidget {
  final TrackEvent event;
  final bool showConnector;
  final bool connectorActive;

  const _TimelineRow({
    required this.event,
    required this.showConnector,
    required this.connectorActive,
  });

  static const _activeBlue = Color(0xFF003A8A);
  static const _inactiveGrey = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    final isActive = event.isActive;
    final iconColor = isActive ? _activeBlue : _inactiveGrey;
    final titleColor = isActive ? _activeBlue : _inactiveGrey;
    final subTextColor = isActive ? _activeBlue : _inactiveGrey;
    final connectorColor = connectorActive ? _activeBlue : _inactiveGrey;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left column: icon + vertical connector ─────────
          SizedBox(
            width: 36,
            child: Column(
              children: [
                // Step icon circle
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? _activeBlue.withValues(alpha: 0.10)
                        : const Color(0xFFF0F0F0),
                    border: Border.all(
                      color: iconColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    event.step.icon,
                    color: iconColor,
                    size: 18,
                  ),
                ),
                // Dashed vertical connector
                if (showConnector)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _DashedLine(color: connectorColor),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // ── Right column: title + date + images ────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: showConnector ? 20 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  // Step title
                  Text(
                    event.step.title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),

                  // Date/time
                  if (event.dateTime != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      event.dateTime!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6C7278),
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
                  if (event.imagePaths.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: event.imagePaths.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 6),
                        itemBuilder: (context, index) => _Thumbnail(
                          path: event.imagePaths[index],
                        ),
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

// ─────────────────────────────────────────────────────────────────────────────
// DASHED VERTICAL LINE
// ─────────────────────────────────────────────────────────────────────────────

class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color),
      child: const SizedBox(width: 2),
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
      ..strokeWidth = 1.5
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

// ─────────────────────────────────────────────────────────────────────────────
// THUMBNAIL
// ─────────────────────────────────────────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  final String path;
  const _Thumbnail({required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        path,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => Container(
          width: 56,
          height: 56,
          color: Colors.grey[200],
          child: const Icon(Icons.image_outlined,
              size: 24, color: Colors.grey),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BACK TO DASHBOARD BUTTON
// ─────────────────────────────────────────────────────────────────────────────

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
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
