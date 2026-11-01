import 'package:flutter_bloc/flutter_bloc.dart';

class OtpState {
  final List<String> digits;

  const OtpState({this.digits = const ['', '', '', '', '', '']});

  String get code => digits.join();
  bool get isComplete => digits.length == 6 && digits.every((digit) => digit.isNotEmpty);

  OtpState withDigit(int index, String value) {
    final nextDigits = List<String>.of(digits);
    nextDigits[index] = value;
    return OtpState(digits: List.unmodifiable(nextDigits));
  }
}

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const OtpState());

  void updateDigit(int index, String value) {
    if (index < 0 || index >= state.digits.length) return;
    emit(state.withDigit(index, value));
  }
}
