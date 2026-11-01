import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/features/documents/presentation/cubit/document_upload_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Vendor "My Documents" screen — accessible from the vendor profile page.
/// Shows all 4 documents pre-populated (simulating already uploaded files)
/// with tap-to-replace and delete functionality.
/// The bottom "Update" button saves the selection.
class VendorDocumentsScreen extends StatefulWidget {
  const VendorDocumentsScreen({super.key});

  @override
  State<VendorDocumentsScreen> createState() => _VendorDocumentsScreenState();
}

class _VendorDocumentsScreenState extends State<VendorDocumentsScreen> {
  // Pre-populate with default filenames to match the screenshot
  final DocumentUploadCubit _cubit = DocumentUploadCubit(
    initialState: const DocumentUploadState(
      gstCertificate: 'Gst Certificate.pdf',
      panCard: 'Pan Card.pdf',
      businessRegistration: 'Business Registration.pdf',
      cancelledCheque: 'Cancelled Cheque.pdf',
    ),
  );

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  // ── Real file picker ────────────────────────────────────────
  Future<void> _pickFile(void Function(String fileName) onPicked) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.isNotEmpty) {
        onPicked(result.files.first.name);
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file picker: $e')),
        );
      }
    }
  }

  void _handleUpdate() async {
    _cubit.setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _cubit.setLoading(false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documents updated successfully'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
      bloc: _cubit,
      builder: (context, state) {
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
                // ── Gradient header ──────────────────────────
                _buildHeader(context),

                // ── Scrollable document list ─────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _DocumentField(
                          label: 'Gst Certificate',
                          fileName: state.gstCertificate,
                          onTap: () => _pickFile(_cubit.setGstCertificate),
                          onDelete: () => _cubit.setGstCertificate(null),
                        ),
                        const SizedBox(height: 20),

                        _DocumentField(
                          label: 'Pan Card',
                          fileName: state.panCard,
                          onTap: () => _pickFile(_cubit.setPanCard),
                          onDelete: () => _cubit.setPanCard(null),
                        ),
                        const SizedBox(height: 20),

                        _DocumentField(
                          label: 'Business Registration',
                          fileName: state.businessRegistration,
                          onTap: () =>
                              _pickFile(_cubit.setBusinessRegistration),
                          onDelete: () =>
                              _cubit.setBusinessRegistration(null),
                        ),
                        const SizedBox(height: 20),

                        _DocumentField(
                          label: 'Cancelled Cheque',
                          fileName: state.cancelledCheque,
                          onTap: () => _pickFile(_cubit.setCancelledCheque),
                          onDelete: () => _cubit.setCancelledCheque(null),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Update button (pinned at bottom) ─────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    MediaQuery.of(context).padding.bottom + 16,
                  ),
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _handleUpdate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.primaryBlue.withValues(alpha: 0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Update',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Gradient header with back arrow + "My Documents" title ───
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, top + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back arrow
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          // Large title
          Text(
            'My Documents',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single document field card ────────────────────────────────
class _DocumentField extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _DocumentField({
    required this.label,
    required this.onTap,
    this.fileName,
    this.onDelete,
  });

  /// Fallback display name when no file has been selected
  String get _displayName => fileName ?? '$label.pdf';

  bool get _isUploaded => fileName != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label above the card ────────────────────────────
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6C7278),
          ),
        ),
        const SizedBox(height: 8),

        // ── Document card ───────────────────────────────────
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // ── PDF badge icon ────────────────────────────
                _PdfIcon(),
                const SizedBox(width: 12),

                // ── Filename + size + uploaded row ────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF202020),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '94 KB of 94 KB',
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF9E9E9E),
                            ),
                          ),
                          if (_isUploaded) ...[
                            const SizedBox(width: 8),
                            // Green circle-tick icon
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFF27AE60),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 9,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Uploaded',
                              style: GoogleFonts.roboto(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF27AE60),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Delete icon ───────────────────────────────
                GestureDetector(
                  onTap: onDelete,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.grey[500],
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── PDF icon badge (red PDF label on grey paper icon) ─────────
class _PdfIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Paper body
          Container(
            width: 34,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 0.8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Folded corner lines
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Column(
                    children: [
                      _Line(),
                      const SizedBox(height: 3),
                      _Line(),
                      const SizedBox(height: 3),
                      _Line(width: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Red PDF label
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                'PDF',
                style: GoogleFonts.roboto(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final double width;
  const _Line({this.width = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFDDDDDD),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
