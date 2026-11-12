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
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/features/auth/presentation/cubit/auth_cubit.dart';

class CreateTransporterAccountScreen extends StatefulWidget {
  const CreateTransporterAccountScreen({super.key});

  @override
  State<CreateTransporterAccountScreen> createState() =>
      _CreateTransporterAccountScreenState();
}

class _CreateTransporterAccountScreenState
    extends State<CreateTransporterAccountScreen> {
  static const _vehicleOptions = ['Open Truck', 'Container'];

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _dlNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _stateCityController = TextEditingController();
  final _pincodeController = TextEditingController();

  Uint8List? _profileImageBytes;
  String? _profileImageName;
  List<String> _selectedVehicles = [];

  @override
  void initState() {
    super.initState();
    _mobileNumberController.text = context
        .read<AuthCubit>()
        .state
        .mobileNumber;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _vehicleNumberController.dispose();
    _dlNumberController.dispose();
    _mobileNumberController.dispose();
    _stateCityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (bytes.length > 10 * 1024 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Choose an image smaller than 10 MB.'),
          ),
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _profileImageBytes = bytes;
        _profileImageName = image.name;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Unable to select a profile photo.'),
        ),
      );
    }
  }

  Future<void> _selectVehicles() async {
    final selected = Set<String>.from(_selectedVehicles);
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final vehicle in _vehicleOptions)
                CheckboxListTile(
                  title: Text(vehicle),
                  value: selected.contains(vehicle),
                  onChanged: (isSelected) {
                    setModalState(() {
                      if (isSelected ?? false) {
                        selected.add(vehicle);
                      } else {
                        selected.remove(vehicle);
                      }
                    });
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted) return;
    setState(() => _selectedVehicles = _vehicleOptions
        .where(selected.contains)
        .toList());
  }

  void _continue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.go(AppRoutes.transporterHome);
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
            const AppHeader(title: 'Create Account'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 23, 0, 25),
                child: Form(
                  key: _formKey,
                  child: AppFormSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppProfilePhotoUploadField(
                          imageBytes: _profileImageBytes,
                          fileName: _profileImageName,
                          onTap: _pickProfilePhoto,
                          onRemove: () => setState(() {
                            _profileImageBytes = null;
                            _profileImageName = null;
                          }),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Full Name',
                          hint: 'Enter full name',
                          controller: _fullNameController,
                        ),
                        AppTextField(
                          label: 'Vehicle Number',
                          hint: 'Enter vehicle number',
                          controller: _vehicleNumberController,
                        ),
                        AppTextField(
                          label: 'DL Number',
                          hint: 'Enter DL number',
                          controller: _dlNumberController,
                        ),
                        AppTextField(
                          label: 'Mobile Number',
                          hint: 'Enter mobile number',
                          controller: _mobileNumberController,
                          keyboardType: TextInputType.phone,
                          validator: AppFormValidation.phoneNumber,
                        ),
                        AppTextField(
                          label: 'State/City',
                          hint: 'Enter state/city',
                          controller: _stateCityController,
                        ),
                        AppTextField(
                          label: 'Pincode',
                          hint: 'Enter pincode',
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: AppFormValidation.pincode,
                        ),
                        _VehicleTypesField(
                          selectedVehicles: _selectedVehicles,
                          onTap: _selectVehicles,
                          onRemove: (vehicle) => setState(
                            () => _selectedVehicles.remove(vehicle),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: AppContinueButton(
                            text: 'Continue',
                            showArrow: false,
                            onPressed: _continue,
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

class _VehicleTypesField extends StatelessWidget {
  final List<String> selectedVehicles;
  final VoidCallback onTap;
  final ValueChanged<String> onRemove;

  const _VehicleTypesField({
    required this.selectedVehicles,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      key: ValueKey(selectedVehicles.join('|')),
      initialValue: selectedVehicles,
      validator: (value) => value == null || value.isEmpty
          ? AppFormValidation.requiredText(null, fieldName: 'List of vehicles')
          : null,
      builder: (field) {
        final hasError = field.errorText != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List of vehicles',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.6,
                letterSpacing: -0.24,
                color: const Color(0xFF6C7278),
              ),
            ),
            const SizedBox(height: 3),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 46),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: hasError
                        ? AppFormValidation.errorColor
                        : const Color(0xFFEDF1F3),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3DE4E5E7),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: selectedVehicles.isEmpty
                          ? Text(
                              'Select vehicles',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFFACB5BB),
                              ),
                            )
                          : Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: selectedVehicles
                                  .map(
                                    (vehicle) => Container(
                                      height: 24,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF003A8A),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            vehicle,
                                            style: GoogleFonts.inter(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () => onRemove(vehicle),
                                            child: Container(
                                              width: 13.34,
                                              height: 13.34,
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                              child: const FittedBox(
                                                child: Icon(
                                                  Icons.close,
                                                  color: Color(0xFF003A8A),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF6C7278),
                    ),
                  ],
                ),
              ),
            ),
            if (field.errorText != null)
              AppFormErrorText(field.errorText!),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
