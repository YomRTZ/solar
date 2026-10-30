import 'package:flutter/material.dart';

/// RFQ (Request For Quote) model
class RFQ {
  final String id;
  final String rfqNumber;
  final String productTitle;
  final String imagePath;
  final String price;
  final String requiredQty;
  final String location;
  final String buyerName;
  final String expectedDelivery;
  final RFQStatus status;

  const RFQ({
    required this.id,
    required this.rfqNumber,
    required this.productTitle,
    required this.imagePath,
    required this.price,
    required this.requiredQty,
    required this.location,
    required this.buyerName,
    required this.expectedDelivery,
    required this.status,
  });
}

enum RFQStatus { newRequest, open, approved, rejected, pending }

extension RFQStatusExtension on RFQStatus {
  String get displayName {
    switch (this) {
      case RFQStatus.newRequest:
        return 'New';
      case RFQStatus.open:
        return 'Open';
      case RFQStatus.approved:
        return 'Approved';
      case RFQStatus.rejected:
        return 'Rejected';
      case RFQStatus.pending:
        return 'Pending';
    }
  }

  /// Badge background color
  Color get backgroundColor {
    switch (this) {
      case RFQStatus.newRequest:
        return const Color(0xFFD3F3E1);
      case RFQStatus.open:
        return const Color(0xFFC3E1FE);
      case RFQStatus.approved:
        return const Color(0xFFD3F3E1);
      case RFQStatus.rejected:
        return const Color(0xFFB31515);
      case RFQStatus.pending:
        return const Color(0xFFFFD78E);
    }
  }

  /// Badge text color
  Color get textColor {
    switch (this) {
      case RFQStatus.newRequest:
        return const Color(0xFF217552);
      case RFQStatus.open:
        return const Color(0xFF113CF5);
      case RFQStatus.approved:
        return const Color(0xFF217552);
      case RFQStatus.rejected:
        return const Color(0xFFFFFFFF);
      case RFQStatus.pending:
        return const Color(0xFFFFA500);
    }
  }
}
