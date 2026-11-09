import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// Catalog browsing state
class CatalogState {
  final String query;
  final Map<String, int> cartQuantities;
  final List<CatalogProduct> comparedProducts;

  const CatalogState({
    this.query = '',
    this.cartQuantities = const {},
    this.comparedProducts = const [],
  });

  int get cartCount =>
      cartQuantities.values.fold(0, (total, quantity) => total + quantity);

  CatalogState copyWith({
    String? query,
    Map<String, int>? cartQuantities,
    List<CatalogProduct>? comparedProducts,
  }) => CatalogState(
    query: query ?? this.query,
    cartQuantities: cartQuantities ?? this.cartQuantities,
    comparedProducts: comparedProducts ?? this.comparedProducts,
  );
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit() : super(const CatalogState());

  void updateQuery(String query) => emit(state.copyWith(query: query));

  void increment(String id) {
    final cart = Map<String, int>.of(state.cartQuantities);
    cart[id] = (cart[id] ?? 0) + 1;
    emit(state.copyWith(cartQuantities: Map.unmodifiable(cart)));
  }

  void ensureOne(String id) {
    if ((state.cartQuantities[id] ?? 0) == 0) increment(id);
  }

  void decrement(String id) {
    final cart = Map<String, int>.of(state.cartQuantities);
    final current = cart[id] ?? 0;
    if (current <= 1) {
      cart.remove(id);
    } else {
      cart[id] = current - 1;
    }
    emit(state.copyWith(cartQuantities: Map.unmodifiable(cart)));
  }

  void addToCompare(CatalogProduct product, {int limit = 2}) {
    final products = List<CatalogProduct>.of(state.comparedProducts);
    if (products.any((item) => item.id == product.id)) return;
    if (products.length >= limit) products.removeAt(0);
    products.add(product);
    emit(state.copyWith(comparedProducts: List.unmodifiable(products)));
  }
}
