import 'package:flutter_bloc/flutter_bloc.dart';

// ── Auth state ─────────────────────────────────────────────────────────────
enum AuthStatus { unauthenticated, authenticated }

class AuthState {
  final AuthStatus status;

  /// 'Supplier' or 'Vendor' — set at login role-selection
  final String role;

  /// Raw mobile digits (no spaces / country code)
  final String mobileNumber;

  /// Whether the OTP step has been completed successfully
  final bool otpVerified;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.role = 'Supplier',
    this.mobileNumber = '',
    this.otpVerified = false,
  });

  bool get isSupplier => role == 'Supplier';
  bool get isVendor => role == 'Vendor';

  AuthState copyWith({
    AuthStatus? status,
    String? role,
    String? mobileNumber,
    bool? otpVerified,
  }) => AuthState(
    status: status ?? this.status,
    role: role ?? this.role,
    mobileNumber: mobileNumber ?? this.mobileNumber,
    otpVerified: otpVerified ?? this.otpVerified,
  );
}

// ── AuthCubit ──────────────────────────────────────────────────────────────
/// App-wide authentication state.
///
/// Provided at the root [MultiBlocProvider] so every screen can read/update
/// the current user's role and auth status without prop-drilling.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  // ── Called from LoginScreen when role toggle changes ──────
  void selectRole(String role) => emit(state.copyWith(role: role));

  // ── Called from LoginScreen when number is typed ──────────
  void updateMobileNumber(String value) =>
      emit(state.copyWith(mobileNumber: value));

  // ── Called from OtpVerificationScreen on success ──────────
  void verifyOtp() => emit(state.copyWith(otpVerified: true));

  // ── Called after onboarding is fully complete ─────────────
  void markAuthenticated() =>
      emit(state.copyWith(status: AuthStatus.authenticated));

  // ── Log out ───────────────────────────────────────────────
  void logout() => emit(const AuthState());
}
