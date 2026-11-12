import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/features/catalog/presentation/widgets/catalog_price_badge.dart';

// Reusable horizontal RFQ cart item card used in the vendor cart screen
class CartItemCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String subtitle;
  final String price;
  final int quantity;

  // Called when the delete / minus icon is tapped.
  final VoidCallback onDecrement;

  // Called when the + icon is tapped.
  final VoidCallback onIncrement;

  // Optional tap on the whole card.
  final VoidCallback? onTap;

  // Whether [imagePath] is a network URL (default: false).
  final bool isNetworkImage;

  const CartItemCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 79,
                  height: 64,
                  color: const Color(0xFFD6EAFF),
                  child: isNetworkImage
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, e, s) => _placeholder(),
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, e, s) => _placeholder(),
                        ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF23201C),
                        letterSpacing: 0,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF23201C),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CatalogPriceBadge(price: price),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              _QtyStepper(
                quantity: quantity,
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => const Center(
    child: Icon(Icons.image_outlined, color: Color(0xFF90B4D4), size: 28),
  );
}

class _QtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtyStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF003A8A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF003A8A), width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ic_delete.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFEFEFEF),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$quantity',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onIncrement,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ic_add.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFEFEFEF),
                    BlendMode.srcIn,
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
