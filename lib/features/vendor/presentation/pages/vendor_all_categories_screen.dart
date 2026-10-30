import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/vendor/presentation/widgets/vendor_category_card.dart';
import 'package:flutter_app/features/vendor/data/datasources/vendor_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Vendor All Categories Screen
// Shows:
//  • Dark-gradient header with back arrow + "All Categories" title
//  • Promo banner (matching Vendor home)
//  • 2-column grid of 152 × 141 VendorCategoryCard widgets
// ─────────────────────────────────────────────────────────────────────────────
class VendorAllCategoriesScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const VendorAllCategoriesScreen({super.key, this.onBackPressed});

  // All categories repeated twice to fill the grid (mimics the screenshot
  // which shows the same four categories listed multiple times).
  static final List<_CategoryEntry> _allEntries = [
    ...VendorData.categories.map((c) => _CategoryEntry(category: c)),
    ...VendorData.categories.map((c) => _CategoryEntry(category: c)),
  ];

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
            SecondAppHeader(
              title: 'All Categories',
              onBackPressed: onBackPressed ?? () => Navigator.maybePop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(21, 16, 21, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Promo banner ──────────────────────────
                    _buildBanner(context),
                    const SizedBox(height: 20),

                    // ── 2-column category grid ───────────────
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 12,
                            childAspectRatio: 152 / 141,
                          ),
                      itemCount: _allEntries.length,
                      itemBuilder: (context, i) {
                        final entry = _allEntries[i];
                        return VendorCategoryCard(
                          iconPath: entry.category.iconPath,
                          label: entry.category.name,
                          iconContainerSize: 68,
                          horizontalBordersOnly: true,
                          onTap: () =>
                              context.push(AppRoutes.vendorAllProducts),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Promo banner (same style as home) ─────────────────────
  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.vendorAllProducts),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Image.asset(
                'assets/solarimages/40e6eb83a0b81c11a222c2e30e9a248524bdf315.jpg',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) =>
                    Container(height: 120, color: const Color(0xFF003A8A)),
              ),
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Premium!',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Solar Panels',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'For a cleaner tomorrow',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple value holder — avoids using the raw model directly in the list
class _CategoryEntry {
  final dynamic category;
  const _CategoryEntry({required this.category});
}
