import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _roleButtonBorderRadius = BorderRadius.all(Radius.circular(24));

  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  String _selectedRole = 'Supplier';

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          mobileNumber: '+91 ${_mobileController.text.trim()}',
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    final isSelected = _selectedRole == role;

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
              onTap: () => setState(() => _selectedRole = role),
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
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth = constraints.maxWidth < 359
                  ? constraints.maxWidth - 32
                  : 327.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 77, 16, 24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: contentWidth,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 469),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/photo_5979016740496674893_x.jpg',
                                width: 182,
                                height: 148,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.56,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Log in to your Solar TradeXHub account',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: const Color(0xFF6C7278),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
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
                                  border: Border.all(
                                    color: const Color(0xFFF5F6F9),
                                  ),
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
                            const SizedBox(height: 24),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Mobile number',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF3D4348),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFEDF1F3),
                                    ),
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
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _continue(),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1A1C1E),
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      constraints: const BoxConstraints(
                                        minHeight: 46,
                                      ),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 11,
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
                                    ),
                                    validator: (value) {
                                      final number = value?.trim() ?? '';
                                      if (number.isEmpty) {
                                        return 'Enter your mobile number';
                                      }
                                      if (!RegExp(
                                        r'^[6-9]\d{9}$',
                                      ).hasMatch(number)) {
                                        return 'Enter a valid 10-digit mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Continue'),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
