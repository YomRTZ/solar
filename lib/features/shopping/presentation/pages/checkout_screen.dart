import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/core/validation/app_form_validation.dart';
import 'package:flutter_app/features/shopping/presentation/cubit/checkout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_rfq_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';
import 'package:flutter_app/features/orders/data/datasources/orders_data.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';

class CheckoutScreen extends StatefulWidget {
  final CatalogRfqRequest? request;

  const CheckoutScreen({super.key, this.request});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final CheckoutCubit _checkoutCubit = CheckoutCubit();

  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _checkoutCubit.close();
    super.dispose();
  }

  void _payNow() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final request = widget.request;
    if (isValid && request != null) {
      _createOrder(request);
      CatalogRfqData.updateStatus(request.id, CatalogRfqStatus.ordered);
    }
    context.go(AppRoutes.vendorPaymentStatus, extra: isValid);
  }

  void _createOrder(CatalogRfqRequest request) {
    final subtotal = _parseAmount(request.subTotal);
    final quantity = request.items.fold<int>(
      0,
      (total, item) =>
          total +
          (int.tryParse(RegExp(r'\d+').firstMatch(item.qty)?.group(0) ?? '') ??
              1),
    );
    final orderQuantity = quantity == 0 ? 1 : quantity;
    final now = DateTime.now();
    OrdersData.add(
      Order(
        id: '#ORD${now.microsecondsSinceEpoch}',
        productName: request.items.map((item) => item.productName).join(', '),
        productImagePath: 'assets/solarimages/solar_panel_product.png',
        price: (subtotal / orderQuantity).toStringAsFixed(0),
        deliveryLocation: 'New Delhi',
        buyer: 'Vendor',
        orderDate: '${now.day} ${_monthName(now.month)} ${now.year}',
        status: OrderStatus.pending,
        quantity: orderQuantity,
        subtotal: subtotal,
        gstPercent: subtotal == 0
            ? 18
            : _parseAmount(request.gst) / subtotal * 100,
      ),
    );
  }

  double _parseAmount(String value) =>
      double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  String _monthName(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      bloc: _checkoutCubit,
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
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SecondAppHeader(
                  title: 'Checkout (Ui will be Different)',
                  titleMaxLines: 2,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 28, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDeliverySection(),
                        const SizedBox(height: 16),
                        _buildCardSection(),
                        const SizedBox(height: 8),
                        _buildAlternativePayments(),
                      ],
                    ),
                  ),
                ),
                _buildPayButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliverySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: GoogleFonts.inter(
                  fontSize: 12,
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
              color: const Color(0xFF202020),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection() {
    final isCardSelected =
        _checkoutCubit.state.paymentMethod == PaymentMethod.card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFFAFAFC),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _checkoutCubit.selectPaymentMethod(PaymentMethod.card),
            child: Row(
              children: [
                _RadioDot(
                  selected: isCardSelected,
                  selectedColor: const Color(0xFF6558F5),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.credit_card_rounded,
                  color: Color(0xFF6558F5),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  'Card',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6558F5),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (isCardSelected)
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _FieldLabel(label: 'Card number'),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_payment_visa.svg',
                          width: 24,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/icons/ic_payment_card_blue.svg',
                          width: 24,
                          height: 16,
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/icons/ic_payment_discover.svg',
                          width: 24,
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
                _CheckoutTextField(
                  label: 'Card number',
                  controller: _cardNumberController,
                  hintText: '1234 1234 1234 1234',
                  keyboardType: TextInputType.number,
                  onChanged: _checkoutCubit.updateCardNumber,
                ),
                const SizedBox(height: 12),
                const _FieldLabel(label: 'Expiration'),
                _CheckoutTextField(
                  label: 'Expiration',
                  controller: _expiryController,
                  hintText: 'MM/YY',
                  keyboardType: TextInputType.datetime,
                  onChanged: _checkoutCubit.updateExpiry,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel(label: 'CVC'),
                          _CheckoutTextField(
                            label: 'CVC',
                            controller: _cvcController,
                            hintText: 'CVC',
                            keyboardType: TextInputType.number,
                            onChanged: _checkoutCubit.updateCvc,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Icon(
                        Icons.credit_card_rounded,
                        color: Color(0xFFB8B8B8),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _FieldLabel(label: 'Country'),
                _CountryDropdown(cubit: _checkoutCubit),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAlternativePayments() {
    return Column(
      children: [
        _PaymentOptionTile(
          label: 'Afterpay',
          icon: SvgPicture.asset(
            'assets/icons/ic_payment_afterpay.svg',
            width: 20,
            height: 20,
          ),
          isSelected:
              _checkoutCubit.state.paymentMethod == PaymentMethod.afterpay,
          onTap: () =>
              _checkoutCubit.selectPaymentMethod(PaymentMethod.afterpay),
        ),
        _PaymentOptionTile(
          label: 'Klarna',
          icon: SvgPicture.asset(
            'assets/icons/ic_payment_klarna.svg',
            width: 20,
            height: 20,
          ),
          isSelected:
              _checkoutCubit.state.paymentMethod == PaymentMethod.klarna,
          onTap: () => _checkoutCubit.selectPaymentMethod(PaymentMethod.klarna),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, 12, 24, bottom + 16),
      child: AppContinueButton(
        text: 'Pay Now',
        height: 44,
        showArrow: false,
        backgroundColor: const Color(0xFF003A8A),
        onPressed: _payNow,
      ),
    );
  }
}


class _RadioDot extends StatelessWidget {
  final bool selected;
  final Color selectedColor;

  const _RadioDot({
    required this.selected,
    this.selectedColor = const Color(0xFF003A8A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? selectedColor : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
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
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
}

class _CheckoutTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const _CheckoutTextField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: (value) =>
          AppFormValidation.requiredText(value, fieldName: label),
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 22,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF1A1A1A),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (field.errorText != null) AppFormErrorText(field.errorText!),
        ],
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  final CheckoutCubit cubit;

  const _CountryDropdown({required this.cubit});

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
    return SizedBox(
      height: 24,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: cubit.state.country,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF9CA3AF),
            size: 20,
          ),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6C7278),
          ),
          items: _countries
              .map(
                (country) =>
                    DropdownMenuItem(value: country, child: Text(country)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) cubit.selectCountry(value);
          },
        ),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _RadioDot(
              selected: isSelected,
              selectedColor: const Color(0xFF6254F5),
            ),
            const SizedBox(width: 22),
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6C7278),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
