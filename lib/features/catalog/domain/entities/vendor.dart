import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// Vendor details shown in the catalog product-browsing flow.
class Vendor {
  final String id;
  final String name;
  final String badge; // e.g. "Verified Seller"
  final double rating;
  final int totalOrders;
  final String aboutText;
  final String iconPath; // avatar / logo asset
  final List<CatalogProduct> mainProducts;

  const Vendor({
    required this.id,
    required this.name,
    required this.badge,
    required this.rating,
    required this.totalOrders,
    required this.aboutText,
    required this.iconPath,
    required this.mainProducts,
  });
}
