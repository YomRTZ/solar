import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tender_home_screen.dart';
import 'tender_all_categories_screen.dart';
import 'addtender_rfq_requests_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/tender_profile_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tender Main Screen — root shell with bottom navigation bar
//
// Tabs:
//   0  Home          → TenderHomeScreen
//   1  Categories    → TenderAllCategoriesScreen
//   2  My RFQs       → AddTenderRfqRequestsScreen
//   3  Orders        → OrdersScreen
//   4  Profile       → TenderProfileScreen
// ─────────────────────────────────────────────────────────────────────────────
class TenderMainScreen extends StatefulWidget {
  /// Optionally start on a specific tab index (default: 0 = Home).
  final int initialIndex;

  const TenderMainScreen({super.key, this.initialIndex = 0});

  @override
  State<TenderMainScreen> createState() => _TenderMainScreenState();
}

class _TenderMainScreenState extends State<TenderMainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Keep each tab alive when switching — use IndexedStack.
  List<Widget> get _pages => [
    const TenderHomeScreen(),
    TenderAllCategoriesScreen(onBackPressed: _showHomeTab),
    AddTenderRfqRequestsScreen(onBackPressed: _showHomeTab),
    const OrdersScreen(showBackButton: false),
    const TenderProfileScreen(),
  ];

  void _showHomeTab() {
    setState(() => _currentIndex = 0);
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
        // IndexedStack keeps all pages mounted so state is preserved
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: _TenderNavBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────
class _TenderNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _TenderNavBar({required this.currentIndex, required this.onTap});

  static const List<_NavItem> _items = [
    _NavItem(assetPath: 'assets/icons/Vector.svg', label: 'Home', isSvg: true),
    _NavItem(
      assetPath: 'assets/icons/category_nav_icon.png',
      label: 'Categories',
    ),
    _NavItem(assetPath: 'assets/icons/cart_nav_icon.png', label: 'My RFQs'),
    _NavItem(assetPath: 'assets/icons/orders_nav_icon.png', label: 'Orders'),
    _NavItem(
      assetPath: 'assets/icons/supplier_account_details_icon.png',
      label: 'Profile',
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
                const activeColor = Color(0xFF003A8A);
                const inactiveColor = Color(0xFF6C7278);
                final color = isActive ? activeColor : inactiveColor;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (item.isSvg)
                          SvgPicture.asset(
                            item.assetPath,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              color,
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              color,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              item.assetPath,
                              width: 24,
                              height: 24,
                            ),
                          ),

                        const SizedBox(height: 4),

                        // Label
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
                                ? activeColor
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
  final String assetPath;
  final String label;
  final bool isSvg;

  const _NavItem({
    required this.assetPath,
    required this.label,
    this.isSvg = false,
  });
}
