import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_product_card.dart';
import 'package:flutter_app/features/dashboard/data/datasources/dashboard_data.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';
import 'package:flutter_app/features/orders/presentation/pages/orders_screen.dart';
import 'package:flutter_app/features/products/presentation/pages/my_products_screen.dart';
import 'package:flutter_app/features/profile/presentation/pages/vendor_profile_screen.dart';
import 'package:flutter_app/features/rfq/presentation/pages/rfq_requests_screen.dart';
import 'package:flutter_app/features/dashboard/presentation/cubit/dashboard_navigation_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Supplier dashboard shell — bottom-nav host for the supplier-side app ──
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardNavigationCubit _navigationCubit = DashboardNavigationCubit();

  @override
  void dispose() {
    _navigationCubit.close();
    super.dispose();
  }

  Widget _bodyForIndex(int index) {
    switch (index) {
      case 0:
        return _DashboardBody(onTabChange: _navigationCubit.selectTab);
      case 1:
        return MyProductsScreen(
          onBackPressed: () => _navigationCubit.selectTab(0),
        );
      case 2:
        return RFQRequestsScreen(
          onBackPressed: () => _navigationCubit.selectTab(0),
        );
      case 3:
        return OrdersScreen(onBackPressed: () => _navigationCubit.selectTab(0));
      case 4:
        return VendorProfileScreen(
          onBackPressed: () => _navigationCubit.selectTab(0),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardNavigationCubit, DashboardNavigationState>(
      bloc: _navigationCubit,
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
          extendBodyBehindAppBar: true,
          body: _bodyForIndex(state.selectedTab),
          bottomNavigationBar: _DashboardNavBar(
            currentIndex: state.selectedTab,
            onTap: _navigationCubit.selectTab,
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final void Function(int) onTabChange;
  const _DashboardBody({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatsGrid(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 15, 18),
                  child: AppContinueButton(
                    text: 'Create New Product',
                    showArrow: false,
                    onPressed: () => context.push(AppRoutes.addProduct),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 0, 7),
                  child: Text(
                    'Recent RFQs',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF202020),
                      height: 20 / 16,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
                ...DashboardData.recentRFQs.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      entry.key == 0 ? 7 : 0,
                      13,
                      12,
                    ),
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
                      onTap: () =>
                          context.push(AppRoutes.rfqDetail, extra: entry.value),
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
          Positioned(
            top: top + 51,
            left: 148,
            right: 148,
            bottom: 11,
            child: Image.asset(
              'assets/images/solartradeshub_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.wb_sunny_rounded,
                color: Colors.amber,
                size: 48,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 22,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/icons/ic_notification.png',
                  width: 28,
                  height: 28,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
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

  Widget _buildStatsGrid(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 26, 10, 17),
      child: Column(
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
          const SizedBox(height: 20),
          Row(
            children: [
              _StatCard(
                label: 'Orders',
                value: DashboardData.orders.toString(),
              ),
              const SizedBox(width: 11),
              _StatCard(
                label: 'My Balance',
                value: DashboardData.myBalance.toStringAsFixed(0),
                onTap: () => context.push(AppRoutes.wallet),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  const _StatCard({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}

class _DashboardNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DashboardNavBar({required this.currentIndex, required this.onTap});

  static const List<_NavItem> _items = [
    _NavItem(
      assetPath: 'assets/icons/ic_nav_home.svg',
      label: 'Home',
      isSvg: true,
    ),
    _NavItem(assetPath: 'assets/icons/ic_nav_products.png', label: 'Products'),
    _NavItem(assetPath: 'assets/icons/ic_nav_rfqs.png', label: 'RFQs'),
    _NavItem(assetPath: 'assets/icons/ic_nav_orders.png', label: 'Orders'),
    _NavItem(assetPath: 'assets/icons/ic_nav_profile.png', label: 'Profile'),
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
                final color = isActive
                    ? const Color(0xFF003A8A)
                    : const Color(0xFF6C7278);

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
                              BlendMode.srcATop,
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
  final String assetPath;
  final String label;
  final bool isSvg;
  const _NavItem({
    required this.assetPath,
    required this.label,
    this.isSvg = false,
  });
}
