import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tender_home_screen.dart';
import 'tender_all_categories_screen.dart';
import 'addtender_rfq_requests_screen.dart';
import '../wallet/my_wallet_screen.dart';
import '../profile/tender_profile_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tender Main Screen — root shell with bottom navigation bar
//
// Tabs:
//   0  Home          → TenderHomeScreen
//   1  Categories    → TenderAllCategoriesScreen
//   2  My RFQs       → AddTenderRfqRequestsScreen
//   3  Wallet        → MyWalletScreen
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

  // Keep each tab alive when switching — use IndexedStack
  static const List<Widget> _pages = [
    TenderHomeScreen(),
    TenderAllCategoriesScreen(),
    AddTenderRfqRequestsScreen(),
    MyWalletScreen(),
    TenderProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
    _NavItem(pngPath: 'assets/images/icons/image_1374.png', label: 'Home'),
    _NavItem(pngPath: 'assets/images/icons/image_1380.png', label: 'Categories'),
    _NavItem(pngPath: 'assets/images/icons/image_1379.png', label: 'My RFQs'),
    _NavItem(pngPath: 'assets/images/icons/image_1376.png', label: 'Wallet'),
    _NavItem(pngPath: 'assets/images/icons/image_1382.png', label: 'Profile'),
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
                        // Icon — all PNG, tinted with ColorFiltered
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
                          child: Image.asset(item.pngPath, width: 24, height: 24),
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
  final String pngPath;
  final String label;
  const _NavItem({required this.pngPath, required this.label});
}
