import 'package:flutter_app/features/catalog/domain/entities/vendor.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// Mock data for the vendor screens.
class VendorData {
  static const String _img =
      'assets/solarimages/solar_panel_product.png';

  static const String _aboutText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting '
      'industry. Lorem Ipsum has been the industry standard dummy text ever '
      'since the 1500s, when an unknown printer took a galley of type and '
      'scrambled it.';

  static const List<CatalogProduct> vendorProducts = [
    CatalogProduct(
      id: 'sp_1',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_2',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_3',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_4',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_5',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'sp_6',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.100+',
      imagePath: _img,
    ),
  ];

  static final Vendor demoVendor = Vendor(
    id: 'sup_1',
    name: 'SunTech Energy Solutions',
    badge: 'Verified Seller',
    rating: 4.8,
    totalOrders: 500,
    aboutText: _aboutText,
    iconPath:
        'assets/images/solartradeshub_logo.png',
    mainProducts: vendorProducts,
  );

  static const List<CatalogProduct> rfqCartItems = [
    CatalogProduct(
      id: 'rfq_1',
      name: 'Solar Trade',
      subtitle: 'By SunTech Sol.',
      price: 'Rs.10000+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'rfq_2',
      name: 'Solar Trade',
      subtitle: 'By SunTech Sol.',
      price: 'Rs.10000+',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'rfq_3',
      name: 'Solar Trade',
      subtitle: 'By SunTech Sol.',
      price: 'Rs.10000+',
      imagePath: _img,
    ),
  ];
}
