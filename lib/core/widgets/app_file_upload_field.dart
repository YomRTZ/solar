import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/validation/app_form_validation.dart';

// Reusable file upload field widget with dashed border and file picker
class AppFileUploadField extends StatelessWidget {
  // The label text displayed above the upload field
  final String label;

  // The main text shown inside the upload area (default: "Select a file")
  final String selectText;

  // The helper text showing allowed formats and size limit
  final String helperText;

  // Callback function when the upload area is tapped
  final VoidCallback onTap;

  // Optional: Currently selected file name to display
  final String? selectedFileName;

  // Maximum width for the component (default: 327)
  final double maxWidth;

  // Height of the upload area (default: 53)
  final double uploadHeight;

  const AppFileUploadField({
    super.key,
    required this.label,
    required this.onTap,
    this.selectText = 'Select a file',
    this.helperText = 'JPG, PNG or PDF, file size no more than 10MB',
    this.selectedFileName,
    this.maxWidth = 318,
    this.uploadHeight = 53,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: ValueKey('$label:$selectedFileName'),
      initialValue: selectedFileName,
      validator: (_) =>
          AppFormValidation.requiredText(selectedFileName, fieldName: label),
      builder: (field) {
        final hasError = field.errorText != null;
        return SizedBox(
          width: maxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 21,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.24,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: uploadHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomPaint(
                    painter: DashedBorderPainter(
                      color: hasError
                          ? AppFormValidation.errorColor
                          : const Color(0x40000000),
                      strokeWidth: 1,
                      dashWidth: 4,
                      dashSpace: 4,
                      borderRadius: 10,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 14,
                          left: 21,
                          child: SvgPicture.asset(
                            'assets/icons/ic_upload_cloud.svg',
                            width: 26,
                            height: 26,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 60,
                          right: 47,
                          top: 8,
                          bottom: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedFileName ?? selectText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  height: 1.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                helperText,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  fontSize: 9,
                                  height: 1.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0,
                                  color: const Color(0x66000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (field.errorText != null) AppFormErrorText(field.errorText!),
            ],
          ),
        );
      },
    );
  }
}

class AppProfilePhotoUploadField extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? fileName;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const AppProfilePhotoUploadField({
    super.key,
    required this.imageBytes,
    required this.fileName,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<Uint8List>(
      key: ValueKey('Profile Photo:$fileName:${imageBytes?.length}'),
      initialValue: imageBytes,
      validator: (value) => value == null
          ? AppFormValidation.requiredText(null, fieldName: 'Profile Photo')
          : null,
      builder: (field) {
        final hasImage = imageBytes != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Photo',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.6,
                letterSpacing: -0.24,
                color: const Color(0xFF6C7278),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: CustomPaint(
                  painter: DashedBorderPainter(
                    color: field.errorText == null
                        ? const Color(0x40000000)
                        : AppFormValidation.errorColor,
                    strokeWidth: 1,
                    dashWidth: 4,
                    dashSpace: 4,
                    borderRadius: 9,
                  ),
                  child: hasImage
                      ? _buildUploadedImage()
                      : _buildUploadPrompt(),
                ),
              ),
            ),
            if (field.errorText != null) AppFormErrorText(field.errorText!),
          ],
        );
      },
    );
  }

  Widget _buildUploadPrompt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_upload_cloud.svg',
            width: 23,
            height: 23,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload image',
                style: GoogleFonts.roboto(fontSize: 12, color: Colors.black),
              ),
              Text(
                'JPG, PNG file size no more than 10MB',
                style: GoogleFonts.roboto(
                  fontSize: 9,
                  color: const Color(0x66000000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedImage() {
    final bytes = imageBytes!;
    final sizeInKb = (bytes.length / 1024).ceil().clamp(1, 1 << 30);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          ClipOval(
            child: Image.memory(
              bytes,
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName ?? 'Profile photo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(fontSize: 11, color: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      '$sizeInKb KB of $sizeInKb KB',
                      style: GoogleFonts.roboto(
                        fontSize: 8,
                        color: const Color(0xFF9098A0),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.check_circle,
                      size: 10,
                      color: Color(0xFF2DBE87),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Uploaded',
                      style: GoogleFonts.roboto(
                        fontSize: 8,
                        color: const Color(0xFF555D63),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 32),
            color: const Color(0xFF626A70),
            tooltip: 'Remove profile photo',
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final dashedPath = Path();
    final metrics = source.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        final end = distance + length;

        if (end > metric.length) {
          if (draw) {
            dashedPath.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }

        if (draw) {
          dashedPath.addPath(metric.extractPath(distance, end), Offset.zero);
        }

        distance = end;
        draw = !draw;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
