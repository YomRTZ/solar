import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_product_card.dart';
import '../../data/rfq_data.dart';
import '../../models/rfq.dart';
import 'rfq_detail_screen.dart';

class RFQRequestsScreen extends StatefulWidget {
  final bool showBackButton;
  const RFQRequestsScreen({super.key, this.showBackButton = false});

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
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildFilterTabs(),
            const SizedBox(height: 16),
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final rfq = _filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppProductCard(
                            imagePath: rfq.imagePath,
                            title: rfq.productTitle,
                            rfqNumber: rfq.rfqNumber,
                            price: rfq.price,
                            statusText: rfq.status.displayName,
                            statusBackgroundColor: rfq.status.backgroundColor,
                            statusTextColor: rfq.status.textColor,
                            maxWidth: double.infinity,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RFQDetailScreen(rfq: rfq),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header — same height as HomeScreen (statusBarH + 133) ──
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
          children: [
            // Back arrow — always shown
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'RFQ Requests',
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
      ),
    );
  }

  // ── Filter Tabs ────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tab(label: 'All', value: null),
          const SizedBox(width: 10),
          _tab(label: 'New', value: RFQStatus.newRequest),
          const SizedBox(width: 10),
          _tab(label: 'Open', value: RFQStatus.open),
        ],
      ),
    );
  }

  Widget _tab({required String label, required RFQStatus? value}) {
    final isActive = _activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF003D82) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? const Color(0xFF003D82)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFF6C7278),
            ),
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
