import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/constants/app_colors.dart';
import 'package:flutter_app/features/documents/presentation/cubit/document_upload_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// My Documents screen — shows all 4 documents with tap-to-replace and delete.
class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
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
                _buildHeader(context),
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
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
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

  String get _displayName => fileName ?? '$label.pdf';
  bool get _isUploaded => fileName != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6C7278))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                _PdfIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF202020))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('94 KB of 94 KB',
                              style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9E9E9E))),
                          if (_isUploaded) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF27AE60),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 9),
                            ),
                            const SizedBox(width: 4),
                            Text('Uploaded',
                                style: GoogleFonts.roboto(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF27AE60))),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.delete_outline_rounded,
                        color: Colors.grey[500], size: 22),
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

class _PdfIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/ic_uploded_document.svg',
      width: 38,
      height: 44,
      fit: BoxFit.contain,
    );
  }
}
