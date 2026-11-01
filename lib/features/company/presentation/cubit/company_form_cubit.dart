import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyFormState {
  final String companyName;
  final String email;
  final String address;
  final String dispatchLocation;
  final String gstNumber;
  final String panNumber;

  const CompanyFormState({
    this.companyName = '',
    this.email = '',
    this.address = '',
    this.dispatchLocation = '',
    this.gstNumber = '',
    this.panNumber = '',
  });
}

class CompanyFormCubit extends Cubit<CompanyFormState> {
  CompanyFormCubit({CompanyFormState initialState = const CompanyFormState()})
    : super(initialState);

  void updateCompanyName(String value) =>
      emit(CompanyFormState(
        companyName: value,
        email: state.email,
        address: state.address,
        dispatchLocation: state.dispatchLocation,
        gstNumber: state.gstNumber,
        panNumber: state.panNumber,
      ));
  void updateEmail(String value) => emit(CompanyFormState(
    companyName: state.companyName,
    email: value,
    address: state.address,
    dispatchLocation: state.dispatchLocation,
    gstNumber: state.gstNumber,
    panNumber: state.panNumber,
  ));
  void updateAddress(String value) => emit(CompanyFormState(
    companyName: state.companyName,
    email: state.email,
    address: value,
    dispatchLocation: state.dispatchLocation,
    gstNumber: state.gstNumber,
    panNumber: state.panNumber,
  ));
  void updateDispatchLocation(String value) => emit(CompanyFormState(
    companyName: state.companyName,
    email: state.email,
    address: state.address,
    dispatchLocation: value,
    gstNumber: state.gstNumber,
    panNumber: state.panNumber,
  ));
  void updateGstNumber(String value) => emit(CompanyFormState(
    companyName: state.companyName,
    email: state.email,
    address: state.address,
    dispatchLocation: state.dispatchLocation,
    gstNumber: value,
    panNumber: state.panNumber,
  ));
  void updatePanNumber(String value) => emit(CompanyFormState(
    companyName: state.companyName,
    email: state.email,
    address: state.address,
    dispatchLocation: state.dispatchLocation,
    gstNumber: state.gstNumber,
    panNumber: value,
  ));
}
