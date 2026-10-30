import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';

/// Mock data used exclusively on the Dashboard / Home screen
class DashboardData {
  // ── Stats ──────────────────────────────────────────────────
  static const int allProducts = 234;
  static const int newRFQs = 23;
  static const int orders = 23;
  static const double myBalance = 234;

  // ── Recent RFQs ────────────────────────────────────────────
  static final List<RFQ> recentRFQs = [
    RFQ(
      id: 'dash_1',
      rfqNumber: '#RFQ123456',
      productTitle: '10 KW Solar Panel',
      // first card image
      imagePath:
          'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      price: '100000',
      requiredQty: '20 Units',
      location: 'Pune, Maharashtra',
      buyerName: 'Green Energy Installers',
      expectedDelivery: '20 Oct 2026',
      status: RFQStatus.newRequest,
    ),
    RFQ(
      id: 'dash_2',
      rfqNumber: '#RFQ123456',
      productTitle: '5 KW Solar Panel',
      // second card image
      imagePath:
          'assets/solarimages/8c95b22c561eba1d7752be96d662579cfd873d93.jpg',
      price: '23000',
      requiredQty: '10 Units',
      location: 'Mumbai, Maharashtra',
      buyerName: 'SunPower Solutions',
      expectedDelivery: '25 Oct 2026',
      status: RFQStatus.open,
    ),
  ];
}
