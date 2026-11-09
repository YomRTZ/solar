// Model for a catalog product category
class CatalogCategory {
  final String id;
  final String name;

  // Asset path for the category icon image
  final String iconPath;

  const CatalogCategory({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}
