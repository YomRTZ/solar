import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_file_upload_field.dart';

// ── Single vendor upload field ─────────────────────────────────────────────
class _VendorUploadField extends StatelessWidget {
  final String label;
  final String? selectedFileName;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _VendorUploadField({
    required this.label,
    required this.onTap,
    this.selectedFileName,
    this.onDelete,
  });

  String get _fileName => '$label.pdf';
  String get _fileSize => '94 KB of 94 KB •';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ─────────────────────────────────────────
        Text(
          label,
          maxLines: 1,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.6,
            letterSpacing: 12 * -0.02,
            color: const Color(0xFF6C7278),
          ),
        ),

        const SizedBox(height: 8),

        // ── Upload input area ──────────────────────────────
        // Height extended to fit 3 rows: filename, size, uploaded
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: double.infinity,
            height: 70,
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: const Color(0x40000000),
                strokeWidth: 1,
                dashWidth: 4,
                dashSpace: 4,
                borderRadius: 10,
              ),
              child: Stack(
                children: [
                  // ── PDF icon ─────────────────────────────
                  // top:14, left:21, width:26, height:26
                  Positioned(
                    top: 14,
                    left: 21,
                    child: SvgPicture.asset(
                      'assets/icons/Group 5.svg',
                      width: 26,
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // ── Text section ─────────────────────────
                  // left:60, right:47, top:8, bottom:8
                  Positioned(
                    left: 60,
                    right: 47,
                    top: 8,
                    bottom: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filename
                        Text(
                          selectedFileName ?? _fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: 0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Size
                        Text(
                          _fileSize,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: 0,
                            color: const Color(0x66000000),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ── Tick icon + "Uploaded" ──────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/tick-circle.svg',
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Uploaded',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                letterSpacing: 0,
                                color: const Color(0xFF292D32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Delete icon ───────────────────────────
                  // left:296, top:10, bottom:30, right:10
                  Positioned(
                    left: 296,
                    top: 10,
                    bottom: 30,
                    right: 10,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: SvgPicture.asset(
                        'assets/icons/Delete.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Screen ─────────────────────────────────────────────────────────────────
class VendorUploadDocumentsScreen extends StatefulWidget {
  const VendorUploadDocumentsScreen({super.key});

  @override
  State<VendorUploadDocumentsScreen> createState() =>
      _VendorUploadDocumentsScreenState();
}

class _VendorUploadDocumentsScreenState
    extends State<VendorUploadDocumentsScreen> {
  String? _gstCertificateFile;
  String? _panCardFile;
  String? _businessRegistrationFile;
  String? _cancelledChequeFile;

  bool _isLoading = false;

  void _pickFile(void Function(String fileName) onPicked) {
    onPicked('document_selected.pdf');
  }

  void _handleContinue() async {
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

    context.push(AppRoutes.vendorTerms);
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
            // ── Header ──────────────────────────────────────
            const AppHeader(title: 'Upload Documents'),

            // ── Scrollable form ──────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(19, 23, 14, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Gst Certificate ──────────────────────
                    _VendorUploadField(
                      label: 'Gst Certificate',
                      selectedFileName: _gstCertificateFile,
                      onTap: () => _pickFile(
                        (f) => setState(() => _gstCertificateFile = f),
                      ),
                      onDelete: () => setState(() => _gstCertificateFile = null),
                    ),
                    const SizedBox(height: 10),

                    // ── Pan Card ─────────────────────────────
                    _VendorUploadField(
                      label: 'Pan Card',
                      selectedFileName: _panCardFile,
                      onTap: () =>
                          _pickFile((f) => setState(() => _panCardFile = f)),
                      onDelete: () => setState(() => _panCardFile = null),
                    ),
                    const SizedBox(height: 10),

                    // ── Business Registration ─────────────────
                    _VendorUploadField(
                      label: 'Business Registration',
                      selectedFileName: _businessRegistrationFile,
                      onTap: () => _pickFile(
                        (f) =>
                            setState(() => _businessRegistrationFile = f),
                      ),
                      onDelete: () => setState(() => _businessRegistrationFile = null),
                    ),
                    const SizedBox(height: 10),

                    // ── Cancelled Cheque ──────────────────────
                    _VendorUploadField(
                      label: 'Cancelled Cheque',
                      selectedFileName: _cancelledChequeFile,
                      onTap: () => _pickFile(
                        (f) => setState(() => _cancelledChequeFile = f),
                      ),
                      onDelete: () => setState(() => _cancelledChequeFile = null),
                    ),
                    const SizedBox(height: 18),

                    // ── Continue button ───────────────────────
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
