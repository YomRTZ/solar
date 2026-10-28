import 'package:flutter/material.dart';

/// Status of an RFQ request
enum AddTenderRfqStatus { received, pending }

extension AddTenderRfqStatusX on AddTenderRfqStatus {
  String get label {
    switch (this) {
      case AddTenderRfqStatus.received:
        return 'Received';
      case AddTenderRfqStatus.pending:
        return 'Pending';
    }
  }

  Color get bgColor {
    switch (this) {
      case AddTenderRfqStatus.received:
        return const Color(0xFFD1FAE5);
      case AddTenderRfqStatus.pending:
        return const Color(0xFFFFF3E0);
    }
  }

  Color get textColor {
    switch (this) {
      case AddTenderRfqStatus.received:
        return const Color(0xFF065F46);
      case AddTenderRfqStatus.pending:
        return const Color(0xFFE65100);
    }
  }
}

/// A single RFQ request shown in the RFQ Requests list
class AddTenderRfqRequest {
  final String id;
  final String supplierName;
  final String amount;
  final String dateLabel; // e.g. "Valid till 26th Oct'25"
  final AddTenderRfqStatus status;

  /// Line items in the order breakdown sheet
  final List<AddTenderOrderItem> items;
  final String subTotal;
  final String gst;
  final String total;

  const AddTenderRfqRequest({
    required this.id,
    required this.supplierName,
    required this.amount,
    required this.dateLabel,
    required this.status,
    required this.items,
    required this.subTotal,
    required this.gst,
    required this.total,
  });
}

/// A single line item in the order breakdown
class AddTenderOrderItem {
  final String productName;
  final String qty;   // e.g. "10x1 ="
  final String price; // e.g. "Rs. 2,23,000"

  const AddTenderOrderItem({
    required this.productName,
    required this.qty,
    required this.price,
  });
}
