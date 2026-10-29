import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_continue_button.dart';
import '../../core/widgets/second_app_header.dart';
import '../../models/rfq.dart';

/// Two-phase screen:
///  Phase 1 — shows product detail + "Quote Now" / "Reject Quote" buttons
///  Phase 2 — shows quote form (Quantity, Unit Price, Gst, Delivery Date) + "Send Quote"
class RFQDetailScreen extends StatefulWidget {
  final RFQ rfq;

  const RFQDetailScreen({super.key, required this.rfq});

  @override
  State<RFQDetailScreen> createState() => _RFQDetailScreenState();
}

class _RFQDetailScreenState extends State<RFQDetailScreen> {
  /// false = detail view, true = quote form view
  bool _showQuoteForm = false;

  // Quote form controllers
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from RFQ data
    _quantityController.text = '20 Units';
    _unitPriceController.text = '12,340';
    _gstController.text = '18%';
    _deliveryDateController.text = '20 Oct 2026';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitPriceController.dispose();
    _gstController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  void _onQuoteNow() => setState(() => _showQuoteForm = true);

  void _onRejectQuote() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to list
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
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context); // back to RFQ list
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                if (_showQuoteForm) {
                  setState(() => _showQuoteForm = false);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            Expanded(
              child: _showQuoteForm ? _buildQuoteForm() : _buildDetailView(),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════
  // PHASE 1 — Detail View
  // ══════════════════════════════════════════════════════════
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

  // ══════════════════════════════════════════════════════════
  // PHASE 2 — Quote Form
  // ══════════════════════════════════════════════════════════
  Widget _buildQuoteForm() {
    final rfq = widget.rfq;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini product header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
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
              Text(
                rfq.productTitle,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF202020),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quantity
          _formLabel('Quantity'),
          const SizedBox(height: 6),
          _readOnlyField(_quantityController.text),
          const SizedBox(height: 20),

          // Unit Price
          _formLabel('Unit Price'),
          const SizedBox(height: 6),
          AppTextField(
            label: '',
            hint: '12,340',
            controller: _unitPriceController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          // Gst
          _formLabel('Gst'),
          const SizedBox(height: 6),
          AppTextField(
            label: '',
            hint: '18%',
            controller: _gstController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          // Delivery Date
          _formLabel('Delivery Date'),
          const SizedBox(height: 6),
          AppTextField(
            label: '',
            hint: '20 Oct 2026',
            controller: _deliveryDateController,
          ),
          const SizedBox(height: 32),

          // Send Quote button
          AppContinueButton(
            text: 'Send Quote',
            showArrow: false,
            isLoading: _isLoading,
            onPressed: _onSendQuote,
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

  /// Read-only styled box (Quantity is pre-filled, not editable)
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
