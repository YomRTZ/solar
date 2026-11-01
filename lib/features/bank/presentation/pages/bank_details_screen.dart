import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/widgets.dart';
import 'package:flutter_app/features/bank/presentation/cubit/bank_details_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final BankDetailsCubit _bankDetailsCubit;
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with sample data (remove in production)
    accountHolderNameController.text = 'Solar Trade';
    accountNumberController.text = '123456789';
    ifscCodeController.text = 'Hdfc1002';
    bankNameController.text = 'Hdfc Bank';
    _bankDetailsCubit = BankDetailsCubit(
      initialState: BankDetailsState(
        accountHolderName: accountHolderNameController.text,
        accountNumber: accountNumberController.text,
        ifscCode: ifscCodeController.text,
        bankName: bankNameController.text,
      ),
    );
  }

  @override
  void dispose() {
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    bankNameController.dispose();
    _bankDetailsCubit.close();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      context.push(AppRoutes.uploadDocuments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BankDetailsCubit, BankDetailsState>(
      bloc: _bankDetailsCubit,
      builder: (context, state) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            const AppHeader(title: 'Bank Details'),

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
                          label: 'Account Holder Name',
                          hint: 'Solar Trade',
                          controller: accountHolderNameController,
                          onChanged: _bankDetailsCubit.updateAccountHolderName,
                        ),
                        AppTextField(
                          label: 'Account Number',
                          hint: '123456789',
                          controller: accountNumberController,
                          keyboardType: TextInputType.number,
                          onChanged: _bankDetailsCubit.updateAccountNumber,
                        ),
                        AppTextField(
                          label: 'Ifsc Code',
                          hint: 'Hdfc1002',
                          controller: ifscCodeController,
                          onChanged: _bankDetailsCubit.updateIfscCode,
                        ),
                        AppTextField(
                          label: 'Bank Name',
                          hint: 'Hdfc Bank',
                          controller: bankNameController,
                          bottomSpacing: 0,
                          onChanged: _bankDetailsCubit.updateBankName,
                        ),
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
