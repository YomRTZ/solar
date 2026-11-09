import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';

// Reusable RFQ request list card used in [CatalogRfqRequestsScreen]
class CatalogRfqRequestCard extends StatelessWidget {
  final CatalogRfqRequest request;
  final String imagePath;
  final VoidCallback? onTap;

  const CatalogRfqRequestCard({
    super.key,
    required this.request,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 103,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 81,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          request.supplierName,
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
                        Text(
                          request.amount,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            height: 16 / 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          request.dateLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 9,
                            color: const Color(0xFF6C7278),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── Arrow + status badge row, pinned bottom-right ──
            // Arrow is always exactly 22 px to the left of the status badge.
            Positioned(
              right: 12,
              bottom: 22,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (request.status != CatalogRfqStatus.pending)
                    const Padding(
                      padding: EdgeInsets.only(right: 22),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF202020),
                        size: 24,
                      ),
                    ),
                  Container(
                    width: request.status == CatalogRfqStatus.received
                        ? 66
                        : 58,
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: request.status.bgColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      request.status.label,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        height: 18 / 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.14,
                        color: request.status.textColor,
                      ),
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
}
