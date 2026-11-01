import 'package:flutter_bloc/flutter_bloc.dart';

class ProductEditorState {
  final String productName;
  final String modelNumber;
  final String price;
  final String taxAmount;
  final String minimumOrderQuantity;
  final String warranty;
  final String dispatchDistrict;
  final String? category;
  final String? brand;
  final String? stock;
  final List<String> imagePaths;
  final bool isLoading;
  final bool showSuccessBanner;
  final bool isUpdated;

  const ProductEditorState({
    this.productName = '',
    this.modelNumber = '',
    this.price = '',
    this.taxAmount = '',
    this.minimumOrderQuantity = '',
    this.warranty = '',
    this.dispatchDistrict = '',
    this.category,
    this.brand,
    this.stock,
    this.imagePaths = const [
      'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
    ],
    this.isLoading = false,
    this.showSuccessBanner = false,
    this.isUpdated = false,
  });

  ProductEditorState copyWith({
    String? productName,
    String? modelNumber,
    String? price,
    String? taxAmount,
    String? minimumOrderQuantity,
    String? warranty,
    String? dispatchDistrict,
    String? category,
    String? brand,
    String? stock,
    List<String>? imagePaths,
    bool? isLoading,
    bool? showSuccessBanner,
    bool? isUpdated,
  }) => ProductEditorState(
    productName: productName ?? this.productName,
    modelNumber: modelNumber ?? this.modelNumber,
    price: price ?? this.price,
    taxAmount: taxAmount ?? this.taxAmount,
    minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
    warranty: warranty ?? this.warranty,
    dispatchDistrict: dispatchDistrict ?? this.dispatchDistrict,
    category: category ?? this.category,
    brand: brand ?? this.brand,
    stock: stock ?? this.stock,
    imagePaths: imagePaths ?? this.imagePaths,
    isLoading: isLoading ?? this.isLoading,
    showSuccessBanner: showSuccessBanner ?? this.showSuccessBanner,
    isUpdated: isUpdated ?? this.isUpdated,
  );
}

class ProductEditorCubit extends Cubit<ProductEditorState> {
  ProductEditorCubit({
    ProductEditorState initialState = const ProductEditorState(),
  }) : super(initialState);

  void updateProductName(String value) => emit(
    state.copyWith(
      productName: value,
      isUpdated: false,
      showSuccessBanner: false,
    ),
  );
  void updateModelNumber(String value) => emit(
    state.copyWith(
      modelNumber: value,
      isUpdated: false,
      showSuccessBanner: false,
    ),
  );
  void updatePrice(String value) => emit(
    state.copyWith(price: value, isUpdated: false, showSuccessBanner: false),
  );
  void updateTaxAmount(String value) => emit(
    state.copyWith(
      taxAmount: value,
      isUpdated: false,
      showSuccessBanner: false,
    ),
  );
  void updateMinimumOrderQuantity(String value) => emit(
    state.copyWith(
      minimumOrderQuantity: value,
      isUpdated: false,
      showSuccessBanner: false,
    ),
  );
  void updateWarranty(String value) => emit(
    state.copyWith(warranty: value, isUpdated: false, showSuccessBanner: false),
  );
  void updateDispatchDistrict(String value) => emit(
    state.copyWith(
      dispatchDistrict: value,
      isUpdated: false,
      showSuccessBanner: false,
    ),
  );
  void selectCategory(String? value) => emit(
    state.copyWith(category: value, isUpdated: false, showSuccessBanner: false),
  );
  void selectBrand(String? value) => emit(
    state.copyWith(brand: value, isUpdated: false, showSuccessBanner: false),
  );
  void selectStock(String? value) => emit(
    state.copyWith(stock: value, isUpdated: false, showSuccessBanner: false),
  );
  void setLoading(bool value) => emit(state.copyWith(isLoading: value));
  void setSuccessBanner(bool value) =>
      emit(state.copyWith(showSuccessBanner: value));

  /// Marks the product as updated — changes button from "Update" to "Continue".
  void markUpdated() => emit(state.copyWith(isUpdated: true));

  void addImage(String path) => emit(
    state.copyWith(
      imagePaths: List.unmodifiable([...state.imagePaths, path]),
      isUpdated: false,
      showSuccessBanner: false,
    ),
  );

  void removeImage(int index) {
    if (index < 0 || index >= state.imagePaths.length) return;
    final images = List<String>.of(state.imagePaths)..removeAt(index);
    emit(
      state.copyWith(
        imagePaths: List.unmodifiable(images),
        isUpdated: false,
        showSuccessBanner: false,
      ),
    );
  }
}
