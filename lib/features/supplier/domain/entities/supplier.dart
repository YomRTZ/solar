import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// Supplier details shown in the vendor product-browsing flow.
class Supplier {
  final String id;
  final String name;
  final String badge; // e.g. "Verified Seller"
  final double rating;
  final int totalOrders;
  final String aboutText;
  final String iconPath; // avatar / logo asset
  final List<CatalogProduct> mainProducts;

  const Supplier({
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
