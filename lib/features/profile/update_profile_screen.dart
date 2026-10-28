import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/widgets.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing profile data
    _businessController.text = 'Solar Trade';
    _contactPersonController.text = 'Rahul Roy';
    _deliveryAddressController.text = '123-33 New Delhi - 112234';
    _gstNumberController.text = '9876546879';
    _panNumberController.text = '12345678';
  }

  @override
  void dispose() {
    _businessController.dispose();
    _contactPersonController.dispose();
    _deliveryAddressController.dispose();
    _gstNumberController.dispose();
    _panNumberController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (_businessController.text.trim().isEmpty ||
        _contactPersonController.text.trim().isEmpty ||
        _deliveryAddressController.text.trim().isEmpty ||
        _gstNumberController.text.trim().isEmpty ||
        _panNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: persist changes via API / state management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Color(0xFF003A8A),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────
            _buildHeader(context),

            // ── Scrollable form ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Business',
                      hint: 'Solar Trade',
                      controller: _businessController,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Contact Person',
                      hint: 'Rahul Roy',
                      controller: _contactPersonController,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Delivery Address',
                      hint: '123-33 New Delhi - 112234',
                      controller: _deliveryAddressController,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Gst Number',
                      hint: '9876546879',
                      controller: _gstNumberController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Pan  Number',
                      hint: '12345678',
                      controller: _panNumberController,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 36),

                    // ── Update button ────────────────────────
                    AppContinueButton(
                      text: 'Update',
                      showArrow: false,
                      onPressed: _handleUpdate,
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

  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 133,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFFEEEEEE),
                size: 24,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Update Profile',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEEEEEE),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
