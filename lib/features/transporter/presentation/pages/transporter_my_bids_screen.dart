import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/transporter/domain/entities/transporter_job.dart';
import 'package:flutter_app/features/transporter/presentation/cubit/transporter_cubit.dart';

class TransporterMyBidsScreen extends StatelessWidget {
  const TransporterMyBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransporterCubit, TransporterState>(
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
        body: Column(
          children: [
            const SecondAppHeader(title: 'My Bids'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(19, 24, 11, 20),
                itemCount: state.myBids.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _TransporterBidCard(bid: state.myBids[index]),
              ),
            ),
          ],
        ),
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
      height: 134,
      padding: const EdgeInsets.fromLTRB(9, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD3D3D3), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Row(
            children: [
              _BidDetail(label: 'Vehicle', value: job.vehicle),
              _BidDetail(label: 'Weight', value: job.weight),
              _BidDetail(label: 'Date', value: job.date),
            ],
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rs. ${job.price}',
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
