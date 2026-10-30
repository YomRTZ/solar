import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenderPriceBadge extends StatelessWidget {
  final String price;

  const TenderPriceBadge({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0xFF375DFB), blurRadius: 0, spreadRadius: 1),
          BoxShadow(
            color: Color(0x7A253EA7),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Color(0xFF003A8A)),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
                  ),
                ),
              ),
              Center(
                child: Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xFFFFFFFF),
                    height: 1.3,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
