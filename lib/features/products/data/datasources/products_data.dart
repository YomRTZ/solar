import 'package:flutter_app/features/products/domain/entities/product.dart';

// Sample products data
class ProductsData {
  static const defaultImagePath =
      'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png';

  static final List<Product> _products = [
    Product(
      id: '1',
      title: 'Solar Trade',
      idNumber: '#MB12345',
      price: '11234',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.panel,
    ),
    Product(
      id: '2',
      title: 'Solar Trade',
      idNumber: '#MB12346',
      price: '11234',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.panel,
    ),
    Product(
      id: '3',
      title: 'Solar Trade',
      idNumber: '#MB12347',
      price: '11234',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.panel,
    ),
    Product(
      id: '4',
      title: 'Solar Trade',
      idNumber: '#MB12348',
      price: '11234',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.panel,
    ),
    Product(
      id: '5',
      title: 'Solar Trade',
      idNumber: '#MB12349',
      price: '11234',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.panel,
    ),
    Product(
      id: '6',
      title: 'Solar Battery 150Ah',
      idNumber: '#BAT001',
      price: '8500',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.battery,
    ),
    Product(
      id: '7',
      title: 'Solar Battery 200Ah',
      idNumber: '#BAT002',
      price: '12000',
      imagePath: defaultImagePath,
      status: ProductStatus.lowStock,
      category: ProductCategory.battery,
    ),
    Product(
      id: '8',
      title: 'Solar Inverter 5KW',
      idNumber: '#INV001',
      price: '15000',
      imagePath: defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.inverter,
    ),
    Product(
      id: '9',
      title: 'Solar Inverter 10KW',
      idNumber: '#INV002',
      price: '25000',
      imagePath: defaultImagePath,
      status: ProductStatus.outOfStock,
      category: ProductCategory.inverter,
    ),
  ];

  static List<Product> get products => List.unmodifiable(_products);

  static void addProduct(Product product) {
    _products.insert(0, product);
  }

  static bool updateProduct(Product product) {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) return false;
    _products[index] = product;
    return true;
  }

  static bool deleteProduct(String id) {
    final initialLength = _products.length;
    _products.removeWhere((product) => product.id == id);
    return _products.length != initialLength;
  }

  // Get products by category
  static List<Product> getProductsByCategory(ProductCategory category) {
    if (category == ProductCategory.all) {
      return products;
    }
    return products.where((product) => product.category == category).toList();
  }

  // Search products by title or ID
  static List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return products;
    }

    final lowerQuery = query.toLowerCase();
    return products.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.idNumber.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get products by status
  static List<Product> getProductsByStatus(ProductStatus status) {
    return products.where((product) => product.status == status).toList();
  }

  // Get in stock products count
  static int get inStockCount =>
      products.where((p) => p.status == ProductStatus.inStock).length;

  // Get low stock products count
  static int get lowStockCount =>
      products.where((p) => p.status == ProductStatus.lowStock).length;

  // Get out of stock products count
  static int get outOfStockCount =>
      products.where((p) => p.status == ProductStatus.outOfStock).length;
}
