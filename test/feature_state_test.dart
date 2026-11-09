import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:flutter_app/features/dashboard/presentation/cubit/marketplace_navigation_cubit.dart';
import 'package:flutter_app/features/shopping/presentation/cubit/checkout_cubit.dart';
import 'package:flutter_app/features/shopping/presentation/cubit/shopping_cart_cubit.dart';

void main() {
  test('marketplace navigation stores the selected tab', () async {
    final cubit = MarketplaceNavigationCubit();
    cubit.selectTab(3);

    expect(cubit.state.selectedTab, 3);
    await cubit.close();
  });

  test('shopping cart updates quantities and removes empty items', () async {
    const product = CatalogProduct(
      id: 'panel-1',
      name: 'Solar Panel',
      subtitle: 'By Supplier',
      price: '1000',
      imagePath: '',
    );
    final cubit = ShoppingCartCubit(
      items: const [product],
      initialQuantities: const {'panel-1': 1},
    );

    cubit.increment(product.id);
    expect(cubit.state.quantities[product.id], 2);
    cubit.decrement(product.id);
    cubit.decrement(product.id);
    expect(cubit.state.items, isEmpty);
    expect(cubit.state.count, 0);
    await cubit.close();
  });

  test('checkout keeps form updates in checkout state', () async {
    final cubit = CheckoutCubit();
    cubit.selectPaymentMethod(PaymentMethod.klarna);
    cubit.selectCountry('United States');
    cubit.updateCardNumber('4111111111111111');

    expect(cubit.state.paymentMethod, PaymentMethod.klarna);
    expect(cubit.state.country, 'United States');
    expect(cubit.state.cardNumber, '4111111111111111');
    await cubit.close();
  });
}
