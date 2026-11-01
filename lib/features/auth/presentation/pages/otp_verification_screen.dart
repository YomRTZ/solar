import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_app/features/auth/presentation/cubit/otp_cubit.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  /// The role selected on the login screen — 'Supplier' or 'Vendor'.
  /// Also written into [AuthCubit] so downstream screens can read it.
  final String role;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    this.role = 'Supplier',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final OtpCubit _otpCubit = OtpCubit();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Keep AuthCubit in sync with the role/number passed from LoginScreen.
    final auth = context.read<AuthCubit>();
    auth.selectRole(widget.role);
    auth.updateMobileNumber(
      widget.mobileNumber.replaceAll(RegExp(r'\D'), ''),
    );
  }

  @override
  void dispose() {
    for (final c in otpControllers) { c.dispose(); }
    for (final n in otpFocusNodes) { n.dispose(); }
    _otpCubit.close();
    super.dispose();
  }

  void _continue() {
    if (!_otpCubit.state.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 6-digit verification code.')),
      );
      return;
    }

    // Mark OTP as verified in the global auth cubit.
    context.read<AuthCubit>().verifyOtp();

    // Route based on role:
    //   Supplier → company details onboarding
    //   Vendor   → vendor account/create onboarding
    if (widget.role == 'Vendor') {
      context.push(AppRoutes.createAccount);
    } else {
      context.push(AppRoutes.companyDetails);
    }
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 45,
      height: 45,
      child: TextField(
        controller: otpControllers[index],
        focusNode: otpFocusNodes[index],
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        textInputAction:
            index == 5 ? TextInputAction.done : TextInputAction.next,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1C1E),
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          isDense: false,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0x66B8B8B8), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          ),
        ),
        onChanged: (value) {
          _otpCubit.updateDigit(index, value);
          if (value.isNotEmpty && index < otpFocusNodes.length - 1) {
            otpFocusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            otpFocusNodes[index - 1].requestFocus();
          } else if (value.isNotEmpty && index == otpFocusNodes.length - 1) {
            otpFocusNodes[index].unfocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
              return Stack(
                children: [
                  // ── Logo ───────────────────────────────────
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

                  // ── "Verify OTP" title ─────────────────────
                  Positioned(
                    top: constraints.maxHeight - 575 + 24,
                    left: 48,
                    right: 49,
                    child: Text(
                      'Verify OTP',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.56,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),

                  // ── Subtitle ───────────────────────────────
                  Positioned(
                    top: constraints.maxHeight - 575 + 24 + 34 + 12,
                    left: 68.5,
                    right: 69.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'An OTP has been sent to',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 12 * -0.01,
                            color: const Color(0xFF6C7278),
                          ),
                        ),
                        Text(
                          widget.mobileNumber,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 12 * -0.01,
                            color: const Color(0xFF6C7278),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── OTP label + fields ─────────────────────
                  Positioned(
                    top: constraints.maxHeight -
                        575 +
                        24 +
                        34 +
                        12 +
                        42 +
                        24 +
                        11,
                    left: 16,
                    right: 17,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'OTP',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                            letterSpacing: 12 * -0.02,
                            color: const Color(0xFF6C7278),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var i = 0; i < 6; i++) _buildOtpField(i),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Resend OTP ─────────────────────────────
                  Positioned(
                    left: 16,
                    right: 17,
                    bottom: 326,
                    child: Text(
                      'Resend Otp In 01:00',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        letterSpacing: 11 * -0.01,
                        color: const Color(0xFF003A8A),
                      ),
                    ),
                  ),

                  // ── Continue button ────────────────────────
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
