import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_file_upload_field.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  // Selected file names — null means nothing picked yet
  String? _gstCertificateFile;
  String? _panCardFile;
  String? _businessRegistrationFile;
  String? _cancelledChequeFile;

  bool _isLoading = false;

  // ── Simulate file picking ──────────────────────────────────
  void _pickFile(void Function(String fileName) onPicked) {
    // In production replace with file_picker package call.
    // For now we just simulate a picked filename.
    onPicked('document_selected.pdf');
  }

  void _handleContinue() async {
    // Validate — all four docs must be selected
    if (_gstCertificateFile == null ||
        _panCardFile == null ||
        _businessRegistrationFile == null ||
        _cancelledChequeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate forward to Terms of Service
    context.push(AppRoutes.termsOfService);
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
            // ── Reusable gradient header ─────────────────────
            const AppHeader(
              title: 'Upload Documents',
              height: 133,
              titleBelowBackButton: true,
            ),

            // ── Scrollable form body ─────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  children: [
                    // ── Gst Certificate ──────────────────────
                    AppFileUploadField(
                      label: 'Gst Certificate',
                      selectText: 'Select a file',
                      helperText:
                          'JPG, PNG or PDF, file size no more than 10MB',
                      selectedFileName: _gstCertificateFile,
                      onTap: () => _pickFile(
                        (f) => setState(() => _gstCertificateFile = f),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Pan Card ─────────────────────────────
                    AppFileUploadField(
                      label: 'Pan Card',
                      selectText: 'Select a file',
                      helperText:
                          'JPG, PNG or PDF, file size no more than 10MB',
                      selectedFileName: _panCardFile,
                      onTap: () =>
                          _pickFile((f) => setState(() => _panCardFile = f)),
                    ),
                    const SizedBox(height: 24),

                    // ── Business Registration ─────────────────
                    AppFileUploadField(
                      label: 'Business Registration',
                      selectText: 'Select a file',
                      helperText:
                          'JPG, PNG or PDF, file size no more than 10MB',
                      selectedFileName: _businessRegistrationFile,
                      onTap: () => _pickFile(
                        (f) => setState(() => _businessRegistrationFile = f),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Cancelled Cheque ──────────────────────
                    AppFileUploadField(
                      label: 'Cancelled Cheque',
                      selectText: 'Select a file',
                      helperText:
                          'JPG, PNG or PDF, file size no more than 10MB',
                      selectedFileName: _cancelledChequeFile,
                      onTap: () => _pickFile(
                        (f) => setState(() => _cancelledChequeFile = f),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Reusable Continue button ──────────────
                    AppContinueButton(
                      text: 'Continue',
                      showArrow: false,
                      isLoading: _isLoading,
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
}
