import 'package:flutter_bloc/flutter_bloc.dart';

class LoginState {
  final String role;
  final String mobileNumber;

  const LoginState({this.role = 'Supplier', this.mobileNumber = ''});

  LoginState copyWith({String? role, String? mobileNumber}) => LoginState(
    role: role ?? this.role,
    mobileNumber: mobileNumber ?? this.mobileNumber,
  );
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void selectRole(String role) => emit(state.copyWith(role: role));

  void updateMobileNumber(String value) =>
      emit(state.copyWith(mobileNumber: value));
}
