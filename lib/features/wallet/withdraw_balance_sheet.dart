import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/widgets/app_bottom_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public model — callers build their own account list
// ─────────────────────────────────────────────────────────────────────────────
class BankAccountModel {
  final String name;
  final String maskedNumber;

  const BankAccountModel({
    required this.name,
    required this.maskedNumber,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Withdraw Balance Sheet
//
// Fully parameterised — every piece of data and behaviour is injected.
//
// Minimal usage:
//   AppBottomSheet.show(
//     context: context,
//     title: 'Withdraw Balance',
//     child: WithdrawBalanceContent(
//       accounts: myAccounts,
//       onWithdraw: (amount, account) { ... },
//     ),
//   );
//
// Or use the convenience launcher:
//   WithdrawBalanceSheet.show(context: context, accounts: myAccounts);
// ─────────────────────────────────────────────────────────────────────────────
class WithdrawBalanceSheet extends StatelessWidget {
  final List<BankAccountModel> accounts;
  final String initialAmount;
  final String title;
  final String amountLabel;
  final String accountLabel;
  final String buttonLabel;

  /// Called when the user taps the action button.
  /// [amount] is the current text-field value.
  /// [account] is the selected [BankAccountModel].
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

  /// Convenience launcher — wraps [AppBottomSheet.show] so callers
  /// don't need to import [AppBottomSheet] separately.
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
        title: '',        // title is handled by AppBottomSheet
        amountLabel: amountLabel,
        accountLabel: accountLabel,
        buttonLabel: buttonLabel,
        onWithdraw: onWithdraw,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // When used via the convenience launcher the title is already rendered by
    // AppBottomSheet. When used standalone (e.g. embedded directly in a page)
    // we wrap ourselves in AppBottomSheet so the shell is always present.
    final content = _WithdrawBalanceContent(
      accounts: accounts,
      initialAmount: initialAmount,
      amountLabel: amountLabel,
      accountLabel: accountLabel,
      buttonLabel: buttonLabel,
      onWithdraw: onWithdraw,
    );

    // If a non-empty title was passed the caller is using WithdrawBalanceSheet
    // directly (not via show()), so we render the full shell ourselves.
    if (title.isNotEmpty) {
      return AppBottomSheet(title: title, child: content);
    }

    // Called from show() — AppBottomSheet is already the parent, so just
    // return the content.
    return content;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stateful content — owns the text controller + selection state
// ─────────────────────────────────────────────────────────────────────────────
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
  late final TextEditingController _amountController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.initialAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleWithdraw() {
    final selected = widget.accounts[_selectedIndex];
    if (widget.onWithdraw != null) {
      widget.onWithdraw!(_amountController.text, selected);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Amount label ──────────────────────────────────
        Text(
          widget.amountLabel,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6C7278),
          ),
        ),

        const SizedBox(height: 8),

        // ── Amount input ──────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // ── Bank account label ────────────────────────────
        Text(
          widget.accountLabel,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6C7278),
          ),
        ),

        const SizedBox(height: 10),

        // ── Account tiles ─────────────────────────────────
        ...widget.accounts.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AccountTile(
              account: entry.value,
              isSelected: entry.key == _selectedIndex,
              onTap: () => setState(() => _selectedIndex = entry.key),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // ── Action button ─────────────────────────────────
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _handleWithdraw,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003A8A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: Text(
              widget.buttonLabel,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Account tile
// ─────────────────────────────────────────────────────────────────────────────
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
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // Bank icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF0FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                color: Color(0xFF003A8A),
                size: 20,
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
                  border:
                      Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
