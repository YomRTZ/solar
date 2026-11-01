import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';
import 'package:flutter_app/features/vendor/domain/entities/vendor_rfq_request.dart';

class VendorNavigationState {
  final int selectedTab;

  const VendorNavigationState({this.selectedTab = 0});
}

class VendorNavigationCubit extends Cubit<VendorNavigationState> {
  VendorNavigationCubit({int initialTab = 0})
    : super(VendorNavigationState(selectedTab: initialTab));

  void selectTab(int index) =>
      emit(VendorNavigationState(selectedTab: index));
}

class VendorCatalogState {
  final String query;
  final Map<String, int> cartQuantities;
  final List<CatalogProduct> comparedProducts;

  const VendorCatalogState({
    this.query = '',
    this.cartQuantities = const {},
    this.comparedProducts = const [],
  });

  int get cartCount =>
      cartQuantities.values.fold(0, (total, quantity) => total + quantity);

  VendorCatalogState copyWith({
    String? query,
    Map<String, int>? cartQuantities,
    List<CatalogProduct>? comparedProducts,
  }) => VendorCatalogState(
    query: query ?? this.query,
    cartQuantities: cartQuantities ?? this.cartQuantities,
    comparedProducts: comparedProducts ?? this.comparedProducts,
  );
}

class VendorCatalogCubit extends Cubit<VendorCatalogState> {
  VendorCatalogCubit() : super(const VendorCatalogState());

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

enum VendorRequestFilter { all, received, pending }

class VendorRequestListCubit extends Cubit<VendorRequestFilter> {
  VendorRequestListCubit() : super(VendorRequestFilter.all);

  void select(VendorRequestFilter filter) => emit(filter);

  List<VendorRfqRequest> filterRequests(List<VendorRfqRequest> requests) {
    switch (state) {
      case VendorRequestFilter.all:
        return requests;
      case VendorRequestFilter.received:
        return requests
            .where((request) => request.status == VendorRfqStatus.received)
            .toList();
      case VendorRequestFilter.pending:
        return requests
            .where((request) => request.status == VendorRfqStatus.pending)
            .toList();
    }
  }
}

enum VendorPaymentMethod { card, afterpay, klarna }

class VendorCheckoutState {
  final VendorPaymentMethod paymentMethod;
  final String country;
  final String cardNumber;
  final String expiry;
  final String cvc;

  const VendorCheckoutState({
    this.paymentMethod = VendorPaymentMethod.card,
    this.country = 'Hong Kong SAR China',
    this.cardNumber = '1234 1234 1234 1234',
    this.expiry = '',
    this.cvc = '',
  });

  VendorCheckoutState copyWith({
    VendorPaymentMethod? paymentMethod,
    String? country,
    String? cardNumber,
    String? expiry,
    String? cvc,
  }) => VendorCheckoutState(
    paymentMethod: paymentMethod ?? this.paymentMethod,
    country: country ?? this.country,
    cardNumber: cardNumber ?? this.cardNumber,
    expiry: expiry ?? this.expiry,
    cvc: cvc ?? this.cvc,
  );
}

class VendorCheckoutCubit extends Cubit<VendorCheckoutState> {
  VendorCheckoutCubit() : super(const VendorCheckoutState());

  void selectPaymentMethod(VendorPaymentMethod method) =>
      emit(state.copyWith(paymentMethod: method));
  void selectCountry(String country) => emit(state.copyWith(country: country));
  void updateCardNumber(String value) =>
      emit(state.copyWith(cardNumber: value));
  void updateExpiry(String value) => emit(state.copyWith(expiry: value));
  void updateCvc(String value) => emit(state.copyWith(cvc: value));
}

class VendorCartState {
  final List<CatalogProduct> items;
  final Map<String, int> quantities;

  const VendorCartState({this.items = const [], this.quantities = const {}});

  VendorCartState copyWith({
    List<CatalogProduct>? items,
    Map<String, int>? quantities,
  }) => VendorCartState(
    items: items ?? this.items,
    quantities: quantities ?? this.quantities,
  );
}

class VendorCartCubit extends Cubit<VendorCartState> {
  VendorCartCubit({
    required List<CatalogProduct> items,
    required Map<String, int> initialQuantities,
  }) : super(
         VendorCartState(
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
