import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          children: [
            // Back arrow
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
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color(0xFF6C7278), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() => searchQuery = v),
              style: GoogleFonts.roboto(
                  fontSize: 14, color: const Color(0xFF000000)),
              decoration: InputDecoration(
                hintText: 'Search Product...',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 14, color: const Color(0xFF9E9E9E)),
                border: InputBorder.none,
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
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.clear, color: Color(0xFF6C7278), size: 18),
              ),
            ),
        ],
      ),
    );
  }

  // ── Category tabs ──────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _categoryTab(ProductCategory.all),
          const SizedBox(width: 8),
          _categoryTab(ProductCategory.panel),
          const SizedBox(width: 8),
          _categoryTab(ProductCategory.battery),
        ],
      ),
    );
  }

  Widget _categoryTab(ProductCategory category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003D82) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003D82)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Text(
            category.displayName,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF6C7278),
            ),
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
