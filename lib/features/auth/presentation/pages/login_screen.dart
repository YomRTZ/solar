import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/app/routing/route_data.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/core/validation/app_form_validation.dart';
import 'package:flutter_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// â”€â”€ Phone formatter: XXXX XXX XXXX â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Strip everything that isn't a digit
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Cap at 10 raw digits
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;

    // Build formatted string: XXXX XXX XXXX
    final buffer = StringBuffer();
    for (int i = 0; i < capped.length; i++) {
      if (i == 4 || i == 7) buffer.write(' ');
      buffer.write(capped[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _roleButtonBorderRadius = BorderRadius.all(Radius.circular(24));

  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final LoginCubit _loginCubit = LoginCubit();

  @override
  void dispose() {
    _mobileController.dispose();
    _loginCubit.close();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final rawDigits = _loginCubit.state.mobileNumber
        .replaceAll(' ', '')
        .trim();

    // Sync role and mobile number into the global AuthCubit
    final auth = context.read<AuthCubit>();
    auth.selectRole(_loginCubit.state.role);
    auth.updateMobileNumber(rawDigits);

    context.push(
      AppRoutes.otpVerification,
      extra: OtpRouteData(
        mobileNumber: '+91 $rawDigits',
        role: _loginCubit.state.role,
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    final isSelected = _loginCubit.state.role == role;

    return Expanded(
      child: SizedBox(
        height: 34,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF003A8A) : Colors.transparent,
            border: isSelected
                ? Border.all(color: const Color(0x80003A8A))
                : null,
            borderRadius: _roleButtonBorderRadius,
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x08000000),
                      offset: Offset(0, -2),
                      blurRadius: 2,
                      blurStyle: BlurStyle.inner,
                    ),
                    BoxShadow(
                      color: Color(0x3DE4E5E7),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: _roleButtonBorderRadius,
            child: InkWell(
              borderRadius: _roleButtonBorderRadius,
              onTap: () => _loginCubit.selectRole(role),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child: Text(
                    role,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF3D4348),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      bloc: _loginCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(
                children: [
                  // â”€â”€ Logo â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Positioned(
                    top: 77,
                    bottom: 575,
                    left: 88.5,
                    right: 89.5,
                    child: Image.asset(
                      'assets/images/photo_5979016740496674893_x.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),

                  // â”€â”€ "Welcome Back!" title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Positioned(
                    top: constraints.maxHeight - 575 + 24,
                    left: 48,
                    right: 49,
                    child: Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.56,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),

                  // â”€â”€ Subtitle: 12px below title (~34px title height) â”€â”€
                  Positioned(
                    top: constraints.maxHeight - 575 + 24 + 34 + 12,
                    left: 68.5,
                    right: 69.5,
                    child: Text(
                      'Log in to your Solar TradeXHub account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: 12 * -0.01,
                        color: const Color(0xFF6C7278),
                      ),
                    ),
                  ),

                  // â”€â”€ Supplier / Vendor toggle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  // 24px below subtitle
                  // subtitle top = constraints.maxHeight - 575 + 24 + 34 + 12
                  // subtitle height ~21px â†’ toggle top = subtitle top + 21 + 24
                  Positioned(
                    top: constraints.maxHeight - 575 + 24 + 34 + 12 + 21 + 24,
                    left: 16,
                    right: 17,
                    child: SizedBox(
                      height: 42,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: _roleButtonBorderRadius,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              blurStyle: BlurStyle.inner,
                            ),
                          ],
                        ),
                        foregroundDecoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFF5F6F9)),
                          borderRadius: _roleButtonBorderRadius,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            _buildRoleButton('Supplier'),
                            const SizedBox(width: 2),
                            _buildRoleButton('Vendor'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // â”€â”€ "Mobile number" label â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  // left:16, right:259, 24px below toggle
                  Positioned(
                    top: constraints.maxHeight - 575 + 24 + 34 + 12 + 21 + 24 + 42 + 24,
                    left: 16,
                    right: 259,
                    child: Text(
                      'Mobile number',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                        letterSpacing: 12 * -0.02,
                        color: const Color(0xFF6C7278),
                      ),
                    ),
                  ),

                  // â”€â”€ Mobile number input â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  // left:16, right:17, 3px below label (label height ~16px)
                  Positioned(
                    top: constraints.maxHeight - 575 + 24 + 34 + 12 + 21 + 24 + 42 + 24 + 16 + 3,
                    left: 16,
                    right: 17,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEDF1F3)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3DE4E5E7),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _mobileController,
                        onChanged: _loginCubit.updateMobileNumber,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _continue(),
                        inputFormatters: [_PhoneFormatter()],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          letterSpacing: 14 * -0.01,
                          color: const Color(0xFF1A1C1E),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          constraints: const BoxConstraints(minHeight: 46),
                          hintText: 'Enter your mobile number',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFFACB5BB),
                          ),
                          prefixText: '+91  ',
                          prefixStyle: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1C1E),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.fromLTRB(
                            14,
                            12.5,
                            106,
                            12.5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFBA1A1A),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFBA1A1A),
                              width: 1.5,
                            ),
                          ),
                          errorStyle: AppFormValidation.errorStyle,
                        ),
                        validator: AppFormValidation.phoneNumber,
                      ),
                    ),
                  ),

                  // â”€â”€ Continue button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                  Positioned(
                    left: 16,
                    right: 17,
                    bottom: 254,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          'Continue',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            letterSpacing: 14 * -0.01,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
            },
          ),
        ),
      ),
    ),
  );
  }
}
