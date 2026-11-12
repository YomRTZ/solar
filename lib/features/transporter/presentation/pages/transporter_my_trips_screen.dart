import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 158.5,
              height: 34,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: index == selectedIndex
                    ? const Color(0xFF003A8A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: index == selectedIndex
                    ? null
                    : Border.all(color: const Color(0xFFD3D3D3)),
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
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: index == selectedIndex
                        ? Colors.white
                        : const Color(0xFF202020),
                  ),
                ),
              ),
            ),
          ),
          if (index < labels.length - 1) const SizedBox(width: 4),
        ],
      ],
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
      height: 134,
      padding: const EdgeInsets.fromLTRB(9.82, 11, 11, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D3D3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Row(
            children: [
              _TripDetail(label: 'Vehicle', value: job.vehicle),
              const SizedBox(width: 18),
              _TripDetail(label: 'Weight', value: job.weight),
              const SizedBox(width: 18),
              _TripDetail(label: 'Date', value: job.date),
            ],
          ),
          if (hasAddresses)
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
                    textAlign: TextAlign.center,
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
                const Padding(
                  padding: EdgeInsets.only(left: 9, right: 22),
                  child: SizedBox(
                    width: 15,
                    height: 8,
                    child: Icon(
                      Icons.arrow_forward,
                      size: 8,
                      color: Color(0xFF000000),
                    ),
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
                    textAlign: TextAlign.center,
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
                      padding: const EdgeInsets.only(right: 0.79),
                      child: _TripActionButton(
                        label: isVerified ? 'Start Trip' : 'Verify Delivery',
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
          Text(
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
      height: 22,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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

  void _resendOtp() {
    setState(() {
      _remainingSeconds = 60;
      _errorMessage = null;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds == 0) {
        _resendTimer?.cancel();
      } else if (mounted) {
        setState(() => _remainingSeconds--);
      }
    });
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
                  'An Otp has been sent to ${widget.mobileNumber}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF808080),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'OTP',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: const Color(0xFF6C7278),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    _controllers.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == _controllers.length - 1 ? 0 : 7,
                        ),
                        child: SizedBox(
                          height: 39,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE1E4E8),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE1E4E8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: Color(0xFF003A8A),
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
                              } else {
                                _focusNodes[index].unfocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _remainingSeconds == 0 ? _resendOtp : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 3, bottom: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _remainingSeconds == 0 ? 'Resend Otp' : _resendLabel,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF003A8A),
                      ),
                    ),
                  ),
                ),
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
