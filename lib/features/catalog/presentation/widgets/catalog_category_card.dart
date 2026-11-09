import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Reusable square category card used in the Vendor screens
class CatalogCategoryCard extends StatelessWidget {
  // Asset path for the category icon image.
  final String iconPath;

  // Label shown below the icon.
  final String label;

  // Called when the card is tapped.
  final VoidCallback? onTap;

  // Whether the icon image is from the network (default: false).
  final bool isNetworkImage;

  // Size of the icon (default: 56).
  final double iconContainerSize;
  final double? imageWidth;
  final double? imageHeight;

  // Total card width (default: unconstrained — fills parent).
  final double? width;

  // Total card height (default: sized to its contents).
  final double? height;

  // Whether this is the compact Vendor home-screen tile.
  final bool compact;

  // Draws only horizontal edges instead of a full rectangular frame.
  final bool horizontalBordersOnly;

  const CatalogCategoryCard({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
    this.isNetworkImage = false,
    this.iconContainerSize = 56,
    this.imageWidth,
    this.imageHeight,
    this.width,
    this.height,
    this.compact = false,
    this.horizontalBordersOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = compact
        ? const Color(0xFFC6C6C6)
        : const Color(0xFFC0C5C8);
    const horizontalBorder = BorderSide(color: Color(0xFFEDF1F3), width: 1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(compact ? 4 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: horizontalBordersOnly
              ? Border(top: horizontalBorder, bottom: horizontalBorder)
              : Border.all(color: borderColor, width: compact ? 0.5 : 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (compact) ...[
              const Spacer(),
              SizedBox(
                width: iconContainerSize,
                height: iconContainerSize,
                child: _buildImage(),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _buildLabel(),
              ),
              const Spacer(),
            ] else ...[
              const SizedBox(height: 7),
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: SizedBox(
                    width: imageWidth ?? iconContainerSize,
                    height: imageHeight ?? iconContainerSize,
                    child: _buildImage(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFFEFEFEF),
              ),
              SizedBox(
                height: 36,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(child: _buildLabel()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      label,
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: compact
          ? GoogleFonts.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: const Color(0xFF23201C),
              height: 1.3,
              letterSpacing: 0,
            )
          : GoogleFonts.roboto(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: const Color(0xFF23201C),
              height: 1,
              letterSpacing: 0,
            ),
    );
  }

  Widget _buildImage() {
    if (!isNetworkImage && iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(iconPath, fit: BoxFit.contain);
    }

    return isNetworkImage
        ? Image.network(
            iconPath,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, st) => _placeholder(),
          )
        : Image.asset(
            iconPath,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, st) => _placeholder(),
          );
  }

  Widget _placeholder() =>
      const Icon(Icons.category_outlined, color: Color(0xFF003A8A), size: 28);
}
