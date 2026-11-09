import 'package:flutter/material.dart';

// Status of an RFQ request
enum CatalogRfqStatus { received, pending, ordered, rejected }

extension CatalogRfqStatusX on CatalogRfqStatus {
  String get label {
    switch (this) {
      case CatalogRfqStatus.received:
        return 'Received';
      case CatalogRfqStatus.pending:
        return 'Pending';
      case CatalogRfqStatus.ordered:
        return 'Ordered';
      case CatalogRfqStatus.rejected:
        return 'Rejected';
    }
  }

  Color get bgColor {
    switch (this) {
      case CatalogRfqStatus.received:
        return const Color(0xFFD1FAE5);
      case CatalogRfqStatus.pending:
        return const Color(0xFFFFF3E0);
      case CatalogRfqStatus.ordered:
        return const Color(0xFFDCEBFF);
      case CatalogRfqStatus.rejected:
        return const Color(0xFFFEE2E2);
    }
  }

  Color get textColor {
    switch (this) {
      case CatalogRfqStatus.received:
        return const Color(0xFF065F46);
      case CatalogRfqStatus.pending:
        return const Color(0xFFE65100);
      case CatalogRfqStatus.ordered:
        return const Color(0xFF003A8A);
      case CatalogRfqStatus.rejected:
        return const Color(0xFFB31515);
    }
  }
}

// A single RFQ request shown in the RFQ Requests list
class CatalogRfqRequest {
  final String id;
  final String supplierName;
  final String amount;
  final String dateLabel; // e.g. "Valid till 26th Oct'25"
  final CatalogRfqStatus status;

  // Line items in the order breakdown sheet
  final List<CatalogOrderItem> items;
  final String subTotal;
  final String gst;
  final String total;

  const CatalogRfqRequest({
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

  CatalogRfqRequest copyWith({
    CatalogRfqStatus? status,
    String? supplierName,
    String? amount,
    String? dateLabel,
    List<CatalogOrderItem>? items,
    String? subTotal,
    String? gst,
    String? total,
  }) => CatalogRfqRequest(
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
class CatalogOrderItem {
  final String productName;
  final String qty; // e.g. "10x1 ="
  final String price; // e.g. "Rs. 2,23,000"

  const CatalogOrderItem({
    required this.productName,
    required this.qty,
    required this.price,
  });
}
