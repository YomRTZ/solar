import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/second_app_header.dart';

class BidsReceivedScreen extends StatefulWidget {
  const BidsReceivedScreen({super.key});

  @override
  State<BidsReceivedScreen> createState() => _BidsReceivedScreenState();
}

class _BidsReceivedScreenState extends State<BidsReceivedScreen> {
  final Set<int> _rejectedBidIds = {};

  static const _bids = [
    _SupplierBid(
      id: 1,
      supplierName: 'Sharma Motors',
      rating: '4.8',
      baseFare: 23000,
      loadingCharges: 2000,
      unloadingCharges: 2000,
      otherCharges: 1000,
    ),
    _SupplierBid(
      id: 2,
      supplierName: 'Sharma Motors',
      rating: '4.8',
      baseFare: 23000,
      loadingCharges: 2000,
      unloadingCharges: 2000,
      otherCharges: 1000,
    ),
    _SupplierBid(
      id: 3,
      supplierName: 'Sharma Motors',
      rating: '4.8',
      baseFare: 23000,
      loadingCharges: 2000,
      unloadingCharges: 2000,
      otherCharges: 1000,
    ),
  ];

  Future<void> _showBidDetails(_SupplierBid bid) async {
    final accepted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BidPriceBreakupSheet(bid: bid),
    );
    if (!mounted) return;
    if (accepted == true) {
      context.pop(true);
    } else if (accepted == false) {
      setState(() => _rejectedBidIds.add(bid.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${bid.supplierName} bid rejected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleBids = _bids
        .where((bid) => !_rejectedBidIds.contains(bid.id))
        .toList();
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
            const SecondAppHeader(title: 'Bids Received'),
            Expanded(
              child: visibleBids.isEmpty
                  ? Center(
                      child: Text(
                        'No bids available',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: const Color(0xFF6C7278),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                      itemCount: visibleBids.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final bid = visibleBids[index];
                        return _BidCard(
                          bid: bid,
                          onViewDetails: () => _showBidDetails(bid),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupplierBid {
  const _SupplierBid({
    required this.id,
    required this.supplierName,
    required this.rating,
    required this.baseFare,
    required this.loadingCharges,
    required this.unloadingCharges,
    required this.otherCharges,
  });

  final int id;
  final String supplierName;
  final String rating;
  final int baseFare;
  final int loadingCharges;
  final int unloadingCharges;
  final int otherCharges;

  int get total => baseFare + loadingCharges + unloadingCharges + otherCharges;
}

class _BidCard extends StatelessWidget {
  const _BidCard({required this.bid, required this.onViewDetails});

  final _SupplierBid bid;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E8EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                key: ValueKey('received-bid-avatar-${bid.id}'),
                radius: 22,
                backgroundImage: const AssetImage(
                  'assets/solarimages/avater.png',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.supplierName,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF202020),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          bid.rating,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4E4C4C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Today',
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: const Color(0xFF808890),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rs. ${_formatAmount(bid.total)}',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF202020),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onViewDetails,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF003A8A),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 34),
                textStyle: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BidPriceBreakupSheet extends StatefulWidget {
  const _BidPriceBreakupSheet({required this.bid});

  final _SupplierBid bid;

  @override
  State<_BidPriceBreakupSheet> createState() => _BidPriceBreakupSheetState();
}

class _BidPriceBreakupSheetState extends State<_BidPriceBreakupSheet> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message sent to ${widget.bid.supplierName}')),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bid = widget.bid;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            14,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DDE2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'Price Breakup',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF202020),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const CircleAvatar(
                    key: ValueKey('received-bid-details-avatar'),
                    radius: 20,
                    backgroundImage: AssetImage(
                      'assets/solarimages/avater.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bid.supplierName,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB800),
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              bid.rating,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: const Color(0xFF6C7278),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Today',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: const Color(0xFF6C7278),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFE7EAED)),
              const SizedBox(height: 14),
              _priceRow('Base Fare', bid.baseFare),
              _priceRow('Loading Charges', bid.loadingCharges),
              _priceRow('Unloading Charges', bid.unloadingCharges),
              _priceRow('Toll / Other Charges', bid.otherCharges),
              const Divider(height: 22, color: Color(0xFFE7EAED)),
              _priceRow('Total', bid.total, isTotal: true),
              const SizedBox(height: 18),
              TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Message to driver',
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF003A8A),
                      size: 20,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E5EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE0E5EB)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      label: 'Reject Bid',
                      color: const Color(0xFFC62828),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      label: 'Accept Bid',
                      color: const Color(0xFF218838),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, int amount, {bool isTotal = false}) {
    final style = GoogleFonts.roboto(
      fontSize: isTotal ? 14 : 13,
      fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
      color: const Color(0xFF202020),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('Rs. ${_formatAmount(amount)}', style: style),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

String _formatAmount(int amount) {
  return amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
}
