import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/widgets.dart';
import 'package:flutter_app/features/bank/presentation/cubit/bank_details_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Bank details edit screen — accessible from the profile page.
class BankDetailsEditScreen extends StatefulWidget {
  const BankDetailsEditScreen({super.key});

  @override
  State<BankDetailsEditScreen> createState() => _BankDetailsEditScreenState();
}

class _BankDetailsEditScreenState extends State<BankDetailsEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  late final BankDetailsCubit _bankDetailsCubit;

  @override
  void initState() {
    super.initState();
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

  void _handleUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      context.push(AppRoutes.vendorUploadDocuments);
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
              const AppHeader(title: 'Bank Details'),
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
                            onChanged:
                                _bankDetailsCubit.updateAccountHolderName,
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
                              text: 'Update',
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
