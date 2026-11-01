import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_file_upload_field.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/features/documents/presentation/cubit/document_upload_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final DocumentUploadCubit _cubit = DocumentUploadCubit();

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

  void _handleContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _cubit.setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _cubit.setLoading(false);
    context.push(AppRoutes.termsOfService);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentUploadCubit, DocumentUploadState>(
      bloc: _cubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
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
              const AppHeader(
                title: 'Upload Documents',
                height: 133,
                titleBelowBackButton: true,
              ),

              // ── Scrollable form body ─────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 25),
                  child: Form(
                    key: _formKey,
                    child: AppFormSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── GST Certificate ────────────────
                          AppFileUploadField(
                            label: 'Gst Certificate',
                            maxWidth: double.infinity,
                            selectText: 'Select a file',
                            helperText:
                                'JPG, PNG or PDF, file size no more than 10MB',
                            selectedFileName: state.gstCertificate,
                            onTap: () => _pickFile(_cubit.setGstCertificate),
                          ),
                          const SizedBox(height: 16),

                          // ── PAN Card ───────────────────────
                          AppFileUploadField(
                            label: 'Pan Card',
                            maxWidth: double.infinity,
                            selectText: 'Select a file',
                            helperText:
                                'JPG, PNG or PDF, file size no more than 10MB',
                            selectedFileName: state.panCard,
                            onTap: () => _pickFile(_cubit.setPanCard),
                          ),
                          const SizedBox(height: 16),

                          // ── Business Registration ──────────
                          AppFileUploadField(
                            label: 'Business Registration',
                            maxWidth: double.infinity,
                            selectText: 'Select a file',
                            helperText:
                                'JPG, PNG or PDF, file size no more than 10MB',
                            selectedFileName: state.businessRegistration,
                            onTap: () =>
                                _pickFile(_cubit.setBusinessRegistration),
                          ),
                          const SizedBox(height: 16),

                          // ── Cancelled Cheque ───────────────
                          AppFileUploadField(
                            label: 'Cancelled Cheque',
                            maxWidth: double.infinity,
                            selectText: 'Select a file',
                            helperText:
                                'JPG, PNG or PDF, file size no more than 10MB',
                            selectedFileName: state.cancelledCheque,
                            onTap: () => _pickFile(_cubit.setCancelledCheque),
                          ),

                          // ── Continue button ────────────────
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: AppContinueButton(
                              text: 'Continue',
                              showArrow: false,
                              isLoading: state.isLoading,
                              onPressed: _handleContinue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
