import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/widgets.dart';
import '../../models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────
            SecondAppHeader(
              title: 'Order Details',
              onBackPressed: () => Navigator.pop(context),
            ),

            // ── Scrollable content ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Status badge (top-right) ──────────────
                    Align(
                      alignment: Alignment.centerRight,
                      child: _StatusBadge(status: order.status),
                    ),
                    const SizedBox(height: 12),

                    // ── Top info rows (ID + product, location, buyer, date)
                    _buildTopInfoSection(),
                    const SizedBox(height: 20),

                    const Divider(height: 1, color: Color(0xFFEDF1F3)),
                    const SizedBox(height: 20),

                    // ── Product row ───────────────────────────
                    _buildProductRow(),
                    const SizedBox(height: 20),

                    const Divider(height: 1, color: Color(0xFFEDF1F3)),
                    const SizedBox(height: 16),

                    // ── Subtotal / GST / Total ────────────────
                    _buildPricingSection(),
                    const SizedBox(height: 32),

                    // ── Track History button ──────────────────
                    AppContinueButton(
                      text: 'Track History',
                      showArrow: false,
                      onPressed: () =>
                          context.push(AppRoutes.trackStatus, extra: order),
                    ),
                    const SizedBox(height: 12),
                    AppContinueButton(
                      text: 'Update Status',
                      showArrow: false,
                      onPressed: () => context.push(
                        AppRoutes.orderStatusUpdate,
                        extra: order,
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

  // ── Top info: two-column label / value rows ──────────────────
  Widget _buildTopInfoSection() {
    return Column(
      children: [
        // Order ID row — ID on left, product name on right (bold)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                order.id,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 22 / 14,
                  letterSpacing: -0.18,
                  color: const Color(0xFF202020),
                ),
              ),
            ),
            Expanded(
              child: Text(
                order.productName,
                textAlign: TextAlign.right,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 22 / 14,
                  letterSpacing: -0.18,
                  color: const Color(0xFF202020),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _infoRow(
          'Delivery Location',
          order.deliveryLocation,
          valueColor: const Color(0xFF4E4C4C),
        ),
        const SizedBox(height: 12),
        _infoRow('Buyer', order.buyer, valueColor: const Color(0xFF000000)),
        const SizedBox(height: 12),
        _infoRow(
          'Order Date',
          order.orderDate,
          valueColor: const Color(0xFF4E4C4C),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value, {required Color valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 16 / 13,
              letterSpacing: 0,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 16 / 13,
              letterSpacing: 0,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  // ── Product image + name + price + qty ───────────────────────
  Widget _buildProductRow() {
    return Row(
      children: [
        // Product image thumbnail
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            order.productImagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.wb_sunny_outlined,
                color: Colors.grey,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Name + qty
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.productName,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 22 / 14,
                  letterSpacing: -0.18,
                  color: const Color(0xFF202020),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty : ${order.quantity}',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 22 / 12,
                  letterSpacing: -0.18,
                  color: const Color(0xFF666060),
                ),
              ),
            ],
          ),
        ),

        // Unit price
        Text(
          'Rs. ${_fmt(double.parse(order.price))}',
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 22 / 14,
            letterSpacing: -0.18,
            color: const Color(0xFF202020),
          ),
        ),
      ],
    );
  }

  // ── Subtotal / GST / Total ───────────────────────────────────
  Widget _buildPricingSection() {
    return Column(
      children: [
        _priceRow('Subtotal', order.subtotal),
        const SizedBox(height: 10),
        _priceRow('Gst (${order.gstPercent.toInt()}%)', order.gstAmount),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFFEDF1F3)),
        const SizedBox(height: 14),
        _priceRow('Total', order.total),
      ],
    );
  }

  Widget _priceRow(String label, double amount) {
    final style = GoogleFonts.roboto(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      height: 16 / 13,
      letterSpacing: 0,
      color: const Color(0xFF000000),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('Rs. ${_fmt(amount)}', textAlign: TextAlign.right, style: style),
      ],
    );
  }

  /// Format a double as integer string with comma for thousands
  String _fmt(double v) {
    final intVal = v.toInt();
    if (intVal >= 1000) {
      final left = intVal ~/ 1000;
      final right = (intVal % 1000).toString().padLeft(3, '0');
      return '$left,$right';
    }
    return intVal.toString();
  }
}

// ── Status badge widget ──────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: status.textColor,
        ),
      ),
    );
  }
}
