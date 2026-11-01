import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_expandable_card.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';
import 'package:flutter_app/features/products/data/datasources/products_data.dart';
import 'package:flutter_app/features/products/presentation/cubit/product_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProductsScreen extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const MyProductsScreen({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final ProductListCubit _productListCubit = ProductListCubit();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    _productListCubit.close();
    super.dispose();
  }

  List<Product> get filteredProducts {
    List<Product> products = ProductsData.getProductsByCategory(
      _productListCubit.state.category,
    );
    if (_productListCubit.state.query.isNotEmpty) {
      final q = _productListCubit.state.query.toLowerCase();
      products = products
          .where(
            (p) =>
                p.title.toLowerCase().contains(q) ||
                p.idNumber.toLowerCase().contains(q),
          )
          .toList();
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      bloc: _productListCubit,
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
          body: Column(
            children: [
              // ── SecondAppHeader ──────────────────────────────
              SecondAppHeader(
                title: 'My Products',
                showBackButton: widget.showBackButton,
                onBackPressed:
                    widget.onBackPressed ??
                    () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
              ),

              // ── Search Bar ───────────────────────────────────
              _buildSearchBar(),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 18, right: 15),
                  child: Column(
                    children: [
                      _buildCategoryTabs(),
                      Expanded(
                        child: filteredProducts.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return _buildProductCard(
                                    filteredProducts[index],
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
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 46,
      margin: const EdgeInsets.fromLTRB(16, 21, 17, 0),
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
          SvgPicture.asset('assets/icons/search.svg', width: 24, height: 24),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: _productListCubit.updateQuery,
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
          if (_productListCubit.state.query.isNotEmpty)
            GestureDetector(
              onTap: () {
                searchController.clear();
                _productListCubit.clearQuery();
              },
              child: const Icon(
                Icons.clear,
                color: Color(0xFF6C7278),
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  // ── Category tabs ──────────────────────────────────────────
  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 14, 0, 11),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _categoryTab(ProductCategory.all),
            const SizedBox(width: 12.85),
            _categoryTab(ProductCategory.panel),
            const SizedBox(width: 12.85),
            _categoryTab(ProductCategory.battery),
          ],
        ),
      ),
    );
  }

  Widget _categoryTab(ProductCategory category) {
    final isSelected = _productListCubit.state.category == category;
    return GestureDetector(
      onTap: () => _productListCubit.selectCategory(category),
      child: Container(
        width: 72.43,
        height: 27,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003A8A) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF003A8A), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          category.displayName,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF003A8A),
            height: 18 / 12, // line-height: 18px
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
          onTap: () => _editProduct(product),
        );
      case ProductStatus.lowStock:
        return AppExpandableCard.lowStock(
          imagePath: product.imagePath,
          title: product.title,
          idNumber: product.idNumber,
          price: product.price,
          onTap: () => _editProduct(product),
        );
      case ProductStatus.outOfStock:
        return AppExpandableCard.outOfStock(
          imagePath: product.imagePath,
          title: product.title,
          idNumber: product.idNumber,
          price: product.price,
          onTap: () => _editProduct(product),
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
            style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // ── Edit product ──────────────────────────────────────────
  void _editProduct(Product product) {
    context.push<bool>(AppRoutes.editProduct, extra: product).then((changed) {
      if (changed == true && mounted) setState(() {});
    });
  }
}
