import 'package:flutter_bloc/flutter_bloc.dart';

class CatalogState {
  final String query;
  final Map<String, int> rfqQuantities;

  const CatalogState({this.query = '', this.rfqQuantities = const {}});

  int get cartCount =>
      rfqQuantities.values.fold(0, (total, quantity) => total + quantity);

  CatalogState copyWith({String? query, Map<String, int>? rfqQuantities}) =>
      CatalogState(
        query: query ?? this.query,
        rfqQuantities: rfqQuantities ?? this.rfqQuantities,
      );
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit() : super(const CatalogState());

  void updateQuery(String value) => emit(state.copyWith(query: value));

  void increment(String productId) {
    final quantities = Map<String, int>.of(state.rfqQuantities);
    quantities[productId] = (quantities[productId] ?? 0) + 1;
    emit(state.copyWith(rfqQuantities: Map.unmodifiable(quantities)));
  }

  void decrement(String productId) {
    final quantities = Map<String, int>.of(state.rfqQuantities);
    final quantity = quantities[productId] ?? 0;
    if (quantity <= 1) {
      quantities.remove(productId);
    } else {
      quantities[productId] = quantity - 1;
    }
    emit(state.copyWith(rfqQuantities: Map.unmodifiable(quantities)));
  }
}
