import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/catalog/presentation/widgets/catalog_category_card.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_data.dart';

class CatalogCategoriesScreen extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const CatalogCategoriesScreen({super.key, this.onBackPressed});

  // All categories repeated twice to fill the grid (mimics the screenshot which shows the same
  static final List<_CategoryEntry> _allEntries = [
    ...CatalogData.categories.map((c) => _CategoryEntry(category: c)),
    ...CatalogData.categories.map((c) => _CategoryEntry(category: c)),
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
                padding: const EdgeInsets.fromLTRB(15, 32, 12, 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBanner(context),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 4, 0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 19,
                              mainAxisSpacing: 19,
                              mainAxisExtent: 141,
                            ),
                        itemCount: _allEntries.length,
                        itemBuilder: (context, i) {
                          final entry = _allEntries[i];
                          return Center(
                            child: SizedBox(
                              width: 152,
                              height: 141,
                              child: CatalogCategoryCard(
                                iconPath: entry.category.iconPath,
                                label: entry.category.name,
                                width: 152,
                                height: 141,
                                imageWidth: 124,
                                imageHeight: 94,
                                iconContainerSize: 68,
                                onTap: () =>
                                    context.push(AppRoutes.vendorAllProducts),
                              ),
                            ),
                          );
                        },
                      ),
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

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.vendorAllProducts),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: double.infinity,
          height: 104,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/solarimages/solar_panel_field_photo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0, 0.7616],
                      colors: [Color(0xB3003A8A), Color(0xB3000F24)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 17,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 9),
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
                    const SizedBox(height: 18),
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
      ),
    );
  }
}

// Simple value holder — avoids using the raw model directly in the list
class _CategoryEntry {
  final dynamic category;
  const _CategoryEntry({required this.category});
}
