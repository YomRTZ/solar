import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/widgets.dart';
import 'package:flutter_app/features/company/presentation/cubit/company_form_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final CompanyFormCubit _companyFormCubit;
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dispatchLocationController =
      TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data (remove in production)
    companyNameController.text = 'Solar Trade';
    emailController.text = 'Solar@gmail.com';
    addressController.text = '12-223 Salest, New Delhi';
    dispatchLocationController.text = '12-223 Salest, New Delhi';
    gstNumberController.text = '08TGC45879';
    panNumberController.text = '123456789';
    _companyFormCubit = CompanyFormCubit(
      initialState: CompanyFormState(
        companyName: companyNameController.text,
        email: emailController.text,
        address: addressController.text,
        dispatchLocation: dispatchLocationController.text,
        gstNumber: gstNumberController.text,
        panNumber: panNumberController.text,
      ),
    );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    dispatchLocationController.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
    _companyFormCubit.close();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      context.push(AppRoutes.bankDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyFormCubit, CompanyFormState>(
      bloc: _companyFormCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            // Header — reusable widget, arrow top / title bottom
            const AppHeader(title: 'Company Details'),

            // Form Content
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
                          label: 'Company Name',
                          hint: 'Solar Trade',
                          controller: companyNameController,
                          onChanged: _companyFormCubit.updateCompanyName,
                        ),
                        AppTextField(
                          label: 'Email Address',
                          hint: 'Solar@gmail.com',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: _companyFormCubit.updateEmail,
                        ),
                        AppTextField(
                          label: 'Address',
                          hint: '12-223 Salest, New Delhi',
                          controller: addressController,
                          onChanged: _companyFormCubit.updateAddress,
                        ),
                        AppTextField(
                          label: 'Dispatch Location',
                          hint: '12-223 Salest, New Delhi',
                          controller: dispatchLocationController,
                          onChanged: _companyFormCubit.updateDispatchLocation,
                        ),
                        AppTextField(
                          label: 'Gst Number',
                          hint: '08TGC45879',
                          controller: gstNumberController,
                          onChanged: _companyFormCubit.updateGstNumber,
                        ),
                        AppTextField(
                          label: 'Pan Number',
                          hint: '123456789',
                          controller: panNumberController,
                          bottomSpacing: 0,
                          onChanged: _companyFormCubit.updatePanNumber,
                        ),
                        // Continue Button
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: AppContinueButton(
                            text: 'Continue',
                            onPressed: _handleContinue,
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
