import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_rfq_cart_card.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/supplier/data/datasources/supplier_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor — My RFQ
class VendorRfqCartScreen extends StatefulWidget {
  // Products already in the cart
  final List<CatalogProduct>? cartItems;

  // Initial quantities map (productId → qty).  Defaults to 1 for each item.
  final Map<String, int>? initialQuantities;

  const VendorRfqCartScreen({
    super.key,
    this.cartItems,
    this.initialQuantities,
  });

  @override
  State<VendorRfqCartScreen> createState() => _VendorRfqCartScreenState();
}

class _VendorRfqCartScreenState extends State<VendorRfqCartScreen> {
  late List<CatalogProduct> _items;
  late Map<String, int> _quantities;

  @override
  void initState() {
    super.initState();
    _items = widget.cartItems ?? SupplierData.rfqCartItems;

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
    context.go(AppRoutes.vendorRfqStatus);
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
            const SecondAppHeader(title: 'My RFQ Cart'),

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
                        return VendorRfqCartCard(
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
