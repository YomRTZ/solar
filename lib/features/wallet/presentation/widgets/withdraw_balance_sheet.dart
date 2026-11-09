import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_bottom_sheet.dart';
import 'package:flutter_app/core/validation/app_form_validation.dart';
import 'package:flutter_app/features/wallet/presentation/cubit/withdraw_form_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankAccountModel {
  final String name;
  final String maskedNumber;

  const BankAccountModel({required this.name, required this.maskedNumber});
}

class WithdrawBalanceSheet extends StatelessWidget {
  final List<BankAccountModel> accounts;
  final String initialAmount;
  final String title;
  final String amountLabel;
  final String accountLabel;
  final String buttonLabel;

  // Called when the user taps the action button
  final void Function(String amount, BankAccountModel account)? onWithdraw;

  const WithdrawBalanceSheet({
    super.key,
    required this.accounts,
    this.initialAmount = '',
    this.title = 'Withdraw Balance',
    this.amountLabel = 'Amount',
    this.accountLabel = 'Bank Account',
    this.buttonLabel = 'Withdraw',
    this.onWithdraw,
  }) : assert(accounts.length > 0, 'Provide at least one bank account');

  // Convenience launcher — wraps [AppBottomSheet.show] so callers don't need to import
  static Future<void> show({
    required BuildContext context,
    required List<BankAccountModel> accounts,
    String initialAmount = '',
    String title = 'Withdraw Balance',
    String amountLabel = 'Amount',
    String accountLabel = 'Bank Account',
    String buttonLabel = 'Withdraw',
    void Function(String amount, BankAccountModel account)? onWithdraw,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: title,
      child: WithdrawBalanceSheet(
        accounts: accounts,
        initialAmount: initialAmount,
        title: '', // title is handled by AppBottomSheet
        amountLabel: amountLabel,
        accountLabel: accountLabel,
        buttonLabel: buttonLabel,
        onWithdraw: onWithdraw,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // When used via the convenience launcher the title is already rendered by AppBottomSheet
    final content = _WithdrawBalanceContent(
      accounts: accounts,
      initialAmount: initialAmount,
      amountLabel: amountLabel,
      accountLabel: accountLabel,
      buttonLabel: buttonLabel,
      onWithdraw: onWithdraw,
    );

    // If a non-empty title was passed the caller is using WithdrawBalanceSheet directly (not via
    if (title.isNotEmpty) {
      return AppBottomSheet(title: title, child: content);
    }

    // Called from show() — AppBottomSheet is already the parent, so just return the content.
    return content;
  }
}

class _WithdrawBalanceContent extends StatefulWidget {
  final List<BankAccountModel> accounts;
  final String initialAmount;
  final String amountLabel;
  final String accountLabel;
  final String buttonLabel;
  final void Function(String amount, BankAccountModel account)? onWithdraw;

  const _WithdrawBalanceContent({
    required this.accounts,
    required this.initialAmount,
    required this.amountLabel,
    required this.accountLabel,
    required this.buttonLabel,
    required this.onWithdraw,
  });

  @override
  State<_WithdrawBalanceContent> createState() =>
      _WithdrawBalanceContentState();
}

class _WithdrawBalanceContentState extends State<_WithdrawBalanceContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final WithdrawFormCubit _withdrawCubit;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount);
    _withdrawCubit = WithdrawFormCubit(initialAmount: widget.initialAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _withdrawCubit.close();
    super.dispose();
  }

  void _handleWithdraw() {
    if (widget.accounts.isEmpty || _withdrawCubit.state.amount.trim().isEmpty) {
      return;
    }
    final selected = widget.accounts[_withdrawCubit.state.selectedAccountIndex];
    if (widget.onWithdraw != null) {
      widget.onWithdraw!(_withdrawCubit.state.amount, selected);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WithdrawFormCubit, WithdrawFormState>(
      bloc: _withdrawCubit,
      builder: (context, state) => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.amountLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C7278),
              ),
            ),

            const SizedBox(height: 8),

            FormField<String>(
              initialValue: _amountController.text,
              validator: (value) => AppFormValidation.requiredText(
                value,
                fieldName: widget.amountLabel,
              ),
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 327,
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEDF1F3)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3DE4E5E7),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        field.didChange(value);
                        _withdrawCubit.updateAmount(value);
                      },
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A1A),
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (field.errorText != null)
                    AppFormErrorText(field.errorText!),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Text(
              widget.accountLabel,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6C7278),
              ),
            ),

            const SizedBox(height: 10),

            ...widget.accounts.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AccountTile(
                  account: entry.value,
                  isSelected: entry.key == state.selectedAccountIndex,
                  onTap: () => _withdrawCubit.selectAccount(entry.key),
                ),
              ),
            ),

            const SizedBox(height: 8),

            AppContinueButton(
              text: widget.buttonLabel,
              height: 52,
              showArrow: false,
              backgroundColor: const Color(0xFF003A8A),
              onPressed: _handleWithdraw,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final BankAccountModel account;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountTile({
    required this.account,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Bank icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF003A8A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ic_bank.svg',
                  width: 28,
                  height: 20,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Name + number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account.maskedNumber,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),
            ),

            // Selected / unselected indicator
            if (isSelected)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF003A8A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              )
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
