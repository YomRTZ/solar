import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

class ShoppingCartState {
  final List<CatalogProduct> items;
  final Map<String, int> quantities;

  const ShoppingCartState({this.items = const [], this.quantities = const {}});

  int get count =>
      quantities.values.fold(0, (total, quantity) => total + quantity);

  ShoppingCartState copyWith({
    List<CatalogProduct>? items,
    Map<String, int>? quantities,
  }) => ShoppingCartState(
    items: items ?? this.items,
    quantities: quantities ?? this.quantities,
  );
}

class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  ShoppingCartCubit({
    required List<CatalogProduct> items,
    required Map<String, int> initialQuantities,
  }) : super(
         ShoppingCartState(
           items: List.unmodifiable(items),
           quantities: Map.unmodifiable(initialQuantities),
         ),
       );

  void increment(String id) {
    final quantities = Map<String, int>.of(state.quantities);
    quantities[id] = (quantities[id] ?? 1) + 1;
    emit(state.copyWith(quantities: Map.unmodifiable(quantities)));
  }

  void decrement(String id) {
    final quantities = Map<String, int>.of(state.quantities);
    final current = quantities[id] ?? 1;
    if (current <= 1) {
      quantities.remove(id);
      emit(
        state.copyWith(
          items: List.unmodifiable(
            state.items.where((product) => product.id != id),
          ),
          quantities: Map.unmodifiable(quantities),
        ),
      );
    } else {
      quantities[id] = current - 1;
      emit(state.copyWith(quantities: Map.unmodifiable(quantities)));
    }
  }
}
