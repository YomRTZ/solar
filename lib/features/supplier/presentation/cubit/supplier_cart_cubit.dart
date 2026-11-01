import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierCartState {
  final Map<String, int> quantities;

  const SupplierCartState({this.quantities = const {}});

  int get count =>
      quantities.values.fold(0, (total, quantity) => total + quantity);

  SupplierCartState copyWith({Map<String, int>? quantities}) =>
      SupplierCartState(quantities: quantities ?? this.quantities);
}

class SupplierCartCubit extends Cubit<SupplierCartState> {
  SupplierCartCubit() : super(const SupplierCartState());

  void increment(String id) {
    final quantities = Map<String, int>.of(state.quantities);
    quantities[id] = (quantities[id] ?? 0) + 1;
    emit(state.copyWith(quantities: Map.unmodifiable(quantities)));
  }

  void decrement(String id) {
    final quantities = Map<String, int>.of(state.quantities);
    final current = quantities[id] ?? 0;
    if (current <= 1) {
      quantities.remove(id);
    } else {
      quantities[id] = current - 1;
    }
    emit(state.copyWith(quantities: Map.unmodifiable(quantities)));
  }
}
