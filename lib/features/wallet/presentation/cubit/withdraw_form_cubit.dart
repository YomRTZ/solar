import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFormState {
  final String amount;
  final int selectedAccountIndex;

  const WithdrawFormState({this.amount = '', this.selectedAccountIndex = 0});

  WithdrawFormState copyWith({String? amount, int? selectedAccountIndex}) =>
      WithdrawFormState(
        amount: amount ?? this.amount,
        selectedAccountIndex: selectedAccountIndex ?? this.selectedAccountIndex,
      );
}

class WithdrawFormCubit extends Cubit<WithdrawFormState> {
  WithdrawFormCubit({required String initialAmount})
    : super(WithdrawFormState(amount: initialAmount));

  void updateAmount(String amount) => emit(state.copyWith(amount: amount));
  void selectAccount(int index) =>
      emit(state.copyWith(selectedAccountIndex: index));
}
