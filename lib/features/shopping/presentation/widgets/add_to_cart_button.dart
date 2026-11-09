import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? buttonWidth;
  final double buttonHeight;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry padding;

  const AddToCartButton({
    super.key,
    required this.onPressed,
    this.buttonWidth,
    this.buttonHeight = 30,
    this.borderRadius = 10,
    this.borderWidth = 1,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            buttonWidth ??
            (constraints.maxWidth.isFinite
                ? constraints.maxWidth.clamp(0.0, 135.0).toDouble()
                : 135.0);

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: width,
            height: buttonHeight,
            padding: padding,
            decoration: BoxDecoration(
              color: const Color(0xFF003A8A),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: const Color(0x1FFFFFFF),
                width: borderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF375DFB),
                  blurRadius: 0,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Color(0x7A253EA7),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Add to RFQ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      height: 1.3,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
