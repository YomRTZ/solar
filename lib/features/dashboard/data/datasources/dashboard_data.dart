import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';

// Mock data used on the supplier Dashboard screen
class DashboardData {
  static const int allProducts = 234;
  static const int newRFQs = 23;
  static const int orders = 23;
  static const double myBalance = 234;

  static final List<RFQ> recentRFQs = [
    RFQ(
      id: 'dash_1',
      rfqNumber: '#RFQ123456',
      productTitle: '10 KW Solar Panel',
      imagePath:
          'assets/solarimages/solar_panel_product.png',
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
      imagePath:
          'assets/solarimages/solar_panel_ground_installation.jpg',
      price: '23000',
      requiredQty: '10 Units',
      location: 'Mumbai, Maharashtra',
      buyerName: 'SunPower Solutions',
      expectedDelivery: '25 Oct 2026',
      status: RFQStatus.open,
    ),
  ];
}
