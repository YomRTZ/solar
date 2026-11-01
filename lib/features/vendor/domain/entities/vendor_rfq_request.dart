import 'package:flutter/material.dart';

// Status of an RFQ request
enum VendorRfqStatus { received, pending, ordered, rejected }

extension VendorRfqStatusX on VendorRfqStatus {
  String get label {
    switch (this) {
      case VendorRfqStatus.received:
        return 'Received';
      case VendorRfqStatus.pending:
        return 'Pending';
      case VendorRfqStatus.ordered:
        return 'Ordered';
      case VendorRfqStatus.rejected:
        return 'Rejected';
    }
  }

  Color get bgColor {
    switch (this) {
      case VendorRfqStatus.received:
        return const Color(0xFFD1FAE5);
      case VendorRfqStatus.pending:
        return const Color(0xFFFFF3E0);
      case VendorRfqStatus.ordered:
        return const Color(0xFFDCEBFF);
      case VendorRfqStatus.rejected:
        return const Color(0xFFFEE2E2);
    }
  }

  Color get textColor {
    switch (this) {
      case VendorRfqStatus.received:
        return const Color(0xFF065F46);
      case VendorRfqStatus.pending:
        return const Color(0xFFE65100);
      case VendorRfqStatus.ordered:
        return const Color(0xFF003A8A);
      case VendorRfqStatus.rejected:
        return const Color(0xFFB31515);
    }
  }
}

// A single RFQ request shown in the RFQ Requests list
class VendorRfqRequest {
  final String id;
  final String supplierName;
  final String amount;
  final String dateLabel; // e.g. "Valid till 26th Oct'25"
  final VendorRfqStatus status;

  // Line items in the order breakdown sheet
  final List<VendorOrderItem> items;
  final String subTotal;
  final String gst;
  final String total;

  const VendorRfqRequest({
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

  VendorRfqRequest copyWith({
    VendorRfqStatus? status,
    String? supplierName,
    String? amount,
    String? dateLabel,
    List<VendorOrderItem>? items,
    String? subTotal,
    String? gst,
    String? total,
  }) => VendorRfqRequest(
    id: id,
    supplierName: supplierName ?? this.supplierName,
    amount: amount ?? this.amount,
    dateLabel: dateLabel ?? this.dateLabel,
    status: status ?? this.status,
    items: items ?? this.items,
    subTotal: subTotal ?? this.subTotal,
    gst: gst ?? this.gst,
    total: total ?? this.total,
  );
}

// A single line item in the order breakdown
class VendorOrderItem {
  final String productName;
  final String qty; // e.g. "10x1 ="
  final String price; // e.g. "Rs. 2,23,000"

  const VendorOrderItem({
    required this.productName,
    required this.qty,
    required this.price,
  });
}
