import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'withdraw_balance_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
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
            _WalletHeader(
              onWithdrawTap: () => _showWithdrawSheet(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
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
        BankAccountModel(name: 'Personal Account', maskedNumber: '•••• •••• 1234'),
        BankAccountModel(name: 'Business Account',  maskedNumber: '•••• •••• 5678'),
      ],
      onWithdraw: (amount, account) {
        Navigator.pop(context);
        // TODO: handle withdrawal — pass to your BLoC / provider
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header (dark gradient + balance card)
// ─────────────────────────────────────────────────────────────────────────────
class _WalletHeader extends StatelessWidget {
  final VoidCallback onWithdrawTap;
  const _WalletHeader({required this.onWithdrawTap});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: top + 12),

          // ── Back arrow + title ──────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'My Wallet',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Balance card ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _BalanceCard(onWithdrawTap: onWithdrawTap),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Balance card
// ─────────────────────────────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final VoidCallback onWithdrawTap;
  const _BalanceCard({required this.onWithdrawTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2A5E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Wallet icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(height: 10),

          // Label
          Text(
            'Wallet Balance',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 6),

          // Amount
          Text(
            'Rs. 4,87,911',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 14),

          // Withdraw button
          GestureDetector(
            onTap: onWithdrawTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Withdraw Balance',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: -0.2,
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

// ─────────────────────────────────────────────────────────────────────────────
// Transaction card
// ─────────────────────────────────────────────────────────────────────────────
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
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCredit
                  ? Icons.shopping_bag_outlined
                  : Icons.account_balance_outlined,
              color: const Color(0xFF003A8A),
              size: 20,
            ),
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
                    color: const Color(0xFF6C7278),
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
