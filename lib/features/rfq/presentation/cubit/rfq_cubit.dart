import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';

class RfqListState {
  final RFQStatus? filter;

  const RfqListState({this.filter});

  RfqListState copyWith({RFQStatus? filter, bool clearFilter = false}) =>
      RfqListState(filter: clearFilter ? null : filter ?? this.filter);
}

class RfqListCubit extends Cubit<RfqListState> {
  RfqListCubit() : super(const RfqListState());

  void selectFilter(RFQStatus? filter) => emit(
    state.copyWith(filter: filter, clearFilter: filter == null),
  );
}

class RfqDetailState {
  final bool isLoading;
  final bool showQuoteForm;
  final String quantity;
  final String unitPrice;
  final String gst;
  final String deliveryDate;

  const RfqDetailState({
    this.isLoading = false,
    this.showQuoteForm = false,
    this.quantity = '',
    this.unitPrice = '',
    this.gst = '',
    this.deliveryDate = '',
  });

  RfqDetailState copyWith({
    bool? isLoading,
    bool? showQuoteForm,
    String? quantity,
    String? unitPrice,
    String? gst,
    String? deliveryDate,
  }) => RfqDetailState(
    isLoading: isLoading ?? this.isLoading,
    showQuoteForm: showQuoteForm ?? this.showQuoteForm,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    gst: gst ?? this.gst,
    deliveryDate: deliveryDate ?? this.deliveryDate,
  );
}

class RfqDetailCubit extends Cubit<RfqDetailState> {
  RfqDetailCubit({RfqDetailState initialState = const RfqDetailState()})
    : super(initialState);

  void showQuoteForm() => emit(state.copyWith(showQuoteForm: true));
  void hideQuoteForm() => emit(state.copyWith(showQuoteForm: false));
  void setLoading(bool value) => emit(state.copyWith(isLoading: value));
  void setQuantity(String value) => emit(state.copyWith(quantity: value));
  void setUnitPrice(String value) => emit(state.copyWith(unitPrice: value));
  void setGst(String value) => emit(state.copyWith(gst: value));
  void setDeliveryDate(String value) =>
      emit(state.copyWith(deliveryDate: value));
}
