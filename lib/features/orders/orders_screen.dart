import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_expandable_card.dart';
import '../../models/order.dart';
import 'order_details_screen.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────
const List<Order> _kOrders = [
  Order(
    id: '#ORD123456',
    productName: '10 KW Solar Panel',
    productImagePath:
        'assets/images/solarimages/8c95b22c561eba1d7752be96d662579cfd873d93.jpg',
    price: '45000',
    deliveryLocation: 'Pune, Maharashtra',
    buyer: 'Green Energy Installers',
    orderDate: '10 Sept 2026',
    status: OrderStatus.pending,
    quantity: 2,
    subtotal: 90000,
    gstPercent: 18,
  ),
  Order(
    id: '#ORD1234564',
    productName: '10 KW Solar Panel',
    productImagePath:
        'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
    price: '45000',
    deliveryLocation: 'Mumbai, Maharashtra',
    buyer: 'SunRise Solar Co.',
    orderDate: '05 Sept 2026',
    status: OrderStatus.delivered,
    quantity: 2,
    subtotal: 90000,
    gstPercent: 18,
  ),
];

// ── Filter enum ────────────────────────────────────────────────────────────────
enum _Filter { all, pending, delivered }

extension _FilterExt on _Filter {
  String get label {
    switch (this) {
      case _Filter.all:
        return 'All';
      case _Filter.pending:
        return 'Pending';
      case _Filter.delivered:
        return 'Delivered';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ORDERS SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _Filter _selectedFilter = _Filter.all;

  List<Order> get _filteredOrders {
    switch (_selectedFilter) {
      case _Filter.all:
        return _kOrders;
      case _Filter.pending:
        return _kOrders.where((o) => o.status == OrderStatus.pending).toList();
      case _Filter.delivered:
        return _kOrders
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
    }
  }

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
            // ── Header — same gradient + size as MyProducts ──
            _buildHeader(context),

            // ── Filter tabs ───────────────────────────────────
            _buildFilterTabs(),
            const SizedBox(height: 12),

            // ── Order list ────────────────────────────────────
            Expanded(
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) =>
                          _buildOrderCard(_filteredOrders[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header — statusBar + 133px, same as MyProducts ──────────
  Widget _buildHeader(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'My Orders',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Filter tabs: All / Pending / Delivered ───────────────────
  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _filterTab(_Filter.all),
          const SizedBox(width: 12.85),
          _filterTab(_Filter.pending),
          const SizedBox(width: 12.86),
          _filterTab(_Filter.delivered),
        ],
      ),
    );
  }

  Widget _filterTab(_Filter filter) {
    final isSelected = filter == _selectedFilter;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        width: 72.43,
        height: 27,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003A8A) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF003A8A), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          filter.label,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF003A8A),
            height: 18 / 12,
            letterSpacing: -0.14,
          ),
        ),
      ),
    );
  }

  // ── Order card ───────────────────────────────────────────────
  Widget _buildOrderCard(Order order) {
    return AppExpandableCard(
      imagePath: order.productImagePath,
      title: order.productName,
      idNumber: order.id,
      price: _fmtPrice(order.subtotal),
      statusText: order.status.displayName,
      statusBackgroundColor: order.status.backgroundColor,
      statusTextColor: order.status.textColor,
      maxWidth: double.infinity,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different filter',
            style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  /// Format a double as rupee amount string (e.g. 100000 → "100000")
  String _fmtPrice(double v) => v.toInt().toString();
}
