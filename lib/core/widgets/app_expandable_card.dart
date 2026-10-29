import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable expandable card widget with image, title, ID, price, status badge and arrow
/// Used for lists where items can be expanded or navigated
class AppExpandableCard extends StatelessWidget {
  /// Path to the product/item image
  final String imagePath;

  /// Title text (e.g., "Solar Trade")
  final String title;

  /// ID/Reference number (e.g., "#MB12345")
  final String idNumber;

  /// Price (will be displayed with "Rs." prefix)
  final String price;

  /// Status badge text (e.g., "In Stock", "Out of Stock")
  final String statusText;

  /// Status badge background color
  final Color statusBackgroundColor;

  /// Status badge text color
  final Color statusTextColor;

  /// Whether the image is from network or assets
  final bool isNetworkImage;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Maximum width of the card (default: 327)
  final double maxWidth;

  /// Height of the card (default: 103)
  final double height;

  /// Whether to show the arrow icon (default: true)
  final bool showArrow;

  const AppExpandableCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.idNumber,
    required this.price,
    required this.statusText,
    this.statusBackgroundColor = const Color(0xFFD3F3E1),
    this.statusTextColor = const Color(0xFF217552),
    this.isNetworkImage = false,
    this.onTap,
    this.maxWidth = 327,
    this.height = 103,
    this.showArrow = true,
  });

  double? get _statusBadgeWidth {
    switch (statusText.trim().toLowerCase()) {
      case 'new':
        return 44;
      case 'open':
      case 'dispatched':
        return 75;
      case 'approved':
        return 66;
      case 'reject':
      case 'rejected':
        return 62;
      case 'pending':
        return 58;
      default:
        return null;
    }
  }

  /// Factory constructor for "In Stock" status
  factory AppExpandableCard.inStock({
    required String imagePath,
    required String title,
    required String idNumber,
    required String price,
    bool isNetworkImage = false,
    VoidCallback? onTap,
    double maxWidth = 327,
    double height = 103,
    bool showArrow = true,
  }) {
    return AppExpandableCard(
      imagePath: imagePath,
      title: title,
      idNumber: idNumber,
      price: price,
      statusText: 'In Stock',
      statusBackgroundColor: const Color(0xFFD3F3E1),
      statusTextColor: const Color(0xFF217552),
      isNetworkImage: isNetworkImage,
      onTap: onTap,
      maxWidth: maxWidth,
      height: height,
      showArrow: showArrow,
    );
  }

  /// Factory constructor for "Out of Stock" status
  factory AppExpandableCard.outOfStock({
    required String imagePath,
    required String title,
    required String idNumber,
    required String price,
    bool isNetworkImage = false,
    VoidCallback? onTap,
    double maxWidth = 327,
    double height = 103,
    bool showArrow = true,
  }) {
    return AppExpandableCard(
      imagePath: imagePath,
      title: title,
      idNumber: idNumber,
      price: price,
      statusText: 'Out of Stock',
      statusBackgroundColor: const Color(0xFFFFE5E5),
      statusTextColor: const Color(0xFFD32F2F),
      isNetworkImage: isNetworkImage,
      onTap: onTap,
      maxWidth: maxWidth,
      height: height,
      showArrow: showArrow,
    );
  }

  /// Factory constructor for "Low Stock" status
  factory AppExpandableCard.lowStock({
    required String imagePath,
    required String title,
    required String idNumber,
    required String price,
    bool isNetworkImage = false,
    VoidCallback? onTap,
    double maxWidth = 327,
    double height = 103,
    bool showArrow = true,
  }) {
    return AppExpandableCard(
      imagePath: imagePath,
      title: title,
      idNumber: idNumber,
      price: price,
      statusText: 'Low Stock',
      statusBackgroundColor: const Color(0xFFFFF3E0),
      statusTextColor: const Color(0xFFFF6F00),
      isNetworkImage: isNetworkImage,
      onTap: onTap,
      maxWidth: maxWidth,
      height: height,
      showArrow: showArrow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: maxWidth,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 81,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              clipBehavior: Clip.antiAlias,
              child: isNetworkImage
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    ),
            ),
            const SizedBox(width: 15),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      height: 22 / 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.18,
                      color: const Color(0xFF202020),
                    ),
                  ),
                  const SizedBox(height: 3),

                  // ID Number
                  Text(
                    idNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 9,
                      height: 16 / 9,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 1),

                  // Price and Status Row
                  Row(
                    children: [
                      // Price
                      Text(
                        'Rs. $price',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 10,
                          height: 16 / 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      const Spacer(),

                      // Status Badge
                      Container(
                        width: _statusBadgeWidth,
                        height: 22,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: statusBackgroundColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            statusText,
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              height: 18 / 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.14,
                              color: statusTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            if (showArrow) ...[
              const SizedBox(width: 8),
              Transform.rotate(
                angle: -1.5708, // -90 degrees in radians (arrow pointing right)
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF202020),
                  size: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Placeholder widget when image fails to load
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
