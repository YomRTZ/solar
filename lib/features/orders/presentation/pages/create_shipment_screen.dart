import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  State<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController(text: '12,340');
  final _loadingController = TextEditingController(text: '1000');
  final _unloadingController = TextEditingController(text: '1000');
  final _otherChargesController = TextEditingController(text: '1000');

  String _selectedVehicle = 'Open Truck';

  @override
  void dispose() {
    _pickupController.dispose();
    _loadingController.dispose();
    _unloadingController.dispose();
    _otherChargesController.dispose();
    super.dispose();
  }

  String? _validateCharge(String? value) {
    final amount = int.tryParse((value ?? '').replaceAll(',', '').trim());
    if (amount == null || amount < 0) return 'Enter a valid amount';
    return null;
  }

  Future<void> _searchDriver() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final accepted = await context.push<bool>(AppRoutes.bidsReceived);
    if (accepted == true && mounted) context.pop(true);
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
            SecondAppHeader(
              title: 'Create Shipment',
              trailing: Text(
                '1/3',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              trailingRightInset: 24,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Job Details',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202020),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Preferred Vehicle Type',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202020),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _vehicleOption(
                            label: 'Open Truck',
                            imagePath: 'assets/solarimages/opentrack.png',
                          ),
                          const SizedBox(width: 8),
                          _vehicleOption(
                            label: 'Container',
                            imagePath: 'assets/solarimages/container.png',
                          ),
                          const SizedBox(width: 8),
                          _vehicleOption(
                            label: 'Mini Truck',
                            imagePath: 'assets/solarimages/minitruck.png',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Pickup Location',
                        hint: 'Enter pickup location',
                        controller: _pickupController,
                        suffixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF003A8A),
                        ),
                        validator: (value) => (value ?? '').trim().isEmpty
                            ? 'Pickup location is required'
                            : null,
                      ),
                      AppTextField(
                        label: 'Loading Charges',
                        hint: 'Enter loading charges',
                        controller: _loadingController,
                        keyboardType: TextInputType.number,
                        validator: _validateCharge,
                      ),
                      AppTextField(
                        label: 'Unloading Charges',
                        hint: 'Enter unloading charges',
                        controller: _unloadingController,
                        keyboardType: TextInputType.number,
                        validator: _validateCharge,
                      ),
                      AppTextField(
                        label: 'Toll / Other Charges',
                        hint: 'Enter toll or other charges',
                        controller: _otherChargesController,
                        keyboardType: TextInputType.number,
                        validator: _validateCharge,
                        bottomSpacing: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _searchDriver,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003D82),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Search Driver'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _vehicleOption({required String label, required String imagePath}) {
    final isSelected = _selectedVehicle == label;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => _selectedVehicle = label),
        child: Container(
          height: 82,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF0F6FF) : Colors.white,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF003A8A)
                  : const Color(0xFFE0E5EB),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF202020),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
