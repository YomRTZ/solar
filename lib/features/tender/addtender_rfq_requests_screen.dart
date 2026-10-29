import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/addtender_rfq_request_card.dart';
import '../../core/widgets/app_bottom_sheet.dart';
import '../../data/addtender_rfq_data.dart';
import '../../models/addtender_rfq_request.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddTender — RFQ Requests Screen
//
// Layout:
//  • Dark-gradient header + back arrow + "RFQ Requests" title
//  • Filter tab bar: All | Received | Pending
//  • Filtered list of AddTenderRfqRequestCard widgets
//  • Tapping a card opens the RFQ detail bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class AddTenderRfqRequestsScreen extends StatefulWidget {
  const AddTenderRfqRequestsScreen({super.key});

  @override
  State<AddTenderRfqRequestsScreen> createState() =>
      _AddTenderRfqRequestsScreenState();
}

enum _Tab { all, received, pending }

class _AddTenderRfqRequestsScreenState
    extends State<AddTenderRfqRequestsScreen> {
  _Tab _activeTab = _Tab.all;

  List<AddTenderRfqRequest> get _filtered {
    switch (_activeTab) {
      case _Tab.all:
        return AddTenderRfqData.requests;
      case _Tab.received:
        return AddTenderRfqData.requests
            .where((r) => r.status == AddTenderRfqStatus.received)
            .toList();
      case _Tab.pending:
        return AddTenderRfqData.requests
            .where((r) => r.status == AddTenderRfqStatus.pending)
            .toList();
    }
  }

  void _openDetailSheet(AddTenderRfqRequest request) {
    AppBottomSheet.show(
      context: context,
      horizontalPadding: 0,
      bottomPadding: 0,
      child: _RfqDetailSheet(
        request: request,
        onProceedToCheckout: () {
          Navigator.pop(context); // close sheet
          context.push(AppRoutes.addTenderCheckout);
        },
      ),
    );
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
            _buildTabBar(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
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
              'RFQ Requests',
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

  // ── Filter tab bar ──────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFFF2F4F7),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          _TabChip(
            label: 'All',
            isActive: _activeTab == _Tab.all,
            onTap: () => setState(() => _activeTab = _Tab.all),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Received',
            isActive: _activeTab == _Tab.received,
            onTap: () => setState(() => _activeTab = _Tab.received),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Pending',
            isActive: _activeTab == _Tab.pending,
            onTap: () => setState(() => _activeTab = _Tab.pending),
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
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: items.length,
      separatorBuilder: (context, i) => const SizedBox(height: 12),
      itemBuilder: (context, i) => AddTenderRfqRequestCard(
        request: items[i],
        onTap: () => _openDetailSheet(items[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter tab chip
// ─────────────────────────────────────────────────────────────────────────────
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF003A8A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF003A8A) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF6C7278),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RFQ Detail Bottom Sheet content
// ─────────────────────────────────────────────────────────────────────────────
class _RfqDetailSheet extends StatelessWidget {
  final AddTenderRfqRequest request;
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Color(0xFF003A8A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.supplierName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    request.dateLabel,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ── Order items ───────────────────────────────
          ...request.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.productName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Text(
                    '${item.qty} ${item.price}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 24, color: Color(0xFFE5E7EB)),

          // ── Sub Total ─────────────────────────────────
          _SummaryRow(label: 'Sub Total', value: request.subTotal),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Gst 18%', value: request.gst),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Total', value: request.total, isBold: true),

          const SizedBox(height: 20),

          // ── Proceed to checkout button ─────────────────
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: onProceedToCheckout,
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

// ─────────────────────────────────────────────────────────────────────────────
// Summary row helper
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF6C7278),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
