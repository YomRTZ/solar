import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';

class TransporterTripVerifiedScreen extends StatelessWidget {
  final TransporterTrip trip;

  const TransporterTripVerifiedScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SecondAppHeader(title: 'Trip Verified', showBackButton: false),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/solarimages/Map.png',
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        left: width * 0.5,
                        top: height * 0.08,
                        width: width * 0.21,
                        height: height * 0.39,
                        child: Image.asset(
                          'assets/solarimages/Line.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        left: width * 0.51,
                        top: height * 0.028,
                        width: width * 0.07,
                        height: height * 0.056,
                        child: SvgPicture.asset(
                          'assets/icons/ic_Track.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        left: width * 0.67,
                        top: height * 0.437,
                        width: width * 0.07,
                        height: height * 0.056,
                        child: SvgPicture.asset(
                          'assets/icons/ic_Track.svg',
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF003A8A),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 9,
                        height: 34,
                        child: GestureDetector(
                          onTap: () => _showMapMessage(
                            context,
                            'Map directions are not available yet.',
                          ),
                          child: Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x1EFFFFFF),
                                  Color(0x00FFFFFF),
                                ],
                              ),
                              color: const Color(0xFF003A8A),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF375DFB),
                                  offset: Offset(0, 0),
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  color: Color(0x7A253EA7),
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFF375DFB),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Open on maps',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 30,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => context.push(
                            AppRoutes.transporterDeliveryVerify,
                            extra: trip,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003A8A),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Text(
                            'Start Navigation',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMapMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
