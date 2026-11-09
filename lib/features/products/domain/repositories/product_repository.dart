import 'package:flutter_app/features/products/domain/entities/product.dart';

abstract interface class ProductRepository {
  List<Product> get products;

  List<Product> getProductsByCategory(ProductCategory category);
  List<Product> searchProducts(String query);
  List<Product> getProductsByStatus(ProductStatus status);

  int get inStockCount;
  int get lowStockCount;
  int get outOfStockCount;

  void addProduct(Product product);
  bool updateProduct(Product product);
  bool deleteProduct(String id);
}
