import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/catalog/presentation/widgets/catalog_rfq_request_card.dart';
import 'package:flutter_app/core/widgets/app_bottom_sheet.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_rfq_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';
import 'package:flutter_app/features/shopping/presentation/cubit/shopping_rfq_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingRfqListScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ShoppingRfqListScreen({super.key, this.onBackPressed});

  @override
  State<ShoppingRfqListScreen> createState() => _ShoppingRfqListScreenState();
}

class _ShoppingRfqListScreenState extends State<ShoppingRfqListScreen> {
  final RfqRequestListCubit _requestListCubit = RfqRequestListCubit();

  List<CatalogRfqRequest> get _filtered =>
      _requestListCubit.filterRequests(CatalogRfqData.requests);

  @override
  void dispose() {
    _requestListCubit.close();
    super.dispose();
  }

  void _openDetailSheet(CatalogRfqRequest request) {
    AppBottomSheet.show(
      context: context,
      horizontalPadding: 0,
      bottomPadding: 0,
      child: _RfqDetailSheet(
        request: request,
        onAcceptBid: () {
          Navigator.pop(context);
          context.push(AppRoutes.vendorCheckout, extra: request);
        },
        onRejectBid: () {
          if (!CatalogRfqData.updateStatus(
            request.id,
            CatalogRfqStatus.rejected,
          )) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unable to reject this bid')),
            );
            return;
          }
          Navigator.pop(context);
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bid rejected')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RfqRequestListCubit, RfqRequestFilter>(
      bloc: _requestListCubit,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SecondAppHeader(
                title: 'RFQ Requests',
                onBackPressed:
                    widget.onBackPressed ?? () => Navigator.maybePop(context),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 18, right: 15),
                  child: Column(
                    children: [
                      _buildTabBar(state),
                      Expanded(child: _buildList()),
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

  Widget _buildTabBar(RfqRequestFilter state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 28, 0, 11),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabChip(
            label: 'All',
            isActive: state == RfqRequestFilter.all,
            onTap: () => _requestListCubit.select(RfqRequestFilter.all),
          ),
          const SizedBox(width: 12.85),
          _TabChip(
            label: 'Received',
            isActive: state == RfqRequestFilter.received,
            onTap: () => _requestListCubit.select(RfqRequestFilter.received),
          ),
          const SizedBox(width: 12.85),
          _TabChip(
            label: 'Pending',
            isActive: state == RfqRequestFilter.pending,
            onTap: () => _requestListCubit.select(RfqRequestFilter.pending),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No requests found',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
      itemCount: items.length,
      itemBuilder: (context, i) => CatalogRfqRequestCard(
        request: items[i],
        imagePath: 'assets/solarimages/solar_panel_product.png',
        onTap: () => _openDetailSheet(items[i]),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.43,
        height: 27,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF003A8A) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF003A8A), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF003A8A),
            height: 18 / 12,
            letterSpacing: -0.14,
          ),
        ),
      ),
    );
  }
}

class _RfqDetailSheet extends StatefulWidget {
  final CatalogRfqRequest request;
  final VoidCallback onAcceptBid;
  final VoidCallback onRejectBid;

  const _RfqDetailSheet({
    required this.request,
    required this.onAcceptBid,
    required this.onRejectBid,
  });

  @override
  State<_RfqDetailSheet> createState() => _RfqDetailSheetState();
}

class _RfqDetailSheetState extends State<_RfqDetailSheet> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent to ${widget.request.supplierName}')),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final request = widget.request;
    final canRespond = request.status == CatalogRfqStatus.received;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, safeBottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFFFE6EC),
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Color(0xFF003A8A),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.supplierName,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF202020),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Price Breakup',
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF202020),
            ),
          ),
          const SizedBox(height: 18),
          _RequestDetailsTable(request: request),
          const SizedBox(height: 10),
          TextField(
            controller: _messageController,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _sendMessage(),
            decoration: InputDecoration(
              hintText: 'Send Negotiation Message...',
              hintStyle: GoogleFonts.roboto(
                fontSize: 11,
                color: const Color(0xFF9AA1A8),
              ),
              suffixIcon: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send_rounded,
                  size: 18,
                  color: Color(0xFF1683F8),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: Row(
              children: [
                Expanded(
                  child: _BidActionButton(
                    label: 'Reject Bid',
                    color: const Color(0xFFF51E1E),
                    onPressed: canRespond ? widget.onRejectBid : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _BidActionButton(
                    label: 'Accept Bid',
                    color: const Color(0xFF3CCB67),
                    onPressed: canRespond ? widget.onAcceptBid : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BidActionButton extends StatelessWidget {
  const _BidActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFB7BEC5),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _RequestDetailsTable extends StatelessWidget {
  final CatalogRfqRequest request;
  const _RequestDetailsTable({required this.request});

  @override
  Widget build(BuildContext context) {
    final items = request.items;
    final rows = <_Row>[
      _Row(
        label: 'Base Fare',
        value: items.isNotEmpty ? items.first.price : request.amount,
      ),
      _Row(
        label: 'Loading Charges',
        value: items.length > 1 ? items[1].price : 'Rs. 0',
      ),
      _Row(label: 'Unloading Charges', value: request.subTotal),
      _Row(label: 'Toll / Other Charges', value: request.gst),
      _Row(label: 'Total', value: request.total, isBold: true),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            _RowWidget(row: rows[i], index: i, isLast: i == rows.length - 1),
        ],
      ),
    );
  }
}

class _Row {
  final String label;
  final String value;
  final bool isBold;
  const _Row({
    required this.label,
    required this.value,
    this.isBold = false,
  });
}

class _RowWidget extends StatelessWidget {
  final _Row row;
  final int index;
  final bool isLast;
  const _RowWidget({
    required this.row,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: index >= 2 && index.isEven
            ? const Color(0xFFF5F5F5)
            : Colors.white,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: row.isBold ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF6C7278),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            row.value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: row.isBold ? FontWeight.w800 : FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
