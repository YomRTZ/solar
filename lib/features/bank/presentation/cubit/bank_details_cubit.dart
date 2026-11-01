import 'package:flutter_bloc/flutter_bloc.dart';

class BankDetailsState {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;

  const BankDetailsState({
    this.accountHolderName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.bankName = '',
  });

  BankDetailsState copyWith({
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? bankName,
  }) => BankDetailsState(
    accountHolderName: accountHolderName ?? this.accountHolderName,
    accountNumber: accountNumber ?? this.accountNumber,
    ifscCode: ifscCode ?? this.ifscCode,
    bankName: bankName ?? this.bankName,
  );
}

class BankDetailsCubit extends Cubit<BankDetailsState> {
  BankDetailsCubit({BankDetailsState initialState = const BankDetailsState()})
    : super(initialState);

  void updateAccountHolderName(String value) =>
      emit(state.copyWith(accountHolderName: value));
  void updateAccountNumber(String value) =>
      emit(state.copyWith(accountNumber: value));
  void updateIfscCode(String value) => emit(state.copyWith(ifscCode: value));
  void updateBankName(String value) => emit(state.copyWith(bankName: value));
}
