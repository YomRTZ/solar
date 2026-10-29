import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../app/routing/app_routes.dart';
import '../../core/widgets/app_continue_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddTender — Checkout Screen
//
// Layout:
//  • Dark-gradient header + back arrow + "Checkout" title + note
//  • Delivery Address section (edit link)
//  • Card payment section (card number, expiration, CVC, country)
//  • Alternative payment options: Afterpay, Klarna (radio tiles)
//  • "Pay Now" sticky button
// ─────────────────────────────────────────────────────────────────────────────
class AddTenderCheckoutScreen extends StatefulWidget {
  const AddTenderCheckoutScreen({super.key});

  @override
  State<AddTenderCheckoutScreen> createState() =>
      _AddTenderCheckoutScreenState();
}

enum _PaymentMethod { card, afterpay, klarna }

class _AddTenderCheckoutScreenState extends State<AddTenderCheckoutScreen> {
  _PaymentMethod _selectedMethod = _PaymentMethod.card;

  final _cardNumberController = TextEditingController(
    text: '1234 1234 1234 1234',
  );
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _payNow() {
    context.go(AppRoutes.addTenderPaymentStatus, extra: true);
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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Delivery Address ────────────────────
                    _buildDeliverySection(),
                    const SizedBox(height: 24),

                    // ── Card payment ────────────────────────
                    _buildCardSection(),
                    const SizedBox(height: 20),

                    // ── Alternative payments ────────────────
                    _buildAlternativePayments(),
                  ],
                ),
              ),
            ),

            // ── Pay Now button ──────────────────────────────
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: top + 72,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF003A8A), Color(0xFF000F24)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, top + 14, 16, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checkout',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '(Ui will be Different)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Delivery address section ─────────────────────────────────
  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Address',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF003A8A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '13-333 Dummy Address, New Delhi - 112223',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4B5563),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Card payment section ─────────────────────────────────────
  Widget _buildCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card method toggle row
        GestureDetector(
          onTap: () => setState(() => _selectedMethod = _PaymentMethod.card),
          child: Row(
            children: [
              _RadioDot(selected: _selectedMethod == _PaymentMethod.card),
              const SizedBox(width: 10),
              const Icon(
                Icons.credit_card_rounded,
                color: Color(0xFF003A8A),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Card',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),

        if (_selectedMethod == _PaymentMethod.card) ...[
          const SizedBox(height: 16),

          // Card brand icons row
          Row(
            children: [
              _CardBrandIcon(Icons.credit_card, color: const Color(0xFF1434CB)),
              const SizedBox(width: 6),
              _CardBrandIcon(Icons.payment, color: const Color(0xFFEB001B)),
              const SizedBox(width: 6),
              _CardBrandIcon(
                Icons.account_balance_wallet,
                color: const Color(0xFF003A8A),
              ),
              const SizedBox(width: 6),
              _CardBrandIcon(
                Icons.monetization_on,
                color: const Color(0xFFFF6B00),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _FieldLabel(label: 'Card number'),
          const SizedBox(height: 6),
          _CheckoutTextField(
            controller: _cardNumberController,
            hintText: '1234 1234 1234 1234',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 14),

          _FieldLabel(label: 'Expiration'),
          const SizedBox(height: 6),
          _CheckoutTextField(
            controller: _expiryController,
            hintText: 'MM/YY',
            keyboardType: TextInputType.datetime,
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(label: 'CVC'),
                    const SizedBox(height: 6),
                    _CheckoutTextField(
                      controller: _cvcController,
                      hintText: 'CVC',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.credit_card_rounded,
                    color: Color(0xFF6C7278),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _FieldLabel(label: 'Country'),
          const SizedBox(height: 6),
          _CountryDropdown(),
        ],
      ],
    );
  }

  // ── Alternative payment methods ──────────────────────────────
  Widget _buildAlternativePayments() {
    return Column(
      children: [
        _PaymentOptionTile(
          label: 'Afterpay',
          iconData: Icons.shopping_bag_outlined,
          iconColor: const Color(0xFF003A8A),
          isSelected: _selectedMethod == _PaymentMethod.afterpay,
          onTap: () =>
              setState(() => _selectedMethod = _PaymentMethod.afterpay),
        ),
        const SizedBox(height: 10),
        _PaymentOptionTile(
          label: 'Klarna',
          iconData: Icons.account_balance_outlined,
          iconColor: const Color(0xFFFF6900),
          isSelected: _selectedMethod == _PaymentMethod.klarna,
          onTap: () => setState(() => _selectedMethod = _PaymentMethod.klarna),
        ),
      ],
    );
  }

  // ── Pay Now button ───────────────────────────────────────────
  Widget _buildPayButton() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 16),
      child: AppContinueButton(
        text: 'Pay Now',
        showArrow: false,
        onPressed: _payNow,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF003A8A) : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF003A8A),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _CardBrandIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  const _CardBrandIcon(this.iconData, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Icon(iconData, color: color, size: 14),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151),
      ),
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const _CheckoutTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1A1A1A)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF9CA3AF),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatefulWidget {
  const _CountryDropdown();

  @override
  State<_CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<_CountryDropdown> {
  String _selected = 'Hong Kong SAR China';

  static const List<String> _countries = [
    'Hong Kong SAR China',
    'India',
    'United States',
    'United Kingdom',
    'Australia',
    'Canada',
    'Singapore',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selected,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF6C7278),
            size: 20,
          ),
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF1A1A1A),
          ),
          items: _countries
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selected = v);
          },
        ),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.label,
    required this.iconData,
    required this.iconColor,
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
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003A8A)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _RadioDot(selected: isSelected),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
