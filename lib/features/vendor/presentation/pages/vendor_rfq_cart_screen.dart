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
import 'package:flutter_app/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:flutter_app/features/vendor/data/datasources/vendor_rfq_data.dart';
import 'package:flutter_app/features/vendor/domain/entities/vendor_rfq_request.dart';
import 'package:flutter_app/features/rfq/data/datasources/rfq_data.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Vendor â€” My RFQ
class VendorRfqCartScreen extends StatefulWidget {
  // Products already in the cart
  final List<CatalogProduct>? cartItems;

  // Initial quantities map (productId â†’ qty).  Defaults to 1 for each item.
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
  late final VendorCartCubit _cartCubit;

  @override
  void initState() {
    super.initState();
    final items = widget.cartItems ?? SupplierData.rfqCartItems;

    final quantities = <String, int>{};
    for (final item in items) {
      quantities[item.id] = widget.initialQuantities?[item.id] ?? 1;
    }
    _cartCubit = VendorCartCubit(items: items, initialQuantities: quantities);
  }

  @override
  void dispose() {
    _cartCubit.close();
    super.dispose();
  }

  void _increment(String id) => _cartCubit.increment(id);
  void _decrement(String id) => _cartCubit.decrement(id);

  void _sendRFQ() {
    final state = _cartCubit.state;
    if (state.items.isEmpty) return;

    final items = state.items.map((product) {
      final quantity = state.quantities[product.id] ?? 1;
      final lineTotal = _parseAmount(product.price) * quantity;
      return VendorOrderItem(
        productName: product.name,
        qty: '$quantity x 1 =',
        price: _formatAmount(lineTotal),
      );
    }).toList();
    final subtotal = state.items.fold<double>(
      0,
      (total, product) =>
          total +
          _parseAmount(product.price) * (state.quantities[product.id] ?? 1),
    );
    final gst = subtotal * 0.18;
    final supplierName = state.items.first.subtitle.replaceFirst(
      RegExp(r'^By\s+', caseSensitive: false),
      '',
    );

    final requestId = 'rfq-${DateTime.now().microsecondsSinceEpoch}';
    final requestDate = DateTime.now().toLocal().toString().split(' ').first;
    final totalQuantity = state.quantities.values.fold<int>(
      0,
      (total, quantity) => total + quantity,
    );
    VendorRfqData.add(
      VendorRfqRequest(
        id: requestId,
        supplierName: supplierName.isEmpty ? 'Supplier' : supplierName,
        amount: _formatAmount(subtotal + gst),
        dateLabel: 'Sent $requestDate',
        status: VendorRfqStatus.pending,
        items: items,
        subTotal: _formatAmount(subtotal),
        gst: _formatAmount(gst),
        total: _formatAmount(subtotal + gst),
      ),
    );
    RFQData.add(
      RFQ(
        id: requestId,
        rfqNumber: '#${requestId.toUpperCase()}',
        productTitle: state.items.map((product) => product.name).join(', '),
        imagePath: state.items.first.imagePath,
        price: _formatAmount(
          subtotal / (totalQuantity == 0 ? 1 : totalQuantity),
        ),
        requiredQty: '$totalQuantity Units',
        location: 'New Delhi',
        buyerName: 'Vendor',
        expectedDelivery: 'To be confirmed',
        status: RFQStatus.newRequest,
      ),
    );
    context.go(AppRoutes.vendorRfqStatus);
  }

  double _parseAmount(String value) =>
      double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  String _formatAmount(double value) => 'Rs. ${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCartCubit, VendorCartState>(
      bloc: _cartCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
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
              const SecondAppHeader(title: 'My RFQ Cart'),

              // â”€â”€ Cart list â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 19, 15, 9),
                        child: state.items.isEmpty
                            ? SizedBox(height: 270, child: _buildEmptyState())
                            : Column(
                                children: state.items.map((product) {
                                  final quantity =
                                      state.quantities[product.id] ?? 1;
                                  return VendorRfqCartCard(
                                    imagePath: product.imagePath,
                                    name: product.name,
                                    subtitle: product.subtitle,
                                    price: product.price,
                                    quantity: quantity,
                                    onDecrement: () => _decrement(product.id),
                                    onIncrement: () => _increment(product.id),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 33),
                      _buildSendButton(state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€ Empty state â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

  // â”€â”€ Send RFQ button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildSendButton(VendorCartState state) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(25, 0, 30, bottom + 16),
      child: AppContinueButton(
        text: 'Send RFQ',
        height: 44,
        showArrow: false,
        onPressed: state.items.isEmpty ? () {} : _sendRFQ,
        backgroundColor: state.items.isEmpty
            ? const Color(0xFFB0BEC5)
            : const Color(0xFF003A8A),
      ),
    );
  }
}
