import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable file upload field widget with dashed border and file picker
/// Used for document/image uploads across multiple screens
class AppFileUploadField extends StatelessWidget {
  /// The label text displayed above the upload field
  final String label;
  
  /// The main text shown inside the upload area (default: "Select a file")
  final String selectText;
  
  /// The helper text showing allowed formats and size limit
  /// Example: "JPG, PNG or PDF, file size no more than 10MB"
  final String helperText;
  
  /// Callback function when the upload area is tapped
  final VoidCallback onTap;
  
  /// Optional: Currently selected file name to display
  final String? selectedFileName;
  
  /// Maximum width for the component (default: 327)
  final double maxWidth;
  
  /// Height of the upload area (default: 53)
  final double uploadHeight;

  const AppFileUploadField({
    super.key,
    required this.label,
    required this.onTap,
    this.selectText = 'Select a file',
    this.helperText = 'JPG, PNG or PDF, file size no more than 10MB',
    this.selectedFileName,
    this.maxWidth = 327,
    this.uploadHeight = 53,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label section
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
          const SizedBox(height: 6),
          
          // Upload area with dashed border
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: uploadHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0x40000000), // #00000040
                  width: 1,
                ),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: const Color(0x40000000),
                  strokeWidth: 1,
                  dashWidth: 4,
                  dashSpace: 4,
                  borderRadius: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Upload icon
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0x66000000), // #00000066
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          size: 16,
                          color: Color(0x66000000),
                        ),
                      ),
                      const SizedBox(width: 13),
                      
                      // Text section
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Select file text or selected file name
                            Text(
                              selectedFileName ?? selectText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                height: 1.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                                color: selectedFileName != null
                                    ? const Color(0xFF000000)
                                    : const Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(height: 3),
                            
                            // Helper text (format and size limit)
                            Text(
                              helperText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 9,
                                height: 1.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                                color: const Color(0x66000000), // #00000066
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
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw dashed border
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
          dashedPath.addPath(
            metric.extractPath(distance, end),
            Offset.zero,
          );
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
