/// FILE UPLOAD WIDGET USAGE EXAMPLES
/// 
/// This file demonstrates how to use the AppFileUploadField widget
/// DO NOT import this file - it's just for reference!
library;

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/core/widgets/app_file_upload_field.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';

/// Example 1: Basic File Upload (PDF, Images, etc.)
class BasicFileUploadExample extends StatefulWidget {
  const BasicFileUploadExample({super.key});

  @override
  State<BasicFileUploadExample> createState() => _BasicFileUploadExampleState();
}

class _BasicFileUploadExampleState extends State<BasicFileUploadExample> {
  String? selectedFileName;

  Future<void> _pickFile() async {
    try {
      // Pick files using file_picker package
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppFileUploadField(
              label: 'Gst Certificate',
              onTap: _pickFile,
              selectedFileName: selectedFileName,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 2: Multiple File Upload Fields
class MultipleFileUploadExample extends StatefulWidget {
  const MultipleFileUploadExample({super.key});

  @override
  State<MultipleFileUploadExample> createState() =>
      _MultipleFileUploadExampleState();
}

class _MultipleFileUploadExampleState extends State<MultipleFileUploadExample> {
  String? gstCertificate;
  String? panCard;
  String? addressProof;

  Future<void> _pickFile(Function(String) onSelected) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          onSelected(result.files.single.name);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Upload Documents'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppFileUploadField(
                      label: 'Gst Certificate',
                      onTap: () => _pickFile((name) => gstCertificate = name),
                      selectedFileName: gstCertificate,
                    ),
                    const SizedBox(height: 24),
                    AppFileUploadField(
                      label: 'Pan Card',
                      onTap: () => _pickFile((name) => panCard = name),
                      selectedFileName: panCard,
                    ),
                    const SizedBox(height: 24),
                    AppFileUploadField(
                      label: 'Address Proof',
                      onTap: () => _pickFile((name) => addressProof = name),
                      selectedFileName: addressProof,
                    ),
                    const SizedBox(height: 32),
                    AppContinueButton(
                      text: 'Upload Documents',
                      onPressed: () {
                        // Handle upload
                      },
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

/// Example 3: Image Only Upload
class ImageUploadExample extends StatefulWidget {
  const ImageUploadExample({super.key});

  @override
  State<ImageUploadExample> createState() => _ImageUploadExampleState();
}

class _ImageUploadExampleState extends State<ImageUploadExample> {
  String? profileImage;

  Future<void> _pickImage() async {
    try {
      // Show dialog to choose camera or gallery
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );

      if (source != null) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: source);

        if (image != null) {
          setState(() {
            profileImage = image.name;
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppFileUploadField(
              label: 'Profile Photo',
              selectText: 'Choose a photo',
              helperText: 'JPG or PNG, file size no more than 5MB',
              onTap: _pickImage,
              selectedFileName: profileImage,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 4: Custom File Types and Size Limits
class CustomFileUploadExample extends StatefulWidget {
  const CustomFileUploadExample({super.key});

  @override
  State<CustomFileUploadExample> createState() =>
      _CustomFileUploadExampleState();
}

class _CustomFileUploadExampleState extends State<CustomFileUploadExample> {
  String? selectedFile;

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'pdf'],
      );

      if (result != null) {
        final file = result.files.single;
        
        // Check file size (20MB limit)
        if (file.size > 20 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size must be less than 20MB'),
            ),
          );
          return;
        }

        setState(() {
          selectedFile = file.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppFileUploadField(
              label: 'Business License',
              selectText: 'Upload document',
              helperText: 'DOC, DOCX or PDF, file size no more than 20MB',
              onTap: _pickDocument,
              selectedFileName: selectedFile,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 5: Complete Form with File Upload
class CompleteFormWithFileUpload extends StatefulWidget {
  const CompleteFormWithFileUpload({super.key});

  @override
  State<CompleteFormWithFileUpload> createState() =>
      _CompleteFormWithFileUploadState();
}

class _CompleteFormWithFileUploadState
    extends State<CompleteFormWithFileUpload> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String? gstCertificate;
  String? panCard;
  bool isLoading = false;

  Future<void> _pickFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          if (type == 'gst') {
            gstCertificate = result.files.single.name;
          } else if (type == 'pan') {
            panCard = result.files.single.name;
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> _submitForm() async {
    if (gstCertificate == null || panCard == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulate upload
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documents uploaded successfully!'),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppHeader(title: 'Business Registration'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Text fields would go here
                    // AppTextField(...),
                    
                    const SizedBox(height: 24),
                    
                    AppFileUploadField(
                      label: 'Gst Certificate',
                      onTap: () => _pickFile('gst'),
                      selectedFileName: gstCertificate,
                    ),
                    const SizedBox(height: 24),
                    
                    AppFileUploadField(
                      label: 'Pan Card',
                      onTap: () => _pickFile('pan'),
                      selectedFileName: panCard,
                    ),
                    const SizedBox(height: 32),
                    
                    AppContinueButton(
                      text: 'Submit',
                      onPressed: _submitForm,
                      isLoading: isLoading,
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

/// Example 6: With Validation
class FileUploadWithValidation extends StatefulWidget {
  const FileUploadWithValidation({super.key});

  @override
  State<FileUploadWithValidation> createState() =>
      _FileUploadWithValidationState();
}

class _FileUploadWithValidationState extends State<FileUploadWithValidation> {
  String? selectedFile;
  String? errorMessage;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null) {
        final file = result.files.single;
        
        // Validate file size (10MB)
        if (file.size > 10 * 1024 * 1024) {
          setState(() {
            errorMessage = 'File size must be less than 10MB';
            selectedFile = null;
          });
          return;
        }

        // Validate file type
        final extension = file.extension?.toLowerCase();
        if (extension != 'jpg' && extension != 'png' && extension != 'pdf') {
          setState(() {
            errorMessage = 'Please select JPG, PNG or PDF file';
            selectedFile = null;
          });
          return;
        }

        setState(() {
          selectedFile = file.name;
          errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error selecting file';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppFileUploadField(
              label: 'Document Upload',
              onTap: _pickFile,
              selectedFileName: selectedFile,
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/*
IMPORTANT NOTES:

1. Add these packages to pubspec.yaml:
   dependencies:
     file_picker: ^6.0.0
     image_picker: ^1.0.0

2. For iOS, add to Info.plist:
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need access to select photos</string>
   <key>NSCameraUsageDescription</key>
   <string>We need access to take photos</string>

3. For Android, add to AndroidManifest.xml:
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.CAMERA"/>
*/
