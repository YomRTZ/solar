import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/app_product_card.dart';
import '../../data/dashboard_data.dart';
import '../../models/rfq.dart';
import '../orders/orders_screen.dart';
import '../products/add_product_screen.dart';
import '../products/my_products_screen.dart';
import '../profile/profile_screen.dart';
import '../rfq/rfq_detail_screen.dart';
import '../rfq/rfq_requests_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _bodyForIndex(int index) {
    switch (index) {
      case 0:
        return _HomeBody(onTabChange: (i) => setState(() => _currentIndex = i));
      case 1:
        return const MyProductsScreen();
      case 2:
        return const RFQRequestsScreen();
      case 3:
        return const OrdersScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox.shrink();
    }
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
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: _bodyForIndex(_currentIndex),
        bottomNavigationBar: _AppNavBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME BODY
// ─────────────────────────────────────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  final void Function(int) onTabChange;
  const _HomeBody({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ──────────────────────────────────────────
        _buildHeader(context),

        // ── Body — scrollable ───────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Stats 2×2 grid ─────────────────────────
                _buildStatsGrid(context),
                const SizedBox(height: 14),

                // ── Create New Product button ───────────────
                AppContinueButton(
                  text: 'Create New Product',
                  showArrow: false,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProductScreen()),
                  ),
                ),
                const SizedBox(height: 18),

                // ── Recent RFQs heading ─────────────────────
                Text(
                  'Recent RFQs',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF202020),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // ── RFQ cards ───────────────────────────────
                ...DashboardData.recentRFQs.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppProductCard(
                      statusBadgeOffsetY:
                          entry.value.status.displayName == 'New' ||
                              entry.value.status.displayName == 'Open'
                          ? 18
                          : 0,
                      imagePath: entry.value.imagePath,
                      title: entry.value.productTitle,
                      rfqNumber: entry.value.rfqNumber,
                      price: entry.value.price,
                      statusText: entry.value.status.displayName,
                      statusBackgroundColor: entry.value.status.backgroundColor,
                      statusTextColor: entry.value.status.textColor,
                      maxWidth: double.infinity,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RFQDetailScreen(rfq: entry.value),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Header: gradient bg + logo + app name + bell ──────────
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
      child: Stack(
        children: [
          // ── Logo: centered in visible 133px area ──────────
          Positioned(
            top: top + 46,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/a_clean_high_resolution_vector_like_logo_image_on.png',
                width: 64,
                height: 71,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.wb_sunny_rounded,
                  color: Colors.amber,
                  size: 60,
                ),
              ),
            ),
          ),

          // ── Notification bell ──────────────────────────────
          Positioned(
            top: top + 65,
            right: 12,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/images/icons/image_1374.png',
                  width: 32,
                  height: 32,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats 2×2 grid ─────────────────────────────────────────
  Widget _buildStatsGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _StatCard(
              label: 'All Products',
              value: DashboardData.allProducts.toString(),
            ),
            const SizedBox(width: 11),
            _StatCard(
              label: 'New RFQs',
              value: DashboardData.newRFQs.toString(),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            _StatCard(label: 'Orders', value: DashboardData.orders.toString()),
            const SizedBox(width: 11),
            _StatCard(
              label: 'My Balance',
              value: DashboardData.myBalance.toStringAsFixed(0),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Stat card ──────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 103,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF003A8A), Color(0xFF2D476A)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.2,
                letterSpacing: -0.24,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            Text(
              value,
              maxLines: 1,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.0,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV BAR
// ─────────────────────────────────────────────────────────────────────────────
class _AppNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppNavBar({required this.currentIndex, required this.onTap});

  // Each entry: svgPath/pngPath, label, isPng flag
  // Vector.svg is a pure path SVG — tint with colorFilter for active/inactive
  // The other 4 embed PNG bitmaps — rendered via Image.asset with ColorFiltered
  static const List<_NavItem> _items = [
    _NavItem(
      svgPath: 'assets/images/icons/Vector.svg',
      label: 'Home',
      isPng: false,
    ),
    _NavItem(
      svgPath: 'assets/images/icons/image_1380.png',
      label: 'Products',
      isPng: true,
    ),
    _NavItem(
      svgPath: 'assets/images/icons/image_1379.png',
      label: 'RFQs',
      isPng: true,
    ),
    _NavItem(
      svgPath: 'assets/images/icons/image_1376.png',
      label: 'Orders',
      isPng: true,
    ),
    _NavItem(
      svgPath: 'assets/images/icons/image_1382.png',
      label: 'Profile',
      isPng: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 75 + bottomPad,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 75,
            child: Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final isActive = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.isPng)
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              isActive
                                  ? const Color(0xFF003A8A)
                                  : const Color(0xFF6C7278),
                              BlendMode.srcATop,
                            ),
                            child: Image.asset(
                              item.svgPath,
                              width: 24,
                              height: 24,
                            ),
                          )
                        else
                          SvgPicture.asset(
                            item.svgPath,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              isActive
                                  ? const Color(0xFF003A8A)
                                  : const Color(0xFF6C7278),
                              BlendMode.srcIn,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 18 / 10,
                            letterSpacing: -0.17,
                            color: isActive
                                ? const Color(0xFF003A8A)
                                : const Color(0xFF030303),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: bottomPad),
        ],
      ),
    );
  }
}

class _NavItem {
  final String svgPath;
  final String label;
  final bool isPng;
  const _NavItem({
    required this.svgPath,
    required this.label,
    required this.isPng,
  });
}
