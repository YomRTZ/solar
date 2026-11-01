import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/core/widgets/app_text_field.dart';
import 'package:flutter_app/core/widgets/app_continue_button.dart';
import 'package:flutter_app/core/widgets/app_form_section.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/rfq/data/datasources/rfq_data.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';
import 'package:flutter_app/features/rfq/presentation/cubit/rfq_cubit.dart';
import 'package:flutter_app/features/vendor/data/datasources/vendor_rfq_data.dart';
import 'package:flutter_app/features/vendor/domain/entities/vendor_rfq_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Two-phase screen: Phase 1 — shows product detail + "Quote Now" / "Reject Quote" buttons Phase 2
class RFQDetailScreen extends StatefulWidget {
  final RFQ rfq;

  const RFQDetailScreen({super.key, required this.rfq});

  @override
  State<RFQDetailScreen> createState() => _RFQDetailScreenState();
}

class _RFQDetailScreenState extends State<RFQDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late final RfqDetailCubit _rfqCubit;

  // Quote form controllers
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill from RFQ data
    _quantityController.text = widget.rfq.requiredQty;
    _unitPriceController.text = widget.rfq.quoteUnitPrice ?? widget.rfq.price;
    _gstController.text = widget.rfq.quoteGst ?? '18%';
    _deliveryDateController.text =
        widget.rfq.quoteDeliveryDate ?? widget.rfq.expectedDelivery;
    _rfqCubit = RfqDetailCubit(
      initialState: RfqDetailState(
        quantity: _quantityController.text,
        unitPrice: _unitPriceController.text,
        gst: _gstController.text,
        deliveryDate: _deliveryDateController.text,
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitPriceController.dispose();
    _gstController.dispose();
    _deliveryDateController.dispose();
    _rfqCubit.close();
    super.dispose();
  }

  void _onQuoteNow() => _rfqCubit.showQuoteForm();

  void _onRejectQuote() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Reject Quote',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to reject this RFQ?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              RFQData.updateStatus(widget.rfq.id, RFQStatus.rejected);
              VendorRfqData.updateStatus(
                widget.rfq.id,
                VendorRfqStatus.rejected,
              );
              Navigator.pop(context, true);
            },
            child: const Text(
              'Reject',
              style: TextStyle(color: Color(0xFFB31515)),
            ),
          ),
        ],
      ),
    );
  }

  void _onSendQuote() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _rfqCubit.setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    _rfqCubit.setLoading(false);
    final state = _rfqCubit.state;
    final updatedRfq = widget.rfq.copyWith(
      status: RFQStatus.pending,
      quoteUnitPrice: state.unitPrice.trim(),
      quoteGst: state.gst.trim(),
      quoteDeliveryDate: state.deliveryDate.trim(),
    );
    if (RFQData.update(updatedRfq)) {
      final quantity =
          int.tryParse(
            RegExp(r'\d+').firstMatch(widget.rfq.requiredQty)?.group(0) ?? '',
          ) ??
          1;
      final unitPrice = _parseAmount(state.unitPrice);
      final gstPercent = _parseAmount(state.gst);
      final subtotal = unitPrice * quantity;
      final gstAmount = subtotal * gstPercent / 100;
      final request = VendorRfqData.getById(widget.rfq.id);
      VendorRfqData.receiveQuote(
        widget.rfq.id,
        supplierName: request?.supplierName ?? 'Supplier',
        amount: _formatAmount(subtotal + gstAmount),
        dateLabel:
            'Quote received ${DateTime.now().toLocal().toString().split(' ').first}',
        items: [
          VendorOrderItem(
            productName: widget.rfq.productTitle,
            qty: '$quantity x 1 =',
            price: _formatAmount(subtotal),
          ),
        ],
        subTotal: _formatAmount(subtotal),
        gst: _formatAmount(gstAmount),
        total: _formatAmount(subtotal + gstAmount),
      );
    }
    Navigator.pop(context, true);
  }

  double _parseAmount(String value) =>
      double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

  String _formatAmount(double value) => 'Rs. ${value.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RfqDetailCubit, RfqDetailState>(
      bloc: _rfqCubit,
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
              SecondAppHeader(
                title: 'RFQ Detail',
                onBackPressed: () {
                  if (state.showQuoteForm) {
                    _rfqCubit.hideQuoteForm();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Expanded(
                child: state.showQuoteForm
                    ? _buildQuoteForm(state)
                    : _buildDetailView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════ PHASE 1 — Detail View
  Widget _buildDetailView() {
    final rfq = widget.rfq;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image banner
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
            child: Image.asset(
              rfq.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RFQ number row + title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rfq.rfqNumber,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 22 / 14,
                              letterSpacing: -0.18,
                              color: const Color(0xFF202020),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By ${rfq.buyerName}',
                            style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 16 / 13,
                              letterSpacing: 0,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          rfq.productTitle,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 22 / 14,
                            letterSpacing: -0.18,
                            color: const Color(0xFF202020),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rfq.location,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 16 / 13,
                            letterSpacing: 0,
                            color: const Color(0xFF4E4C4C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Required
                _detailRow('Required', rfq.requiredQty),
                const SizedBox(height: 12),

                // Expected Delivery
                _detailRow('Expected Delivery', rfq.expectedDelivery),
                const SizedBox(height: 32),

                // Quote Now button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onQuoteNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003D82),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: -0.14,
                      ),
                    ),
                    child: const Text('Quote Now', textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(height: 12),

                // Reject Quote button
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: Color(0xFFD01010)),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x1FFFFFFF), Color(0x00FFFFFF)],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _onRejectQuote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              letterSpacing: -0.14,
                            ),
                          ),
                          child: const Text(
                            'Reject Quote',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 16 / 13,
            letterSpacing: 0,
            color: const Color(0xFF000000),
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.right,
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 16 / 13,
            letterSpacing: 0,
            color: const Color(0xFF4E4C4C),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════ PHASE 2 — Quote Form
  Widget _buildQuoteForm(RfqDetailState state) {
    final rfq = widget.rfq;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mini product header
          Row(
            children: [
              Container(
                width: 86.62332153320312,
                height: 85.76611328125,
                margin: const EdgeInsets.fromLTRB(13.38, 17.23, 0, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  rfq.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported_outlined),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rfq.productTitle,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF202020),
                  ),
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: AppFormSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _formLabel('Quantity'),
                  const SizedBox(height: 6),
                  _readOnlyField(state.quantity),
                  const SizedBox(height: 16),
                  _formLabel('Unit Price'),
                  const SizedBox(height: 6),
                  AppTextField(
                    label: '',
                    hint: '12,340',
                    controller: _unitPriceController,
                    keyboardType: TextInputType.number,
                    bottomSpacing: 0,
                    onChanged: _rfqCubit.setUnitPrice,
                  ),
                  const SizedBox(height: 16),
                  _formLabel('Gst'),
                  const SizedBox(height: 6),
                  AppTextField(
                    label: '',
                    hint: '18%',
                    controller: _gstController,
                    keyboardType: TextInputType.number,
                    bottomSpacing: 0,
                    onChanged: _rfqCubit.setGst,
                  ),
                  const SizedBox(height: 16),
                  _formLabel('Delivery Date'),
                  const SizedBox(height: 6),
                  AppTextField(
                    label: '',
                    hint: '20 Oct 2026',
                    controller: _deliveryDateController,
                    bottomSpacing: 0,
                    onChanged: _rfqCubit.setDeliveryDate,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: AppContinueButton(
                      text: 'Send Quote',
                      showArrow: false,
                      isLoading: state.isLoading,
                      onPressed: _onSendQuote,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 1.6,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.24,
        color: const Color(0xFF6C7278),
      ),
    );
  }

  // Read-only styled box (Quantity is pre-filled, not editable)
  Widget _readOnlyField(String value) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDF1F3), width: 1),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        value,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF000000),
        ),
      ),
    );
  }
}
