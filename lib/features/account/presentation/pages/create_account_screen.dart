import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/features/account/presentation/cubit/account_form_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final AccountFormCubit _accountFormCubit = AccountFormCubit();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();

  @override
  void dispose() {
    businessNameController.dispose();
    contactPersonController.dispose();
    deliveryAddressController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    _accountFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountFormCubit, AccountFormState>(
      bloc: _accountFormCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, _) {
                final screenHeight = MediaQuery.sizeOf(context).height;

                return Column(
                  children: [
                    // Reusable header widget
                    const AppHeader(title: 'Create Account', height: 133),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(0, 23, 0, 25),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: AppFormSection(
                                  child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    AppTextField(
                                      label: 'Business Name',
                                      hint: 'Solar Trade',
                                      controller: businessNameController,
                                      onChanged: _accountFormCubit.updateBusinessName,
                                    ),
                                    AppTextField(
                                      label: 'Contact Person',
                                      hint: 'Rahul Roy',
                                      controller: contactPersonController,
                                      onChanged: _accountFormCubit.updateContactPerson,
                                    ),
                                    AppTextField(
                                      label: 'Delivery Address',
                                      hint: '123-33 New Delhi - 112234',
                                      controller: deliveryAddressController,
                                      onChanged: _accountFormCubit.updateDeliveryAddress,
                                    ),
                                    AppTextField(
                                      label: 'Gst Number',
                                      hint: '9876546879',
                                      controller: gstNumberController,
                                      keyboardType: TextInputType.number,
                                      onChanged: _accountFormCubit.updateGstNumber,
                                    ),
                                    AppTextField(
                                      label: 'Pan Number',
                                      hint: '12345678',
                                      controller: panNumberController,
                                      bottomSpacing: 0,
                                      onChanged: _accountFormCubit.updatePanNumber,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18),
                                      child: AppContinueButton(
                                        text: 'Continue',
                                        onPressed: () {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            context.push(AppRoutes.choosePlan);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      ),
    );
  }
}
