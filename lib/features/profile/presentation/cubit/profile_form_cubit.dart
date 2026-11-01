import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFormState {
  final String businessName;
  final String contactPerson;
  final String deliveryAddress;
  final String gstNumber;
  final String panNumber;

  /// True once [ProfileFormCubit.markSaved] is called, i.e. after a successful
  /// form submission.  Resets to false on any subsequent field change.
  final bool isSaved;

  const ProfileFormState({
    this.businessName = '',
    this.contactPerson = '',
    this.deliveryAddress = '',
    this.gstNumber = '',
    this.panNumber = '',
    this.isSaved = false,
  });

  ProfileFormState copyWith({
    String? businessName,
    String? contactPerson,
    String? deliveryAddress,
    String? gstNumber,
    String? panNumber,
    bool? isSaved,
  }) => ProfileFormState(
    businessName: businessName ?? this.businessName,
    contactPerson: contactPerson ?? this.contactPerson,
    deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    gstNumber: gstNumber ?? this.gstNumber,
    panNumber: panNumber ?? this.panNumber,
    isSaved: isSaved ?? this.isSaved,
  );
}

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit({ProfileFormState initialState = const ProfileFormState()})
      : super(initialState);

  void updateBusinessName(String value) =>
      emit(state.copyWith(businessName: value, isSaved: false));

  void updateContactPerson(String value) =>
      emit(state.copyWith(contactPerson: value, isSaved: false));

  void updateDeliveryAddress(String value) =>
      emit(state.copyWith(deliveryAddress: value, isSaved: false));

  void updateGstNumber(String value) =>
      emit(state.copyWith(gstNumber: value, isSaved: false));

  void updatePanNumber(String value) =>
      emit(state.copyWith(panNumber: value, isSaved: false));

  /// Call after validating the form to mark the current values as persisted.
  void markSaved() => emit(state.copyWith(isSaved: true));
}
