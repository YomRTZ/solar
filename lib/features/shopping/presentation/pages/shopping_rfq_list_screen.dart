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
        imagePath: 'assets/solarimages/vendor_brand_mark.png',
        onProceedToCheckout: () {
          Navigator.pop(context);
          context.push(AppRoutes.vendorCheckout, extra: request);
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
        imagePath: 'assets/solarimages/vendor_brand_mark.png',
        onTap: items[i].status == CatalogRfqStatus.pending
            ? null
            : () => _openDetailSheet(items[i]),
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

class _RfqDetailSheet extends StatelessWidget {
  final CatalogRfqRequest request;
  final String imagePath;
  final VoidCallback onProceedToCheckout;

  const _RfqDetailSheet({
    required this.request,
    required this.imagePath,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 29,
                height: 43,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const SizedBox(
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
                    'Sun Tech Sol.',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF202020),
                    ),
                  ),
                  Text(
                    request.dateLabel,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          _RequestDetailsTable(request: request),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: request.status == CatalogRfqStatus.received
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestDetailsTable extends StatelessWidget {
  final CatalogRfqRequest request;
  const _RequestDetailsTable({required this.request});

  @override
  Widget build(BuildContext context) {
    final rows = <_Row>[
      for (final item in request.items)
        _Row(label: item.productName, detail: item.qty, value: item.price),
      _Row(label: 'Sub Total', value: request.subTotal),
      _Row(label: 'Gst 18%', value: request.gst),
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
  final String? detail;
  final bool isBold;
  const _Row({
    required this.label,
    required this.value,
    this.detail,
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
            child: Text(
              row.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: row.isBold ? FontWeight.w700 : FontWeight.w500,
                color: row.detail == null
                    ? const Color(0xFF6C7278)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (row.detail != null) ...[
            Text(
              row.detail!,
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(width: 8),
          ],
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
