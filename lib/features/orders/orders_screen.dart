import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // ── Mock orders data ──────────────────────────────────────
  static const List<Map<String, String>> _orders = [
    {
      'id': '#ORD001',
      'product': '10 KW Solar Panel',
      'qty': '20 Units',
      'amount': 'Rs. 200000',
      'date': '20 Oct 2026',
      'status': 'Delivered',
    },
    {
      'id': '#ORD002',
      'product': '5 KW Solar Panel',
      'qty': '10 Units',
      'amount': 'Rs. 50000',
      'date': '18 Oct 2026',
      'status': 'Processing',
    },
    {
      'id': '#ORD003',
      'product': 'Solar Battery 150Ah',
      'qty': '5 Units',
      'amount': 'Rs. 42500',
      'date': '15 Oct 2026',
      'status': 'Shipped',
    },
    {
      'id': '#ORD004',
      'product': 'Solar Inverter 5KW',
      'qty': '3 Units',
      'amount': 'Rs. 45000',
      'date': '10 Oct 2026',
      'status': 'Delivered',
    },
    {
      'id': '#ORD005',
      'product': '15 KW Solar Panel',
      'qty': '8 Units',
      'amount': 'Rs. 120000',
      'date': '05 Oct 2026',
      'status': 'Cancelled',
    },
  ];

  Color _statusBg(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFFD3F3E1);
      case 'Processing':
        return const Color(0xFFC3E1FE);
      case 'Shipped':
        return const Color(0xFFFFD78E);
      case 'Cancelled':
        return const Color(0xFFFFEBEB);
      default:
        return const Color(0xFFEDF1F3);
    }
  }

  Color _statusText(String status) {
    switch (status) {
      case 'Delivered':
        return const Color(0xFF217552);
      case 'Processing':
        return const Color(0xFF113CF5);
      case 'Shipped':
        return const Color(0xFFFFA500);
      case 'Cancelled':
        return const Color(0xFFB31515);
      default:
        return const Color(0xFF6C7278);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF003A8A),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: _orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return _buildOrderCard(order);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Text(
            'Orders',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── Order card ────────────────────────────────────────────
  Widget _buildOrderCard(Map<String, String> order) {
    final status = order['status']!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: order ID + status badge ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['id']!,
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF003A8A),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusBg(status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusText(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Product name ──────────────────────────────────
          Text(
            order['product']!,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF202020),
            ),
          ),
          const SizedBox(height: 6),

          // ── Bottom row: qty + amount + date ───────────────
          Row(
            children: [
              _chip(Icons.inventory_2_outlined, order['qty']!),
              const SizedBox(width: 12),
              _chip(Icons.currency_rupee_rounded, order['amount']!),
              const Spacer(),
              Text(
                order['date']!,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  color: const Color(0xFF6C7278),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF6C7278)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11,
            color: const Color(0xFF6C7278),
          ),
        ),
      ],
    );
  }
}
