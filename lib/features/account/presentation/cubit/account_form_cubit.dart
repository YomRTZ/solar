import 'package:flutter_bloc/flutter_bloc.dart';

class AccountFormState {
  final String businessName;
  final String contactPerson;
  final String deliveryAddress;
  final String gstNumber;
  final String panNumber;

  const AccountFormState({
    this.businessName = '',
    this.contactPerson = '',
    this.deliveryAddress = '',
    this.gstNumber = '',
    this.panNumber = '',
  });

  AccountFormState copyWith({
    String? businessName,
    String? contactPerson,
    String? deliveryAddress,
    String? gstNumber,
    String? panNumber,
  }) => AccountFormState(
    businessName: businessName ?? this.businessName,
    contactPerson: contactPerson ?? this.contactPerson,
    deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    gstNumber: gstNumber ?? this.gstNumber,
    panNumber: panNumber ?? this.panNumber,
  );
}

class AccountFormCubit extends Cubit<AccountFormState> {
  AccountFormCubit({AccountFormState initialState = const AccountFormState()})
    : super(initialState);

  void updateBusinessName(String value) =>
      emit(state.copyWith(businessName: value));
  void updateContactPerson(String value) =>
      emit(state.copyWith(contactPerson: value));
  void updateDeliveryAddress(String value) =>
      emit(state.copyWith(deliveryAddress: value));
  void updateGstNumber(String value) =>
      emit(state.copyWith(gstNumber: value));
  void updatePanNumber(String value) =>
      emit(state.copyWith(panNumber: value));
}
