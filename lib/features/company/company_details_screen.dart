import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/widgets.dart';
import '../bank/bank_details_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dispatchLocationController =
      TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data (remove in production)
    companyNameController.text = 'Solar Trade';
    emailController.text = 'Solar@gmail.com';
    addressController.text = '12-223 Salest, New Delhi';
    dispatchLocationController.text = '12-223 Salest, New Delhi';
    gstNumberController.text = '08TGC45879';
    panNumberController.text = '123456789';
  }

  @override
  void dispose() {
    companyNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    dispatchLocationController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    // Validate fields
    if (companyNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        dispatchLocationController.text.isEmpty ||
        gstNumberController.text.isEmpty ||
        panNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to Bank Details screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BankDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            // Header
            _buildHeader(context),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Company Name',
                      hint: 'Solar Trade',
                      controller: companyNameController,
                    ),
                    const SizedBox(height: 24),

                    AppTextField(
                      label: 'Email Address',
                      hint: 'Solar@gmail.com',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),

                    AppTextField(
                      label: 'Address',
                      hint: '12-223 Salest, New Delhi',
                      controller: addressController,
                    ),
                    const SizedBox(height: 24),

                    AppTextField(
                      label: 'Dispatch Location',
                      hint: '12-223 Salest, New Delhi',
                      controller: dispatchLocationController,
                    ),
                    const SizedBox(height: 24),

                    AppTextField(
                      label: 'Gst Number',
                      hint: '08TGC45879',
                      controller: gstNumberController,
                    ),
                    const SizedBox(height: 24),

                    AppTextField(
                      label: 'Pan Number',
                      hint: '123456789',
                      controller: panNumberController,
                    ),
                    const SizedBox(height: 32),

                    // Continue Button
                    AppContinueButton(
                      text: 'Continue',
                      onPressed: _handleContinue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header with back button and title
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 192,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/icons/arrow-narrow-left.svg',
                  width: 24,
                  height: 24,
                ),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Back',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Company Details',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
