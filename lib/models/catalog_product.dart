/// Catalog / Tender product model
class CatalogProduct {
  final String id;
  final String name;
  final String subtitle;
  final String price;
  final String imagePath;

  // ── Extended fields used in the tender detail sheet ────────
  final String modelNumber;
  final String category;
  final String warranty;
  final String dispatchDist;
  final String power;
  final bool inStock;
  final String brandName;

  const CatalogProduct({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imagePath,
    this.modelNumber = 'MB12345',
    this.category = 'Panel 09/2026',
    this.warranty = '09/2026',
    this.dispatchDist = 'New Delhi',
    this.power = '12W',
    this.inStock = true,
    this.brandName = 'Brand Name',
  });
}
