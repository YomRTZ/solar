import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_expandable_card.dart';
import '../../models/product.dart';
import '../../data/products_data.dart';

class MyProductsScreen extends StatefulWidget {
  final bool showBackButton;
  const MyProductsScreen({super.key, this.showBackButton = false});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  ProductCategory selectedCategory = ProductCategory.all;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Product> get filteredProducts {
    List<Product> products =
        ProductsData.getProductsByCategory(selectedCategory);
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      products = products
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.idNumber.toLowerCase().contains(q))
          .toList();
    }
    return products;
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
        body: Column(
          children: [
            // ── Reusable AppHeader — same size as HomeScreen ─
            _buildPageHeader(context),

            // ── Search Bar ───────────────────────────────────
            _buildSearchBar(),
            const SizedBox(height: 12),

            // ── Category Tabs ────────────────────────────────
            _buildCategoryTabs(),
            const SizedBox(height: 12),

            // ── Products List ────────────────────────────────
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(filteredProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header — same height as HomeScreen (statusBarH + 133) ──
  Widget _buildPageHeader(BuildContext context) {
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Arrow + Title in a Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'My Products',
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      width: 327,
      height: 46,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDF1F3), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3DE4E5E7),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/icons/search.svg',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() => searchQuery = v),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1C1E),
                height: 1.4,
                letterSpacing: -0.14,
              ),
              decoration: InputDecoration(
                hintText: 'Search Product...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1C1E),
                  height: 1.4,
                  letterSpacing: -0.14,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() {
                searchController.clear();
                searchQuery = '';
              }),
              child: const Icon(Icons.clear, color: Color(0xFF6C7278), size: 18),
            ),
        ],
      ),
    );
  }

  // ── Category tabs ──────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _categoryTab(ProductCategory.all),
            const SizedBox(width: 12.85),
            _categoryTab(ProductCategory.panel),
            const SizedBox(width: 12.86),
            _categoryTab(ProductCategory.battery),
          ],
        ),
      ),
    );
  }

  Widget _categoryTab(ProductCategory category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
      child: Container(
        width: 72.43,
        height: 27,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003A8A) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFF003A8A),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          category.displayName,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF003A8A),
            height: 18 / 12,        // line-height: 18px
            letterSpacing: -0.14,
          ),
        ),
      ),
    );
  }

  // ── Product card ───────────────────────────────────────────
  Widget _buildProductCard(Product product) {
    switch (product.status) {
      case ProductStatus.inStock:
        return AppExpandableCard.inStock(
          imagePath: product.imagePath,
          title: product.title,
          idNumber: product.idNumber,
          price: product.price,
          onTap: () => _viewProductDetails(product),
        );
      case ProductStatus.lowStock:
        return AppExpandableCard.lowStock(
          imagePath: product.imagePath,
          title: product.title,
          idNumber: product.idNumber,
          price: product.price,
          onTap: () => _viewProductDetails(product),
        );
      case ProductStatus.outOfStock:
        return AppExpandableCard.outOfStock(
          imagePath: product.imagePath,
          title: product.title,
          idNumber: product.idNumber,
          price: product.price,
          onTap: () => _viewProductDetails(product),
        );
    }
  }

  // ── Empty state ────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.roboto(
                fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // ── Product details ────────────────────────────────────────
  void _viewProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${product.idNumber}'),
            const SizedBox(height: 4),
            Text('Price: Rs. ${product.price}'),
            const SizedBox(height: 4),
            Text('Category: ${product.category.displayName}'),
            const SizedBox(height: 4),
            Text('Status: ${product.status.displayName}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
