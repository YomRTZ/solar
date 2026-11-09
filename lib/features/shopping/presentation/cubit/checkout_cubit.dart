import 'package:flutter_bloc/flutter_bloc.dart';

enum PaymentMethod { card, afterpay, klarna }

class CheckoutState {
  final PaymentMethod paymentMethod;
  final String country;
  final String cardNumber;
  final String expiry;
  final String cvc;

  const CheckoutState({
    this.paymentMethod = PaymentMethod.card,
    this.country = 'Hong Kong SAR China',
    this.cardNumber = '',
    this.expiry = '',
    this.cvc = '',
  });

  CheckoutState copyWith({
    PaymentMethod? paymentMethod,
    String? country,
    String? cardNumber,
    String? expiry,
    String? cvc,
  }) => CheckoutState(
    paymentMethod: paymentMethod ?? this.paymentMethod,
    country: country ?? this.country,
    cardNumber: cardNumber ?? this.cardNumber,
    expiry: expiry ?? this.expiry,
    cvc: cvc ?? this.cvc,
  );
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  void selectPaymentMethod(PaymentMethod method) =>
      emit(state.copyWith(paymentMethod: method));
  void selectCountry(String country) => emit(state.copyWith(country: country));
  void updateCardNumber(String value) =>
      emit(state.copyWith(cardNumber: value));
  void updateExpiry(String value) => emit(state.copyWith(expiry: value));
  void updateCvc(String value) => emit(state.copyWith(cvc: value));
}
