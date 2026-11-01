import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/products/domain/entities/product.dart';

class ProductListState {
  final ProductCategory category;
  final String query;

  const ProductListState({
    this.category = ProductCategory.all,
    this.query = '',
  });

  ProductListState copyWith({ProductCategory? category, String? query}) =>
      ProductListState(
        category: category ?? this.category,
        query: query ?? this.query,
      );
}

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit() : super(const ProductListState());

  void selectCategory(ProductCategory category) =>
      emit(state.copyWith(category: category));

  void updateQuery(String query) => emit(state.copyWith(query: query));
  void clearQuery() => emit(state.copyWith(query: ''));
}
