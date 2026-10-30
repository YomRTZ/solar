import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_continue_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddTender — Choose a Plan Screen
//
// Layout:
//  • Responsive photo background with a lower white fade
//  • Shared header with "Choose a Plan" title
//  • Feature checklist (Access to RFQs, Compare Products, Place Orders)
//  • Two plan cards: 3-Day Free Trial (selected) | Yearly Access
//  • Continue button
//  • "Terms of use | Privacy Policy" footer links
// ─────────────────────────────────────────────────────────────────────────────
class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

enum _PlanType { trial, yearly }

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  _PlanType _selected = _PlanType.trial;

  static const List<String> _features = [
    'Access to RFQs',
    'Compare Products',
    'Place Orders',
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            ClipRect(
              child: Transform.scale(
                scale: 1.15,
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/photo_5979016740496674897_y.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x26FFFFFF),
                    Color(0x00FFFFFF),
                    Color(0x00FFFFFF),
                    Color(0x99FFFFFF),
                    Color(0xFAFFFFFF),
                    Colors.white,
                  ],
                  stops: [0, 0.2, 0.36, 0.62, 0.82, 1],
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppHeader(
                          title: 'Choose a Plan',
                          onBackPressed: () => Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Transform.translate(
                            offset: const Offset(0, 20),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _features
                                          .map(
                                            (feature) => Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              child: _FeatureRow(
                                                label: feature,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _PlanCard(
                                            tag: '3-Day Free Trial',
                                            price: 'Rs: 1,299/-',
                                            period: 'Month',
                                            saveBadge: null,
                                            isSelected:
                                                _selected == _PlanType.trial,
                                            onTap: () => setState(
                                              () => _selected = _PlanType.trial,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _PlanCard(
                                            tag: 'Yearly Access',
                                            price: 'Rs: 12,999/-',
                                            period: 'Year',
                                            saveBadge: 'Save Rs: 2589/-',
                                            isSelected:
                                                _selected == _PlanType.yearly,
                                            onTap: () => setState(
                                              () =>
                                                  _selected = _PlanType.yearly,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF2456A5),
                                    Color(0xFF103D83),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(0xFF2D66F5),
                                  width: 1.5,
                                ),
                              ),
                              child: AppContinueButton(
                                text: 'Continue',
                                showArrow: false,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  context.go(AppRoutes.tenderMain);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.only(bottom: bottom + 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    context.push(AppRoutes.addTenderTerms),
                                child: Text(
                                  'Terms of use',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF003A8A),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  '|',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Privacy Policy',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF003A8A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature row — blue checkbox + label
// ─────────────────────────────────────────────────────────────────────────────
class _FeatureRow extends StatelessWidget {
  final String label;
  const _FeatureRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF003A8A), width: 1.5),
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xFF003A8A),
            size: 17,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: 0,
            color: const Color(0xFF080D18),
            shadows: const [Shadow(color: Color(0x4D8E8E8E), blurRadius: 20)],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Plan card
// ─────────────────────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final String tag;
  final String price;
  final String period;
  final String? saveBadge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.tag,
    required this.price,
    required this.period,
    required this.saveBadge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isSelected ? 0.52 : 0.62),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF172033)
                : const Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag row + checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    tag,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF080D18),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Checkbox indicator
                SizedBox(
                  width: 26,
                  height: 29,
                  child: Stack(
                    children: [
                      if (isSelected)
                        Positioned(
                          top: 4.14,
                          left: 2.77,
                          child: SvgPicture.asset(
                            'assets/icons/Vectorcheckbox.svg',
                            width: 20.60515594482422,
                            height: 20.606464385986328,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF003A8A),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      else
                        Positioned(
                          top: 4.14,
                          left: 2.77,
                          child: Container(
                            width: 20.60515594482422,
                            height: 20.606464385986328,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFFD1D5DB),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      if (isSelected)
                        Positioned(
                          top: 7.5,
                          left: 5.5,
                          child: SvgPicture.asset(
                            'assets/icons/Vectorright.svg',
                            width: 15,
                            height: 14.2,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Price
            Text(
              price,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF080D18),
              ),
            ),

            // Save badge (yearly only)
            if (saveBadge != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  saveBadge!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF172033),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 6),

            // Period label
            Text(
              period,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF080D18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
