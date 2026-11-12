import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/app_header.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';

class TransporterMyBidsScreen extends StatelessWidget {
  const TransporterMyBidsScreen({super.key});

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
            const AppHeader(title: 'My Bids'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(19, 17, 15, 20),
                itemCount: TransporterBid.sampleBids.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _TransporterBidCard(bid: TransporterBid.sampleBids[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransporterBidCard extends StatelessWidget {
  final TransporterBid bid;

  const _TransporterBidCard({required this.bid});

  Color get _statusColor => switch (bid.status) {
    TransporterBidStatus.requested => const Color(0xFFFFCC00),
    TransporterBidStatus.rejected => const Color(0xFFFF0000),
    TransporterBidStatus.approved => const Color(0xFF34C759),
  };

  String get _statusText => switch (bid.status) {
    TransporterBidStatus.requested => 'Bid Requested',
    TransporterBidStatus.rejected => 'Bid Rejected',
    TransporterBidStatus.approved => 'Bid Approved',
  };

  @override
  Widget build(BuildContext context) {
    final job = bid.job;
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD8D8D8)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.route,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    letterSpacing: 0,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              Text(
                bid.timeSinceRequest,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1,
                  letterSpacing: 0,
                  color: Color(0xFF808080),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _BidDetail(label: 'Vehicle', value: job.vehicle),
              _BidDetail(label: 'Weight', value: job.weight),
              _BidDetail(label: 'Date', value: job.date),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Divider(height: 1, color: Color(0xFFE5E5E5)),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rs. ${job.price}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF202020),
                  ),
                ),
              ),
              Text(
                _statusText,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: 0,
                  color: _statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BidDetail extends StatelessWidget {
  final String label;
  final String value;

  const _BidDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
              color: Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
