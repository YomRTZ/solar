import 'package:flutter_app/features/products/data/datasources/product_assets.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';
import 'package:flutter_app/features/products/domain/repositories/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  InMemoryProductRepository({List<Product>? initialProducts})
    : _products = List<Product>.of(initialProducts ?? _seedProducts);

  final List<Product> _products;

  static final List<Product> _seedProducts = [
    for (var index = 1; index <= 5; index++)
      Product(
        id: '$index',
        title: 'Solar Trade',
        idNumber: '#MB1234${index + 4}',
        price: '11234',
        imagePath: ProductAssets.defaultImagePath,
        status: ProductStatus.inStock,
        category: ProductCategory.panel,
      ),
    Product(
      id: '6',
      title: 'Solar Battery 150Ah',
      idNumber: '#BAT001',
      price: '8500',
      imagePath: ProductAssets.defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.battery,
    ),
    Product(
      id: '7',
      title: 'Solar Battery 200Ah',
      idNumber: '#BAT002',
      price: '12000',
      imagePath: ProductAssets.defaultImagePath,
      status: ProductStatus.lowStock,
      category: ProductCategory.battery,
    ),
    Product(
      id: '8',
      title: 'Solar Inverter 5KW',
      idNumber: '#INV001',
      price: '15000',
      imagePath: ProductAssets.defaultImagePath,
      status: ProductStatus.inStock,
      category: ProductCategory.inverter,
    ),
    Product(
      id: '9',
      title: 'Solar Inverter 10KW',
      idNumber: '#INV002',
      price: '25000',
      imagePath: ProductAssets.defaultImagePath,
      status: ProductStatus.outOfStock,
      category: ProductCategory.inverter,
    ),
  ];

  @override
  List<Product> get products => List.unmodifiable(_products);

  @override
  void addProduct(Product product) => _products.insert(0, product);

  @override
  bool updateProduct(Product product) {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) return false;
    _products[index] = product;
    return true;
  }

  @override
  bool deleteProduct(String id) {
    final initialLength = _products.length;
    _products.removeWhere((product) => product.id == id);
    return _products.length != initialLength;
  }

  @override
  List<Product> getProductsByCategory(ProductCategory category) {
    if (category == ProductCategory.all) return products;
    return products.where((product) => product.category == category).toList();
  }

  @override
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return products;
    final normalizedQuery = query.toLowerCase();
    return products.where((product) {
      return product.title.toLowerCase().contains(normalizedQuery) ||
          product.idNumber.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  List<Product> getProductsByStatus(ProductStatus status) =>
      products.where((product) => product.status == status).toList();

  @override
  int get inStockCount => getProductsByStatus(ProductStatus.inStock).length;

  @override
  int get lowStockCount => getProductsByStatus(ProductStatus.lowStock).length;

  @override
  int get outOfStockCount =>
      getProductsByStatus(ProductStatus.outOfStock).length;
}
