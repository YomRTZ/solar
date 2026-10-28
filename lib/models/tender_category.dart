/// Model for a tender product category
class TenderCategory {
  final String id;
  final String name;

  /// Asset path for the category icon image
  final String iconPath;

  const TenderCategory({
    required this.id,
    required this.name,
    required this.iconPath,
  });
}
