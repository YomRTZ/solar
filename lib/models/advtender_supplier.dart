import 'catalog_product.dart';

/// Supplier model used in the advtender Supplier Details screen.
class AdvTenderSupplier {
  final String id;
  final String name;
  final String badge;        // e.g. "Verified Seller"
  final double rating;
  final int totalOrders;
  final String aboutText;
  final String iconPath;     // avatar / logo asset
  final List<CatalogProduct> mainProducts;

  const AdvTenderSupplier({
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
