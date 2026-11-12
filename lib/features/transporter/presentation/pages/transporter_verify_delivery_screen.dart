import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/validation/app_form_validation.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_file_upload_field.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';
import 'package:flutter_app/features/transporter/presentation/cubit/transporter_cubit.dart';

class TransporterVerifyDeliveryScreen extends StatefulWidget {
  final TransporterTrip trip;

  const TransporterVerifyDeliveryScreen({super.key, required this.trip});

  @override
  State<TransporterVerifyDeliveryScreen> createState() =>
      _TransporterVerifyDeliveryScreenState();
}

class _TransporterVerifyDeliveryScreenState
    extends State<TransporterVerifyDeliveryScreen> {
  static const _conditions = ['Good', 'Damaged', 'Shortage'];

  final _formKey = GlobalKey<FormState>();
  final _receivedQtyController = TextEditingController(text: '200');
  final OtpCubit _otpCubit = OtpCubit();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final List<Uint8List> _proofPhotos = [];

  Timer? _resendTimer;
  var _remainingSeconds = 60;
  var _condition = _conditions.first;
  String? _otpError;

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
    _receivedQtyController.dispose();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _otpCubit.close();
    super.dispose();
  }

  Future<void> _openProofPicker() async {
    final selectedPhotos = await showModalBottomSheet<List<Uint8List>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeliveryProofSheet(initialPhotos: _proofPhotos),
    );
    if (selectedPhotos != null && mounted) {
      setState(() {
        _proofPhotos
          ..clear()
          ..addAll(selectedPhotos);
      });
    }
  }

  void _resendOtp() {
    setState(() {
      _remainingSeconds = 60;
      _otpError = null;
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

  void _updateOtp(int index, String value) {
    _otpCubit.updateDigit(index, value);
    setState(() => _otpError = null);
    if (value.isNotEmpty && index < _otpFocusNodes.length - 1) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    } else {
      _otpFocusNodes[index].unfocus();
    }
  }

  void _confirmDelivery() {
    if (!_otpCubit.state.isComplete) {
      setState(() => _otpError = 'Enter the 6-digit OTP.');
      return;
    }
    context.read<TransporterCubit>().confirmDelivery(widget.trip.id);
    context.go(AppRoutes.transporterDeliveryStatus);
  }

  String? _validateReceivedQty(String? value) {
    final quantity = int.tryParse(value?.trim() ?? '');
    if (quantity == null || quantity <= 0) {
      return 'Enter a valid received quantity';
    }
    return null;
  }

  String get _resendLabel {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return 'Resend Otp in $minutes:$seconds';
  }

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
            const SecondAppHeader(title: 'Verify Delivery'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(17, 15, 17, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STX-TRP - QWW',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF202020),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Check',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: const Color(0xFF555D63),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        label: 'Received Qty',
                        hint: 'Enter received quantity',
                        controller: _receivedQtyController,
                        keyboardType: TextInputType.number,
                        validator: _validateReceivedQty,
                        bottomSpacing: 12,
                      ),
                      _ConditionField(
                        value: _condition,
                        conditions: _conditions,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _condition = value);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      AppFileUploadField(
                        label: 'Upload Delivery Proof',
                        selectText: 'Upload image',
                        helperText: 'JPG, PNG file size no more than 10MB',
                        selectedFileName: _proofPhotos.isEmpty
                            ? null
                            : '${_proofPhotos.length} images selected',
                        onTap: _openProofPicker,
                      ),
                      const SizedBox(height: 13),
                      Text(
                        'Enter Delivery Otp',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6C7278),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          _otpControllers.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == _otpControllers.length - 1
                                    ? 0
                                    : 7,
                              ),
                              child: SizedBox(
                                height: 44,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    contentPadding: EdgeInsets.zero,
                                    border: _otpBorder,
                                    enabledBorder: _otpBorder,
                                    focusedBorder: _otpBorder.copyWith(
                                      borderSide: const BorderSide(
                                        color: Color(0xFF003A8A),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      _updateOtp(index, value),
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
                            padding: const EdgeInsets.only(top: 5, bottom: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _remainingSeconds == 0
                                ? 'Resend Otp'
                                : _resendLabel,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF003A8A),
                            ),
                          ),
                        ),
                      ),
                      if (_otpError != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _otpError!,
                            style: AppFormValidation.errorStyle,
                          ),
                        ),
                      const SizedBox(height: 10),
                      AppContinueButton(
                        text: 'Confirm Delivery',
                        showArrow: false,
                        onPressed: _confirmDelivery,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final _otpBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: const BorderSide(color: Color(0xFFE1E4E8)),
  );
}

class _ConditionField extends StatelessWidget {
  final String value;
  final List<String> conditions;
  final ValueChanged<String?> onChanged;

  const _ConditionField({
    required this.value,
    required this.conditions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Condition',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6C7278),
          ),
        ),
        const SizedBox(height: 3),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: [
            for (final condition in conditions)
              DropdownMenuItem(value: condition, child: Text(condition)),
          ],
          onChanged: onChanged,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF1A1C1E),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEDF1F3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF003A8A)),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _DeliveryProofSheet extends StatefulWidget {
  final List<Uint8List> initialPhotos;

  const _DeliveryProofSheet({required this.initialPhotos});

  @override
  State<_DeliveryProofSheet> createState() => _DeliveryProofSheetState();
}

class _DeliveryProofSheetState extends State<_DeliveryProofSheet> {
  static const _maxPhotos = 4;
  static const _maxFileBytes = 10 * 1024 * 1024;

  late final List<Uint8List> _photos = List.of(widget.initialPhotos);

  Future<void> _addPhotos() async {
    final remaining = _maxPhotos - _photos.length;
    if (remaining <= 0) return;

    try {
      final selected = await ImagePicker().pickMultiImage(
        imageQuality: 80,
        limit: remaining,
      );
      if (selected.isEmpty) return;

      final accepted = <Uint8List>[];
      var skippedLargeFile = false;
      for (final file in selected) {
        final bytes = await file.readAsBytes();
        if (bytes.length > _maxFileBytes) {
          skippedLargeFile = true;
        } else {
          accepted.add(bytes);
        }
      }

      if (!mounted) return;
      setState(() => _photos.addAll(accepted.take(remaining)));
      if (skippedLargeFile) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Images must be smaller than 10 MB.')),
        );
      }
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Unable to select delivery proof.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Upload Delivery Proof',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(List<Uint8List>.of(_photos)),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var index = 0; index < _maxPhotos; index++) ...[
                  if (index > 0) const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: index < _photos.length
                          ? _ProofPhotoTile(
                              bytes: _photos[index],
                              onRemove: () =>
                                  setState(() => _photos.removeAt(index)),
                            )
                          : _AddProofPhotoTile(onTap: _addPhotos),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProofPhotoTile extends StatelessWidget {
  final Uint8List bytes;
  final VoidCallback onRemove;

  const _ProofPhotoTile({required this.bytes, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(bytes, fit: BoxFit.cover),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                color: const Color(0x99000000),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddProofPhotoTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddProofPhotoTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: const Color(0x80000000),
          strokeWidth: 1,
          dashWidth: 4,
          dashSpace: 4,
          borderRadius: 2,
        ),
        child: const Center(
          child: Icon(Icons.add, size: 18, color: Color(0xFFB7083C)),
        ),
      ),
    );
  }
}
