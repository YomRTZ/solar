import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/features/catalog/presentation/pages/catalog_browse_screen.dart';
import 'package:flutter_app/features/catalog/presentation/pages/catalog_categories_screen.dart';
import 'package:flutter_app/features/shopping/presentation/pages/shopping_rfq_list_screen.dart';
import 'package:flutter_app/features/orders/presentation/pages/orders_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/supplier_profile_screen.dart';
import 'package:flutter_app/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:flutter_app/features/dashboard/presentation/cubit/marketplace_navigation_cubit.dart';
import 'package:flutter_app/features/shopping/presentation/cubit/shopping_rfq_list_cubit.dart';

class MarketplaceScreen extends StatelessWidget {
  final int initialIndex;

  const MarketplaceScreen({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MarketplaceNavigationCubit>(
          create: (_) => MarketplaceNavigationCubit(initialTab: initialIndex),
        ),
        BlocProvider<CatalogCubit>(create: (_) => CatalogCubit()),
        BlocProvider<RfqRequestListCubit>(create: (_) => RfqRequestListCubit()),
      ],
      child: const _MarketplaceBody(),
    );
  }
}

class _MarketplaceBody extends StatelessWidget {
  const _MarketplaceBody();

  List<Widget> _pages(BuildContext context) => [
    const CatalogBrowseScreen(),
    CatalogCategoriesScreen(),
    ShoppingRfqListScreen(),
    const OrdersScreen(showBackButton: false, isVendor: true),
    SupplierProfileScreen(
      onBackPressed: () =>
          context.read<MarketplaceNavigationCubit>().selectTab(0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceNavigationCubit, MarketplaceNavigationState>(
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
          body: IndexedStack(
            index: navState.selectedTab,
            children: _pages(context),
          ),
          bottomNavigationBar: _MarketplaceNavBar(
            currentIndex: navState.selectedTab,
            onTap: context.read<MarketplaceNavigationCubit>().selectTab,
          ),
        ),
      ),
    );
  }
}

class _MarketplaceNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MarketplaceNavBar({required this.currentIndex, required this.onTap});

  static const List<_NavItem> _items = [
    _NavItem(
      assetPath: 'assets/icons/ic_nav_home.svg',
      label: 'Home',
      isSvg: true,
    ),
    _NavItem(
      assetPath: 'assets/icons/ic_nav_categories.png',
      label: 'Categories',
    ),
    _NavItem(assetPath: 'assets/icons/ic_nav_cart.png', label: 'My RFQs'),
    _NavItem(
      assetPath: 'assets/icons/ic_marketplace_orders.png',
      label: 'Orders',
    ),
    _NavItem(
      assetPath: 'assets/icons/ic_supplier_account.png',
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
