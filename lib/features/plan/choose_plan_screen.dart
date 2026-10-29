import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_continue_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddTender — Choose a Plan Screen
//
// Layout:
//  • White background with back arrow at top
//  • "Choose a Plan" large title
//  • Solar image banner with rounded corners
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
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: top + 8),

            // ── Back arrow ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF1A1A1A),
                  size: 22,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Title ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Choose a Plan',
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0A1F44),
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ── Solar image banner ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/solarimages/8c95b22c561eba1d7752be96d662579cfd873d93.jpg',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, e, s) => Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF003A8A), Color(0xFF001A4D)],
                      ),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: Colors.amber,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ── Feature checklist ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _features
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FeatureRow(label: f),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ── Plan cards ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _PlanCard(
                      tag: '3-Day Free Trial',
                      price: 'Rs: 1,299/-',
                      period: 'Month',
                      saveBadge: null,
                      isSelected: _selected == _PlanType.trial,
                      onTap: () => setState(() => _selected = _PlanType.trial),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PlanCard(
                      tag: 'Yearly Access',
                      price: 'Rs: 12,999/-',
                      period: 'Year',
                      saveBadge: 'Save Rs: 2589/-',
                      isSelected: _selected == _PlanType.yearly,
                      onTap: () => setState(() => _selected = _PlanType.yearly),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Continue button ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppContinueButton(
                text: 'Continue',
                showArrow: false,
                onPressed: () {
                  context.go(AppRoutes.tenderMain);
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── Footer links ────────────────────────────────
            Padding(
              padding: EdgeInsets.only(bottom: bottom + 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.addTenderTerms),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFF003A8A),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1A1A),
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
          color: isSelected ? const Color(0xFFEEF4FF) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003A8A)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
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
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Checkbox indicator
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF003A8A)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF003A8A)
                          : const Color(0xFFD1D5DB),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 12,
                        )
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Price
            Text(
              price,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0A1F44),
                letterSpacing: -0.3,
              ),
            ),

            // Save badge (yearly only)
            if (saveBadge != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF003A8A),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  saveBadge!,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 6),

            // Period label
            Text(
              period,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6C7278),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
