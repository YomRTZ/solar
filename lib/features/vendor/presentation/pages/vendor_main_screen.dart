import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/features/vendor/presentation/pages/vendor_home_screen.dart';
import 'package:flutter_app/features/vendor/presentation/pages/vendor_all_categories_screen.dart';
import 'package:flutter_app/features/vendor/presentation/pages/vendor_rfq_requests_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/orders_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/supplier_profile_screen.dart';
import 'package:flutter_app/features/vendor/presentation/cubit/vendor_cubit.dart';

// ───────────────────────────────────────────────────────────────────────────
class VendorMainScreen extends StatelessWidget {
  final int initialIndex;

  const VendorMainScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    // Provide the shared cubits at this level so every tab can access them
    // via context.read<>() without prop-drilling.
    return MultiBlocProvider(
      providers: [
        // VendorNavigationCubit: which tab is active
        BlocProvider<VendorNavigationCubit>(
          create: (_) => VendorNavigationCubit(initialTab: initialIndex),
        ),
        // VendorCatalogCubit: shared cart + search between Home & AllProducts
        BlocProvider<VendorCatalogCubit>(create: (_) => VendorCatalogCubit()),
        // VendorRequestListCubit: filter on the RFQ requests tab
        BlocProvider<VendorRequestListCubit>(
          create: (_) => VendorRequestListCubit(),
        ),
      ],
      child: const _VendorMainBody(),
    );
  }
}

// ── Inner stateless body — reads cubits from context ─────────────────────
class _VendorMainBody extends StatelessWidget {
  const _VendorMainBody();

  List<Widget> _pages(BuildContext context) => [
    const VendorHomeScreen(),
    VendorAllCategoriesScreen(
      onBackPressed: null, // handled by nav cubit tap below
    ),
    const VendorRfqRequestsScreen(),
    const OrdersScreen(showBackButton: false),
    SupplierProfileScreen(
      onBackPressed: () => context.read<VendorNavigationCubit>().selectTab(0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorNavigationCubit, VendorNavigationState>(
      builder: (context, navState) => AnnotatedRegion<SystemUiOverlayStyle>(
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
          body: IndexedStack(
            index: navState.selectedTab,
            children: _pages(context),
          ),
          bottomNavigationBar: _VendorNavBar(
            currentIndex: navState.selectedTab,
            onTap: context.read<VendorNavigationCubit>().selectTab,
          ),
        ),
      ),
    );
  }
}

// ── Bottom nav bar ────────────────────────────────────────────────────────
class _VendorNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _VendorNavBar({required this.currentIndex, required this.onTap});

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
