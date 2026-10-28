import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/addtender_rfq_request.dart';

/// Reusable RFQ request list card used in [AddTenderRfqRequestsScreen].
///
/// Shows: supplier avatar icon | name + date + amount | status badge + chevron
///
/// Usage:
/// ```dart
/// AddTenderRfqRequestCard(
///   request: rfqRequest,
///   onTap: () { ... },
/// );
/// ```
class AddTenderRfqRequestCard extends StatelessWidget {
  final AddTenderRfqRequest request;
  final VoidCallback? onTap;

  const AddTenderRfqRequestCard({
    super.key,
    required this.request,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Supplier avatar ───────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: Color(0xFF003A8A),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // ── Name + date + amount ──────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.supplierName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.amount,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF003A8A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.dateLabel,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Status badge + chevron ─────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF6C7278),
                  size: 20,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: request.status.bgColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    request.status.label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: request.status.textColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
