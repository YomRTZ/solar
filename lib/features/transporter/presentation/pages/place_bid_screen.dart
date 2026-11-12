import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';

class PlaceBidScreen extends StatefulWidget {
  final TransporterJob job;

  const PlaceBidScreen({super.key, required this.job});

  @override
  State<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baseFareController;
  late final TextEditingController _loadingChargesController;
  late final TextEditingController _unloadingChargesController;
  late final TextEditingController _waitingChargesController;
  late final TextEditingController _tollsController;
  late final TextEditingController _pickupDateController;
  late final TextEditingController _dropoffDateController;

  @override
  void initState() {
    super.initState();
    _baseFareController = TextEditingController(text: '20,000');
    _loadingChargesController = TextEditingController(text: '2,000');
    _unloadingChargesController = TextEditingController(text: '2,000');
    _waitingChargesController = TextEditingController(text: '2,000');
    _tollsController = TextEditingController(text: '4,000');
    _pickupDateController = TextEditingController(text: '08/11/2026');
    _dropoffDateController = TextEditingController(text: '10/11/2026');
  }

  @override
  void dispose() {
    _baseFareController.dispose();
    _loadingChargesController.dispose();
    _unloadingChargesController.dispose();
    _waitingChargesController.dispose();
    _tollsController.dispose();
    _pickupDateController.dispose();
    _dropoffDateController.dispose();
    super.dispose();
  }

  int get _totalBidAmount =>
      _amount(_baseFareController) +
      _amount(_loadingChargesController) +
      _amount(_unloadingChargesController) +
      _amount(_waitingChargesController) +
      _amount(_tollsController);

  int _amount(TextEditingController controller) =>
      int.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;

  String? _validateAmount(String? value) {
    final amount = int.tryParse((value ?? '').replaceAll(',', '').trim());
    if (amount == null || amount < 0) return 'Enter a valid amount';
    return null;
  }

  String _formattedAmount(int amount) {
    final digits = amount.toString();
    final formatted = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) {
        formatted.write(',');
      }
      formatted.write(digits[index]);
    }
    return formatted.toString();
  }

  void _updateAmount(String _) => setState(() {});

  void _submitBid() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.push(AppRoutes.transporterBidStatus);
  }

  @override
  Widget build(BuildContext context) {
    final total = _formattedAmount(_totalBidAmount);

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
            const AppHeader(title: 'Place Bid'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
                child: Form(
                  key: _formKey,
                  child: AppFormSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _JobSummary(job: widget.job),
                        const SizedBox(height: 15),
                        AppTextField(
                          label: 'Base Fare',
                          hint: 'Enter base fare',
                          controller: _baseFareController,
                          keyboardType: TextInputType.number,
                          onChanged: _updateAmount,
                          validator: _validateAmount,
                        ),
                        AppTextField(
                          label: 'Loading Charges',
                          hint: 'Enter loading charges',
                          controller: _loadingChargesController,
                          keyboardType: TextInputType.number,
                          onChanged: _updateAmount,
                          validator: _validateAmount,
                        ),
                        AppTextField(
                          label: 'Unloading Charges',
                          hint: 'Enter unloading charges',
                          controller: _unloadingChargesController,
                          keyboardType: TextInputType.number,
                          onChanged: _updateAmount,
                          validator: _validateAmount,
                        ),
                        AppTextField(
                          label: 'Waiting Charges',
                          hint: 'Enter waiting charges',
                          controller: _waitingChargesController,
                          keyboardType: TextInputType.number,
                          onChanged: _updateAmount,
                          validator: _validateAmount,
                        ),
                        AppTextField(
                          label: 'Tolls & Extra',
                          hint: 'Enter tolls and extra charges',
                          controller: _tollsController,
                          keyboardType: TextInputType.number,
                          onChanged: _updateAmount,
                          validator: _validateAmount,
                        ),
                        AppTextField(
                          label: 'Estimate Pickup',
                          hint: 'DD/MM/YYYY',
                          controller: _pickupDateController,
                        ),
                        AppTextField(
                          label: 'Estimate Dropoff',
                          hint: 'DD/MM/YYYY',
                          controller: _dropoffDateController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Text(
                                'Total Bid Amount',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF202020),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Rs. $total',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF202020),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppContinueButton(
                          text: 'Submit Bid | Rs. $total',
                          showArrow: false,
                          onPressed: _submitBid,
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

class _JobSummary extends StatelessWidget {
  final TransporterJob job;

  const _JobSummary({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.route,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF202020),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            job.date,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF202020),
            ),
          ),
        ],
      ),
    );
  }
}
