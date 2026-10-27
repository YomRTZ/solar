/// Product model class to store product data
class Product {
  final String id;
  final String title;
  final String idNumber;
  final String price;
  final String imagePath;
  final ProductStatus status;
  final ProductCategory category;

  Product({
    required this.id,
    required this.title,
    required this.idNumber,
    required this.price,
    required this.imagePath,
    required this.status,
    required this.category,
  });

  /// Check if product is in stock
  bool get isInStock => status == ProductStatus.inStock;

  /// Check if product is low stock
  bool get isLowStock => status == ProductStatus.lowStock;

  /// Check if product is out of stock
  bool get isOutOfStock => status == ProductStatus.outOfStock;
}

/// Product status enum
enum ProductStatus {
  inStock,
  lowStock,
  outOfStock,
}

/// Product category enum
enum ProductCategory {
  all,
  panel,
  battery,
  inverter,
}

/// Extension to get display name for category
extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.all:
        return 'All';
      case ProductCategory.panel:
        return 'Panel';
      case ProductCategory.battery:
        return 'Battery';
      case ProductCategory.inverter:
        return 'Inverter';
    }
  }
}

/// Extension to get display name for status
extension ProductStatusExtension on ProductStatus {
  String get displayName {
    switch (this) {
      case ProductStatus.inStock:
        return 'In Stock';
      case ProductStatus.lowStock:
        return 'Low Stock';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
    }
  }
}
