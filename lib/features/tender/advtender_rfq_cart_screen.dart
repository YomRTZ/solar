import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/advtender_rfq_cart_card.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../data/advtender_data.dart';
import '../../models/catalog_product.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdvTender — My RFQ Cart Screen
//
// Layout:
//  • Dark-gradient header with back arrow + "My RFQ Cart"
//  • Scrollable list of AdvTenderRfqCartCard items with live qty state
//  • Sticky "Send RFQ" button pinned to the bottom
// ─────────────────────────────────────────────────────────────────────────────
class AdvTenderRfqCartScreen extends StatefulWidget {
  /// Products already in the cart.  Falls back to [AdvTenderData.rfqCartItems]
  /// when not provided (useful for standalone navigation).
  final List<CatalogProduct>? cartItems;

  /// Initial quantities map (productId → qty).  Defaults to 1 for each item.
  final Map<String, int>? initialQuantities;

  const AdvTenderRfqCartScreen({
    super.key,
    this.cartItems,
    this.initialQuantities,
  });

  @override
  State<AdvTenderRfqCartScreen> createState() => _AdvTenderRfqCartScreenState();
}

class _AdvTenderRfqCartScreenState extends State<AdvTenderRfqCartScreen> {
  late List<CatalogProduct> _items;
  late Map<String, int> _quantities;

  @override
  void initState() {
    super.initState();
    _items = widget.cartItems ?? AdvTenderData.rfqCartItems;

    // Seed quantities — use provided map or default every item to 1
    _quantities = {};
    for (final item in _items) {
      _quantities[item.id] = widget.initialQuantities?[item.id] ?? 1;
    }
  }

  void _increment(String id) =>
      setState(() => _quantities[id] = (_quantities[id] ?? 1) + 1);

  void _decrement(String id) {
    setState(() {
      final current = _quantities[id] ?? 1;
      if (current <= 1) {
        _items = _items.where((p) => p.id != id).toList();
        _quantities.remove(id);
      } else {
        _quantities[id] = current - 1;
      }
    });
  }

  void _sendRFQ() {
    context.go(AppRoutes.advTenderRfqStatus);
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
        backgroundColor: const Color(0xFFF2F4F7),
        body: Column(
          children: [
            _buildHeader(context),

            // ── Cart list ──────────────────────────────────
            Expanded(
              child: _items.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      itemCount: _items.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final product = _items[i];
                        final qty = _quantities[product.id] ?? 1;
                        return AdvTenderRfqCartCard(
                          imagePath: product.imagePath,
                          name: product.name,
                          subtitle: product.subtitle,
                          price: product.price,
                          quantity: qty,
                          onDecrement: () => _decrement(product.id),
                          onIncrement: () => _increment(product.id),
                        );
                      },
                    ),
            ),

            // ── Send RFQ button ────────────────────────────
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 64,
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
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'My RFQ Cart',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Your RFQ cart is empty',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // ── Send RFQ button ────────────────────────────────────────
  Widget _buildSendButton() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: const Color(0xFFF2F4F7),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
      child: AppContinueButton(
        text: 'Send RFQ',
        showArrow: false,
        onPressed: _items.isEmpty ? () {} : _sendRFQ,
        backgroundColor: _items.isEmpty
            ? const Color(0xFFB0BEC5)
            : const Color(0xFF003A8A),
      ),
    );
  }
}
