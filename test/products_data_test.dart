import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/products/data/datasources/products_data.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';

void main() {
  const productId = 'crud-test-product';

  tearDown(() {
    ProductsData.deleteProduct(productId);
  });

  test('created and edited products appear in product queries', () {
    ProductsData.addProduct(
      Product(
        id: productId,
        title: 'Test Controller',
        idNumber: '#TEST001',
        price: '1250',
        imagePath: ProductsData.defaultImagePath,
        status: ProductStatus.inStock,
        category: ProductCategory.controller,
      ),
    );

    expect(
      ProductsData.getProductsByCategory(
        ProductCategory.controller,
      ).single.title,
      'Test Controller',
    );

    final updatedProduct = Product(
      id: productId,
      title: 'Updated Controller',
      idNumber: '#TEST001',
      price: '1500',
      imagePath: ProductsData.defaultImagePath,
      status: ProductStatus.lowStock,
      category: ProductCategory.controller,
    );

    expect(ProductsData.updateProduct(updatedProduct), isTrue);
    expect(
      ProductsData.searchProducts('Updated Controller').single.price,
      '1500',
    );
    expect(ProductsData.deleteProduct(productId), isTrue);
    expect(
      ProductsData.products.any((product) => product.id == productId),
      isFalse,
    );
  });
}
