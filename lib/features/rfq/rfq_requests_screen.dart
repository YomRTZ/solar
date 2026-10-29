import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_expandable_card.dart';
import '../../core/widgets/second_app_header.dart';
import '../../data/rfq_data.dart';
import '../../models/rfq.dart';

class RFQRequestsScreen extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const RFQRequestsScreen({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  State<RFQRequestsScreen> createState() => _RFQRequestsScreenState();
}

class _RFQRequestsScreenState extends State<RFQRequestsScreen> {
  // null means "All"
  RFQStatus? _activeFilter;

  List<RFQ> get _filtered => RFQData.getByStatus(_activeFilter);

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
          children: [
            SecondAppHeader(
              title: 'RFQ Requests',
              showBackButton: widget.showBackButton,
              onBackPressed:
                  widget.onBackPressed ??
                  () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
            ),
            const SizedBox(height: 20),
            _buildFilterTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final rfq = _filtered[index];
                        return AppExpandableCard(
                          imagePath: rfq.imagePath,
                          title: rfq.productTitle,
                          idNumber: rfq.rfqNumber,
                          price: rfq.price,
                          statusText: rfq.status.displayName,
                          statusBackgroundColor: rfq.status.backgroundColor,
                          statusTextColor: rfq.status.textColor,
                          maxWidth: double.infinity,
                          onTap: () =>
                              context.push(AppRoutes.rfqDetail, extra: rfq),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter Tabs ────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tab(label: 'All', value: null),
            const SizedBox(width: 12.85),
            _tab(label: 'New', value: RFQStatus.newRequest),
            const SizedBox(width: 12.86),
            _tab(label: 'Open', value: RFQStatus.open),
          ],
        ),
      ),
    );
  }

  Widget _tab({required String label, required RFQStatus? value}) {
    final isActive = _activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
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

  // ── Empty State ────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No RFQ requests found',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
