import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app/app/routing/app_routes.dart';
import 'package:flutter_app/core/widgets/app_expandable_card.dart';
import 'package:flutter_app/core/widgets/second_app_header.dart';
import 'package:flutter_app/features/rfq/data/datasources/rfq_data.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';
import 'package:flutter_app/features/rfq/presentation/cubit/rfq_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RFQRequestsScreen extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const RFQRequestsScreen({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  State<RFQRequestsScreen> createState() => _RFQRequestsScreenState();
}

class _RFQRequestsScreenState extends State<RFQRequestsScreen> {
  final RfqListCubit _rfqListCubit = RfqListCubit();

  List<RFQ> get _filtered => RFQData.getByStatus(_rfqListCubit.state.filter);

  void _openRfq(RFQ rfq) {
    context.push<bool>(AppRoutes.rfqDetail, extra: rfq).then((changed) {
      if (changed == true && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _rfqListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RfqListCubit, RfqListState>(
      bloc: _rfqListCubit,
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
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              SecondAppHeader(
                title: 'RFQ Requests',
                showBackButton: widget.showBackButton,
                onBackPressed:
                    widget.onBackPressed ??
                    () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 18, right: 15),
                  child: Column(
                    children: [
                      _buildFilterTabs(),
                      Expanded(
                        child: _filtered.isEmpty
                            ? _buildEmpty()
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
                                itemCount: _filtered.length,
                                itemBuilder: (context, index) {
                                  final rfq = _filtered[index];
                                  return AppExpandableCard(
                                    imagePath: rfq.imagePath,
                                    title: rfq.productTitle,
                                    idNumber: rfq.rfqNumber,
                                    price: rfq.price,
                                    statusText: rfq.status.displayName,
                                    statusBackgroundColor:
                                        rfq.status.backgroundColor,
                                    statusTextColor: rfq.status.textColor,
                                    maxWidth: double.infinity,
                                    onTap: () => _openRfq(rfq),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€ Filter Tabs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 28, 0, 11),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tab(label: 'All', value: null),
          const SizedBox(width: 12.85),
          _tab(label: 'New', value: RFQStatus.newRequest),
          const SizedBox(width: 12.85),
          _tab(label: 'Open', value: RFQStatus.open),
        ],
      ),
    );
  }

  Widget _tab({required String label, required RFQStatus? value}) {
    final isActive = _rfqListCubit.state.filter == value;
    return GestureDetector(
      onTap: () => _rfqListCubit.selectFilter(value),
      child: Container(
        width: 72.43,
        height: 27,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF003A8A) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF003A8A), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF003A8A),
            height: 18 / 12,
            letterSpacing: -0.14,
          ),
        ),
      ),
    );
  }

  // â”€â”€ Empty State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'No RFQ requests found',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
