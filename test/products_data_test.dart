import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/products/data/datasources/product_assets.dart';
import 'package:flutter_app/features/products/data/repositories/in_memory_product_repository.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';

void main() {
  test('created and edited products appear in product queries', () {
    const productId = 'crud-test-product';
    final repository = InMemoryProductRepository(initialProducts: const []);
    repository.addProduct(
      Product(
        id: productId,
        title: 'Test Controller',
        idNumber: '#TEST001',
        price: '1250',
        imagePath: ProductAssets.defaultImagePath,
        status: ProductStatus.inStock,
        category: ProductCategory.controller,
      ),
    );

    expect(
      repository.getProductsByCategory(ProductCategory.controller).single.title,
      'Test Controller',
    );

    final updatedProduct = Product(
      id: productId,
      title: 'Updated Controller',
      idNumber: '#TEST001',
      price: '1500',
      imagePath: ProductAssets.defaultImagePath,
      status: ProductStatus.lowStock,
      category: ProductCategory.controller,
    );

    expect(repository.updateProduct(updatedProduct), isTrue);
    expect(
      repository.searchProducts('Updated Controller').single.price,
      '1500',
    );
    expect(repository.deleteProduct(productId), isTrue);
    expect(
      repository.products.any((product) => product.id == productId),
      isFalse,
    );
  });
}
