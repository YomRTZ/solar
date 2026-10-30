import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenderAddToRfqButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TenderAddToRfqButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(0.0, 135.0).toDouble()
            : 135.0;

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            width: width,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF003A8A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x1FFFFFFF), width: 1),
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
              borderRadius: BorderRadius.circular(9),
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
