import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/features/plan/presentation/cubit/plan_selection_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  final PlanSelectionCubit _planSelectionCubit = PlanSelectionCubit();

  @override
  void dispose() {
    _planSelectionCubit.close();
    super.dispose();
  }

  static const List<String> _features = [
    'Access to RFQs',
    'Compare Products',
    'Place Orders',
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<PlanSelectionCubit, PlanType>(
      bloc: _planSelectionCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
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
                  scaleX: 10 / 9,
                  scaleY: 4 / 3,
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'assets/images/solar_panels_plan_background.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.8,
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x1AFFFFFF),
                          Color(0x1AFFFFFF),
                          Color(0x99FFFFFF),
                          Color(0xFAFFFFFF),
                          Color(0xFAFFFFFF),
                          Colors.white,
                        ],
                        stops: [0, 0.35, 0.58, 0.78, 0.9, 1],
                      ),
                    ),
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 171,
                                        left: 21,
                                        right: 46,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (
                                            var index = 0;
                                            index < _features.length;
                                            index++
                                          )
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom:
                                                    index < _features.length - 1
                                                    ? 15
                                                    : 0,
                                              ),
                                              child: _FeatureRow(
                                                label: _features[index],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 26),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 19,
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 160,
                                            height: 142,
                                            child: _PlanCard(
                                              tag: '3-Day Free Trial',
                                              price: 'Rs: 1,299/-',
                                              period: 'Month',
                                              saveBadge: null,
                                              isTrial: true,
                                              isSelected:
                                                  state == PlanType.trial,
                                              onTap: () => _planSelectionCubit
                                                  .select(PlanType.trial),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _PlanCard(
                                              tag: 'Yearly Access',
                                              price: 'Rs: 12,999/-',
                                              period: 'Year',
                                              saveBadge: 'Save Rs: 2589/-',
                                              isTrial: false,
                                              isSelected:
                                                  state == PlanType.yearly,
                                              onTap: () => _planSelectionCubit
                                                  .select(PlanType.yearly),
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
                          const SizedBox(height: 32),
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
                                    context.go(AppRoutes.vendorMain);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 31),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              100,
                              0,
                              100,
                              bottom + 33,
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          context.push(AppRoutes.vendorTerms),
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
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String label;
  const _FeatureRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/ic_plan_checkbox.svg',
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF003A8A),
                  BlendMode.srcIn,
                ),
              ),
              SvgPicture.asset(
                'assets/icons/ic_plan_feature_check.svg',
                width: 15,
                height: 14.2,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF003A8A),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: 0,
            color: const Color(0xFF080D18),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String tag;
  final String price;
  final String period;
  final String? saveBadge;
  final bool isTrial;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.tag,
    required this.price,
    required this.period,
    required this.saveBadge,
    required this.isTrial,
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
          borderRadius: BorderRadius.circular(isTrial ? 20 : 17),
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
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0,
                      color: const Color(0xFF0F172A),
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
                            'assets/icons/ic_plan_checkbox.svg',
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
                            'assets/icons/ic_plan_feature_check.svg',
                            width: 15,
                            height: 14.2,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF003A8A),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: isTrial ? 0 : 12),

            // Price
            Text(
              price,
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0,
                color: const Color(0xFF0F172A),
              ),
            ),

            // Save badge (yearly only)
            if (saveBadge != null) ...[
              SizedBox(height: isTrial ? 15 : 6),
              Container(
                width: 121,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x14080D18),
                  borderRadius: BorderRadius.circular(37),
                ),
                child: Text(
                  saveBadge!,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: 0,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],

            SizedBox(height: isTrial ? 53 : 6),

            // Period label
            Text(
              period,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
