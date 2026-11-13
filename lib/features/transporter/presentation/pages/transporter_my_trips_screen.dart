import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_app/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';
import 'package:flutter_app/features/transporter/presentation/cubit/transporter_cubit.dart';

class TransporterMyTripsScreen extends StatefulWidget {
  const TransporterMyTripsScreen({super.key});

  @override
  State<TransporterMyTripsScreen> createState() =>
      _TransporterMyTripsScreenState();
}

class _TransporterMyTripsScreenState extends State<TransporterMyTripsScreen> {
  var _selectedTab = 0;

  Future<void> _verifyTrip(TransporterTrip trip) async {
    final mobileNumber = context.read<AuthCubit>().state.mobileNumber;
    final wasVerified = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _VerifyTripSheet(mobileNumber: _formatMobileNumber(mobileNumber)),
    );
    if (wasVerified == true && mounted) {
      context.read<TransporterCubit>().verifyTrip(trip.id);
      _openTripTracker(trip);
    }
  }

  void _openTripTracker(TransporterTrip trip) {
    context.push(AppRoutes.transporterTripVerified, extra: trip);
  }

  String _formatMobileNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '+91 ${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }
    return digits.isEmpty ? 'your registered number' : '+91 $digits';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransporterCubit, TransporterState>(
      builder: (context, transporterState) {
        final trips = _selectedTab == 0
            ? transporterState.upcomingTrips
            : transporterState.pastTrips;

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
                const SecondAppHeader(title: 'My Trips'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 17, 23),

                    child: Column(
                      children: [
                        _TripTabs(
                          selectedIndex: _selectedTab,
                          onSelected: (index) => setState(() {
                            _selectedTab = index;
                          }),
                        ),
                        const SizedBox(height: 17),
                        for (final trip in trips) ...[
                          _TripCard(
                            trip: trip,
                            isVerified: transporterState.verifiedTripIds
                                .contains(trip.id),
                            onVerify: () => _verifyTrip(trip),
                            onStart: () => _openTripTracker(trip),
                          ),
                          const SizedBox(height: 9),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TripTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TripTabs({required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const labels = ['Upcoming', 'Past'];
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFF5F6F9), width: 1),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: index == selectedIndex
                        ? const Color(0xFF003A8A)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: index == selectedIndex
                        ? const [
                            BoxShadow(
                              color: Color(0x08000000),
                              offset: Offset(0, -2),
                              blurRadius: 2,
                              spreadRadius: 0,
                              blurStyle: BlurStyle.inner,
                            ),
                            BoxShadow(
                              color: Color(0x3DE4E5E7),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      labels[index],
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: index == selectedIndex
                            ? Colors.white
                            : const Color(0xFF202020),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (index < labels.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final TransporterTrip trip;
  final bool isVerified;
  final VoidCallback onVerify;
  final VoidCallback onStart;

  const _TripCard({
    required this.trip,
    required this.isVerified,
    required this.onVerify,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final job = trip.job;
    final showAction = trip.canVerify;
    final hasAddresses =
        trip.pickupAddress != null && trip.dropoffAddress != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(9.82, 11, 11, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D3D3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.route,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              Text(
                trip.relativeDate,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 0,
                  color: Color(0xFF808080),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _TripDetail(label: 'Vehicle', value: job.vehicle),
              const SizedBox(width: 18),
              _TripDetail(label: 'Weight', value: job.weight),
              const SizedBox(width: 18),
              _TripDetail(label: 'Date', value: job.date),
            ],
          ),
          if (hasAddresses) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/ic_My_Trips.png',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    trip.pickupAddress!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SvgPicture.asset(
                    'assets/icons/ic_rightsidearrow.svg',
                    width: 10,
                    height: 10,
                  ),
                ),
                Image.asset(
                  'assets/icons/ic_My_Trips.png',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    trip.dropoffAddress!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          SizedBox(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rs. ${job.price}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        letterSpacing: 0,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ),
                if (showAction)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0.79, top: 20),
                      child: _TripActionButton(
                        label: isVerified ? 'Start Trip' : 'Verify Trip',
                        onPressed: isVerified ? onStart : onVerify,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripDetail extends StatelessWidget {
  final String label;
  final String value;

  const _TripDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
              color: Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: 0,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _TripActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(6);
    return Container(
      height: 32,
      constraints: const BoxConstraints(minWidth: 90),
      decoration: BoxDecoration(
        color: const Color(0xFF003A8A),
        border: Border.all(color: const Color(0x1FFFFFFF), width: 1),
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(color: Color(0xFF375DFB), spreadRadius: 1, blurRadius: 0),
          BoxShadow(
            color: Color(0x7A253EA7),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned.fill(
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Center(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: -0.11,
                        color: Colors.white,
                      ),
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

class _VerifyTripSheet extends StatefulWidget {
  final String mobileNumber;

  const _VerifyTripSheet({required this.mobileNumber});

  @override
  State<_VerifyTripSheet> createState() => _VerifyTripSheetState();
}

class _VerifyTripSheetState extends State<_VerifyTripSheet> {
  final OtpCubit _otpCubit = OtpCubit();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  Timer? _resendTimer;
  var _remainingSeconds = 60;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds == 0) {
        _resendTimer?.cancel();
      } else if (mounted) {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _otpCubit.close();
    super.dispose();
  }

  String get _resendLabel {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return 'Resend Otp in $minutes:$seconds';
  }

  void _verifyOtp() {
    if (!_otpCubit.state.isComplete) {
      setState(() => _errorMessage = 'Enter the 6-digit OTP.');
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(17, 16, 17, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: BlocBuilder<OtpCubit, OtpState>(
            bloc: _otpCubit,
            builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Verify Trip',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF003A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'An OTP has been sent to ${widget.mobileNumber}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 12 * -0.01,
                    color: const Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  'OTP',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    letterSpacing: 12 * -0.02,
                    color: const Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _controllers.length,
                      (index) => SizedBox(
                        width: 45,
                        height: 45,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          textInputAction: index == 5
                              ? TextInputAction.done
                              : TextInputAction.next,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1C1E),
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            isDense: false,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0x66B8B8B8),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF003A8A),
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _otpCubit.updateDigit(index, value);
                            setState(() => _errorMessage = null);
                            if (value.isNotEmpty &&
                                index < _focusNodes.length - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            } else if (value.isNotEmpty &&
                                index == _focusNodes.length - 1) {
                              _focusNodes[index].unfocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _remainingSeconds == 0 ? 'Resend Otp' : _resendLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      letterSpacing: 11 * -0.01,
                      color: const Color(0xFF003A8A),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFBA1A1A),
                      ),
                    ),
                  ),
                AppContinueButton(
                  text: 'Verify Otp',
                  showArrow: false,
                  onPressed: _verifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
