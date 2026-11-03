import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_rfq_request_card.dart';
import 'package:flutter_app/core/widgets/app_bottom_sheet.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/vendor/data/datasources/vendor_rfq_data.dart';
import 'package:flutter_app/features/vendor/domain/entities/vendor_rfq_request.dart';
import 'package:flutter_app/features/vendor/presentation/cubit/vendor_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ───────────────────────────────────────────────────────────────────────────── Vendor — RFQ
class VendorRfqRequestsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const VendorRfqRequestsScreen({super.key, this.onBackPressed});

  @override
  State<VendorRfqRequestsScreen> createState() =>
      _VendorRfqRequestsScreenState();
}

class _VendorRfqRequestsScreenState extends State<VendorRfqRequestsScreen> {
  final VendorRequestListCubit _requestListCubit = VendorRequestListCubit();

  List<VendorRfqRequest> get _filtered =>
      _requestListCubit.filterRequests(VendorRfqData.requests);

  @override
  void dispose() {
    _requestListCubit.close();
    super.dispose();
  }

  void _openDetailSheet(VendorRfqRequest request) {
    AppBottomSheet.show(
      context: context,
      horizontalPadding: 0,
      bottomPadding: 0,
      child: _RfqDetailSheet(
        request: request,
        onProceedToCheckout: () {
          Navigator.pop(context); // close sheet
          context.push(AppRoutes.vendorCheckout, extra: request);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorRequestListCubit, VendorRequestFilter>(
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

  // ── Filter tab bar ──────────────────────────────────────────
  Widget _buildTabBar(VendorRequestFilter state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 28, 0, 11),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabChip(
            label: 'All',
            isActive: state == VendorRequestFilter.all,
            onTap: () => _requestListCubit.select(VendorRequestFilter.all),
          ),
          const SizedBox(width: 12.85),
          _TabChip(
            label: 'Received',
            isActive: state == VendorRequestFilter.received,
            onTap: () => _requestListCubit.select(VendorRequestFilter.received),
          ),
          const SizedBox(width: 12.85),
          _TabChip(
            label: 'Pending',
            isActive: state == VendorRequestFilter.pending,
            onTap: () => _requestListCubit.select(VendorRequestFilter.pending),
          ),
        ],
      ),
    );
  }

  // ── Request list ────────────────────────────────────────────
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
      itemBuilder: (context, i) => VendorRfqRequestCard(
        request: items[i],
        imagePath:
            'assets/solarimages/5dc175c533f86ed941b1004c6b373c14c68068d0.png',
        onTap: () => _openDetailSheet(items[i]),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── Filter tab chip
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

// ───────────────────────────────────────────────────────────────────────────── RFQ Detail Bottom
class _RfqDetailSheet extends StatelessWidget {
  final VendorRfqRequest request;
  final VoidCallback onProceedToCheckout;

  const _RfqDetailSheet({
    required this.request,
    required this.onProceedToCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, safeBottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Supplier row ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/solarimages/5dc175c533f86ed941b1004c6b373c14c68068d0.png',
                width: 29,
                height: 43,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 29,
                  height: 43,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Color(0xFF6C7278),
                  ),
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
                      height: 22 / 14,
                      letterSpacing: -0.18,
                    ),
                  ),
                  Text(
                    request.dateLabel,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                      height: 16 / 9,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── Order and totals table ─────────────────────
          _RequestDetailsTable(request: request),

          const SizedBox(height: 20),

          // ── Proceed to checkout button ─────────────────
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: request.status == VendorRfqStatus.received
                  ? onProceedToCheckout
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003A8A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Proceed to checkout',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────── Summary row helper
class _RequestDetailsTable extends StatelessWidget {
  final VendorRfqRequest request;

  const _RequestDetailsTable({required this.request});

  @override
  Widget build(BuildContext context) {
    final rows = <_RequestTableRowData>[
      for (final item in request.items)
        _RequestTableRowData(
          label: item.productName,
          detail: _formatQuantity(item.qty),
          value: item.price,
        ),
      _RequestTableRowData(label: 'Sub Total', value: request.subTotal),
      _RequestTableRowData(label: 'Gst 18%', value: request.gst),
      _RequestTableRowData(label: 'Total', value: request.total, isBold: true),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < rows.length; index++)
            _RequestTableRow(
              row: rows[index],
              index: index,
              isLast: index == rows.length - 1,
            ),
        ],
      ),
    );
  }
}

class _RequestTableRowData {
  final String label;
  final String value;
  final String? detail;
  final bool isBold;

  const _RequestTableRowData({
    required this.label,
    required this.value,
    this.detail,
    this.isBold = false,
  });
}

class _RequestTableRow extends StatelessWidget {
  final _RequestTableRowData row;
  final int index;
  final bool isLast;

  const _RequestTableRow({
    required this.row,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final rowColor = index >= 2 && index.isEven
        ? const Color(0xFFF5F5F5)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: rowColor,
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
                    color: row.detail == null
                        ? const Color(0xFF6C7278)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                if (row.detail != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    row.detail!,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
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

String _formatQuantity(String quantity) => quantity
    .trim()
    .replaceAll(RegExp(r'\s*x\s*'), 'x ')
    .replaceAll(RegExp(r'\s*=\s*'), ' =');
