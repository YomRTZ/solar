/// Catalog product model used in the All Products grid screen
class CatalogProduct {
  final String id;
  final String name;
  final String subtitle;
  final String price;
  final String imagePath;

  const CatalogProduct({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imagePath,
  });
}
