import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Reusable product card widget for displaying product information with image, title, RFQ number
class AppProductCard extends StatelessWidget {
  // Path to the product image (can be asset path or network URL)
  final String imagePath;

  // Product title/name
  final String title;

  // RFQ/Reference number
  final String rfqNumber;

  // Product price (will be displayed with "Rs." prefix)
  final String price;

  // Status badge text (e.g., "New", "Open", "Closed")
  final String statusText;

  // Status badge background color
  final Color statusBackgroundColor;

  // Status badge text color
  final Color statusTextColor;

  // Whether the image is from network or assets (default: false for assets)
  final bool isNetworkImage;

  // Callback when the card is tapped
  final VoidCallback? onTap;

  // Maximum width of the card (default: 327)
  final double maxWidth;

  // Height of the card (default: 103)
  final double height;

  // Vertical offset for the status badge
  final double statusBadgeOffsetY;

  const AppProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.rfqNumber,
    required this.price,
    required this.statusText,
    this.statusBackgroundColor = const Color(0xFFD3F3E1),
    this.statusTextColor = const Color(0xFF217552),
    this.isNetworkImage = false,
    this.onTap,
    this.maxWidth = 327,
    this.height = 103,
    this.statusBadgeOffsetY = 0,
  });

  // Factory constructor for "New" status
  factory AppProductCard.newStatus({
    required String imagePath,
    required String title,
    required String rfqNumber,
    required String price,
    bool isNetworkImage = false,
    VoidCallback? onTap,
    double maxWidth = 327,
    double height = 103,
  }) {
    return AppProductCard(
      imagePath: imagePath,
      title: title,
      rfqNumber: rfqNumber,
      price: price,
      statusText: 'New',
      statusBackgroundColor: const Color(0xFFD3F3E1),
      statusTextColor: const Color(0xFF217552),
      isNetworkImage: isNetworkImage,
      onTap: onTap,
      maxWidth: maxWidth,
      height: height,
    );
  }

  // Factory constructor for "Open" status
  factory AppProductCard.openStatus({
    required String imagePath,
    required String title,
    required String rfqNumber,
    required String price,
    bool isNetworkImage = false,
    VoidCallback? onTap,
    double maxWidth = 327,
    double height = 103,
  }) {
    return AppProductCard(
      imagePath: imagePath,
      title: title,
      rfqNumber: rfqNumber,
      price: price,
      statusText: 'Open',
      statusBackgroundColor: const Color(0xFFC3E1FE),
      statusTextColor: const Color(0xFF113CF5),
      isNetworkImage: isNetworkImage,
      onTap: onTap,
      maxWidth: maxWidth,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: maxWidth,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
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
                  // Title and Status Badge Row
                  Row(
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            height: 22 / 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.18,
                            color: const Color(0xFF202020),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Status Badge
                      Transform.translate(
                        offset: Offset(0, statusBadgeOffsetY),
                        child: Container(
                          height: 22,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusBackgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              statusText,
                              textAlign: TextAlign.center,
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // RFQ Number
                  Text(
                    rfqNumber,
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

                  // Price
                  Text(
                    'Rs. $price',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      height: 16 / 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder widget when image fails to load
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
