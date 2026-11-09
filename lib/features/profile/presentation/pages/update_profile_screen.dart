import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/widgets/widgets.dart';
import 'package:flutter_app/features/profile/presentation/cubit/profile_form_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  late final ProfileFormCubit _profileFormCubit;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing profile data
    _businessController.text = 'Solar Trade';
    _contactPersonController.text = 'Rahul Roy';
    _deliveryAddressController.text = '123-33 New Delhi - 112234';
    _gstNumberController.text = '9876546879';
    _panNumberController.text = '12345678';
    _profileFormCubit = ProfileFormCubit(
      initialState: ProfileFormState(
        businessName: _businessController.text,
        contactPerson: _contactPersonController.text,
        deliveryAddress: _deliveryAddressController.text,
        gstNumber: _gstNumberController.text,
        panNumber: _panNumberController.text,
      ),
    );
  }

  @override
  void dispose() {
    _businessController.dispose();
    _contactPersonController.dispose();
    _deliveryAddressController.dispose();
    _gstNumberController.dispose();
    _panNumberController.dispose();
    _profileFormCubit.close();
    super.dispose();
  }

  void _handleUpdate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final state = _profileFormCubit.state;
    if (state.businessName.trim().isEmpty) return;

    // Persist via cubit (values are already tracked on every keystroke).
    // The cubit holds the latest state — a repository layer would be called
    // here once a backend is wired up.
    _profileFormCubit.markSaved();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Color(0xFF003A8A),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      bloc: _profileFormCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SecondAppHeader(title: 'Update Profile'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 23, 0, 25),
                child: Form(
                  key: _formKey,
                  child: AppFormSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        label: 'Business',
                        hint: 'Solar Trade',
                        controller: _businessController,
                        onChanged: _profileFormCubit.updateBusinessName,
                      ),
                      AppTextField(
                        label: 'Contact Person',
                        hint: 'Rahul Roy',
                        controller: _contactPersonController,
                        onChanged: _profileFormCubit.updateContactPerson,
                      ),
                      AppTextField(
                        label: 'Delivery Address',
                        hint: '123-33 New Delhi - 112234',
                        controller: _deliveryAddressController,
                        onChanged: _profileFormCubit.updateDeliveryAddress,
                      ),
                      AppTextField(
                        label: 'Gst Number',
                        hint: '9876546879',
                        controller: _gstNumberController,
                        keyboardType: TextInputType.text,
                        onChanged: _profileFormCubit.updateGstNumber,
                      ),
                      AppTextField(
                        label: 'Pan  Number',
                        hint: '12345678',
                        controller: _panNumberController,
                        keyboardType: TextInputType.text,
                        bottomSpacing: 0,
                        onChanged: _profileFormCubit.updatePanNumber,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: AppContinueButton(
                          text: 'Update',
                          showArrow: false,
                          onPressed: _handleUpdate,
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
