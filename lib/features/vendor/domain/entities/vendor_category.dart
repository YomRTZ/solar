// Model for a vendor product category
class VendorCategory {
  final String id;
  final String name;

  // Asset path for the category icon image
  final String iconPath;

  const VendorCategory({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}
