import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Reusable catalog product card — 156×217px
class AppCatalogCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String subtitle;
  final String price;

  // Current quantity in RFQ (0 = not added)
  final int quantity;

  // Called when "Add to RFQ" is tapped (quantity == 0)
  final VoidCallback onAdd;

  // Called when + is tapped (quantity > 0)
  final VoidCallback onIncrement;

  // Called when delete/− is tapped (quantity > 0)
  final VoidCallback onDecrement;

  // Whether image comes from network
  final bool isNetworkImage;

  const AppCatalogCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    this.isNetworkImage = false,
  });

  static const BoxDecoration _btnDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF003A8A), Color(0xFF003A8A)],
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Color(0x7A253EA7),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0xFF375DFB),
        spreadRadius: 0,
        blurRadius: 0,
        offset: Offset(0, 0),
      ),
    ],
  );

  static const TextStyle _btnTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 217,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFC0C5C8),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          children: [
            _buildImage(),

            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 156,
      height: 97,
      child: isNetworkImage
          ? Image.network(imagePath, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _imgPlaceholder())
          : Image.asset(imagePath, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _imgPlaceholder()),
    );
  }

  Widget _imgPlaceholder() => Container(
        color: const Color(0xFFE8F4FD),
        child: const Icon(Icons.image_outlined, color: Colors.grey, size: 32),
      );

  Widget _buildContent() {
    return Container(
      width: 156,
      height: 120,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEFEFEF), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 136,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF23201C),
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle / spec
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'GeneralSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF23201C),
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF003A8A).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              price,
              style: GoogleFonts.roboto(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF003A8A),
              ),
            ),
          ),
          const Spacer(),

          quantity == 0 ? _buildAddButton() : _buildQtyRow(),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        height: 20,
        decoration: _btnDecoration,
        child: const Center(
          child: Text('Add to RFQ', style: _btnTextStyle),
        ),
      ),
    );
  }

  Widget _buildQtyRow() {
    return Container(
      height: 30,
      decoration: _btnDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Delete / decrement
          GestureDetector(
            onTap: onDecrement,
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),

          // Count
          Text(
            '$quantity',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          // Increment
          GestureDetector(
            onTap: onIncrement,
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
