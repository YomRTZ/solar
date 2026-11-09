import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_expandable_card.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/orders/data/datasources/orders_data.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';
import 'package:flutter_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class OrdersScreen extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const OrdersScreen({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersCubit _ordersCubit = OrdersCubit();

  List<Order> get _filteredOrders =>
      _ordersCubit.filterOrders(OrdersData.orders);

  @override
  void dispose() {
    _ordersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      bloc: _ordersCubit,
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
          extendBodyBehindAppBar: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SecondAppHeader(
                title: 'My Orders',
                showBackButton: widget.showBackButton,
                onBackPressed: widget.onBackPressed,
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 18, right: 15),
                  child: Column(
                    children: [
                      _buildFilterTabs(),
                      Expanded(
                        child: _filteredOrders.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
                                itemCount: _filteredOrders.length,
                                itemBuilder: (context, index) =>
                                    _buildOrderCard(_filteredOrders[index]),
                              ),
                      ),
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

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 28, 0, 11),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _filterTab(_Filter.all),
          const SizedBox(width: 12.85),
          _filterTab(_Filter.pending),
          const SizedBox(width: 12.85),
          _filterTab(_Filter.delivered),
        ],
      ),
    );
  }

  Widget _filterTab(_Filter filter) {
    final isSelected = filter.index == _ordersCubit.state.filter.index;
    return GestureDetector(
      onTap: () => _ordersCubit.selectFilter(OrdersFilter.values[filter.index]),
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
      onTap: () => context.push(AppRoutes.orderDetails, extra: order),
    );
  }

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

  // Format a double as rupee amount string (e.g. 100000 → "100000")
  String _fmtPrice(double v) => v.toInt().toString();
}
