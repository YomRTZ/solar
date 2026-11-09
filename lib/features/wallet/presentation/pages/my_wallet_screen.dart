import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/wallet/presentation/widgets/withdraw_balance_sheet.dart';

enum _TransactionType { credit, debit }

class _Transaction {
  final String title;
  final String subtitle;
  final String amount;
  final _TransactionType type;

  const _Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
  });
}

class MyWalletScreen extends StatelessWidget {
  const MyWalletScreen({super.key});

  static const List<_Transaction> _transactions = [
    _Transaction(
      title: 'New order made!',
      subtitle: 'You have created a new order #4567054',
      amount: '+ \$1353.8',
      type: _TransactionType.credit,
    ),
    _Transaction(
      title: 'Balance Withdrawal',
      subtitle: 'Tracking ID: NB145618X85',
      amount: '- \$9',
      type: _TransactionType.debit,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        body: Column(
          children: [
            SecondAppHeader(
              title: 'My Wallet',
              onBackPressed: () => Navigator.maybePop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 26, 18, 30),
              child: SizedBox(
                width: 330,
                height: 160,
                child: _BalanceCard(
                  onWithdrawTap: () => _showWithdrawSheet(context),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 30, 7, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF202020),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._transactions.map(
                        (tx) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TransactionCard(transaction: tx),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawSheet(BuildContext context) {
    WithdrawBalanceSheet.show(
      context: context,
      initialAmount: 'Rs. 20,000',
      accounts: const [
        BankAccountModel(
          name: 'Personal Account',
          maskedNumber: '•••• •••• 1234',
        ),
      ],
      onWithdraw: (amount, account) {
        Navigator.pop(context);
        // TODO: handle withdrawal — pass to your BLoC / provider
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final VoidCallback onWithdrawTap;
  const _BalanceCard({required this.onWithdrawTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 160,
      padding: const EdgeInsets.fromLTRB(12, 12, 13, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/ic_package_box.svg', width: 34, height: 52),
          const SizedBox(height: 4),
          Text(
            'Wallet Balance',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 2),

          // Amount
          Text(
            'Rs. 4,87,911',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 29,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 5),

          // Withdraw button
          GestureDetector(
            onTap: onWithdrawTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_wallet_upload.svg',
                  width: 20,
                  height: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Withdraw Balance',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final _Transaction transaction;
  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == _TransactionType.credit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCredit
                  ? const Color(0xFFC6DCFF)
                  : const Color(0xFFC6DCFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: isCredit
                ? SvgPicture.asset('assets/icons/ic_import.svg')
                : SvgPicture.asset('assets/icons/ic_export.svg'),
          ),

          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF003A8A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF003A8A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Amount
          Text(
            transaction.amount,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isCredit
                  ? const Color(0xFF27AE60)
                  : const Color(0xFFE74C3C),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
