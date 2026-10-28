import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/widgets.dart';
import '../documents/upload_documents_screen.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController accountHolderNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data (remove in production)
    accountHolderNameController.text = 'Solar Trade';
    accountNumberController.text = '123456789';
    ifscCodeController.text = 'Hdfc1002';
    bankNameController.text = 'Hdfc Bank';
  }

  @override
  void dispose() {
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    bankNameController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    // Validate fields
    if (accountHolderNameController.text.isEmpty ||
        accountNumberController.text.isEmpty ||
        ifscCodeController.text.isEmpty ||
        bankNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate forward to Upload Documents
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UploadDocumentsScreen(),
      ),
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
                      label: 'Account Holder Name',
                      hint: 'Solar Trade',
                      controller: accountHolderNameController,
                    ),
                    const SizedBox(height: 24),
                    
                    AppTextField(
                      label: 'Account Number',
                      hint: '123456789',
                      controller: accountNumberController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    
                    AppTextField(
                      label: 'Ifsc Code',
                      hint: 'Hdfc1002',
                      controller: ifscCodeController,
                    ),
                    const SizedBox(height: 24),
                    
                    AppTextField(
                      label: 'Bank Name',
                      hint: 'Hdfc Bank',
                      controller: bankNameController,
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
        padding: EdgeInsets.fromLTRB(16, top + 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 16),
            Text(
              'Bank Details',
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
    );
  }
}
