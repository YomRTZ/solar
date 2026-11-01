import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';

enum OrdersFilter { all, pending, delivered }

class OrdersState {
  final OrdersFilter filter;

  const OrdersState({this.filter = OrdersFilter.all});

  OrdersState copyWith({OrdersFilter? filter}) =>
      OrdersState(filter: filter ?? this.filter);
}

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState());

  void selectFilter(OrdersFilter filter) =>
      emit(state.copyWith(filter: filter));

  List<Order> filterOrders(List<Order> orders) {
    switch (state.filter) {
      case OrdersFilter.all:
        return orders;
      case OrdersFilter.pending:
        return orders
            .where((order) => order.status != OrderStatus.delivered)
            .toList();
      case OrdersFilter.delivered:
        return orders
            .where((order) => order.status == OrderStatus.delivered)
            .toList();
    }
  }
}

class OrderDispatchFormState {
  final String transporter;
  final String trackingNumber;
  final String dispatchDate;
  final String? proofImageAssetPath;
  final Uint8List? proofImageBytes;
  final bool isLoading;

  const OrderDispatchFormState({
    this.transporter = 'Ekart',
    this.trackingNumber = '12,340',
    this.dispatchDate = '20 Oct 2026',
    this.proofImageAssetPath =
        'assets/solarimages/03f133a91b6e5ade2638722f368e27d2f92f051b.png',
    this.proofImageBytes,
    this.isLoading = false,
  });

  OrderDispatchFormState copyWith({
    String? transporter,
    String? trackingNumber,
    String? dispatchDate,
    String? proofImageAssetPath,
    bool clearProofImageAssetPath = false,
    Uint8List? proofImageBytes,
    bool clearProofImageBytes = false,
    bool? isLoading,
  }) => OrderDispatchFormState(
    transporter: transporter ?? this.transporter,
    trackingNumber: trackingNumber ?? this.trackingNumber,
    dispatchDate: dispatchDate ?? this.dispatchDate,
    proofImageAssetPath: clearProofImageAssetPath
        ? null
        : proofImageAssetPath ?? this.proofImageAssetPath,
    proofImageBytes: clearProofImageBytes
        ? null
        : proofImageBytes ?? this.proofImageBytes,
    isLoading: isLoading ?? this.isLoading,
  );
}

class OrderDispatchFormCubit extends Cubit<OrderDispatchFormState> {
  OrderDispatchFormCubit({
    OrderDispatchFormState initialState = const OrderDispatchFormState(),
  }) : super(initialState);

  void setTransporter(String value) => emit(state.copyWith(transporter: value));
  void setTrackingNumber(String value) =>
      emit(state.copyWith(trackingNumber: value));
  void setDispatchDate(String value) =>
      emit(state.copyWith(dispatchDate: value));

  void setProofImage(Uint8List bytes) => emit(
    state.copyWith(clearProofImageAssetPath: true, proofImageBytes: bytes),
  );
}
