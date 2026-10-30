import 'package:flutter_app/features/vendor/domain/entities/vendor_category.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// Mock data used across the three Vendor screens
class VendorData {
  // ── Categories ─────────────────────────────────────────────
  static const List<VendorCategory> categories = [
    VendorCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/icons/solarpanel.png',
    ),
    VendorCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/icons/battery.png',
    ),
    VendorCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/icons/inverters.png',
    ),
    VendorCategory(
      id: 'cat_cables',
      name: 'Cables',
      iconPath: 'assets/icons/cable.png',
    ),
  ];

  // ── Eight category tiles shown in the Vendor home grid ─────
  static const List<VendorCategory> homeCategories = [
    VendorCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/icons/solarpanel.png',
    ),
    VendorCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/icons/battery.png',
    ),
    VendorCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/icons/inverters.png',
    ),
    VendorCategory(
      id: 'cat_cables',
      name: 'Cables',
      iconPath: 'assets/icons/cable.png',
    ),
    VendorCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/icons/solarpanel.png',
    ),
    VendorCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/icons/battery.png',
    ),
    VendorCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/icons/inverters.png',
    ),
    VendorCategory(
      id: 'cat_more',
      name: 'View More',
      iconPath: 'assets/icons/seemore.png',
    ),
  ];

  // ── Banner promo image ─────────────────────────────────────
  static const String bannerImage =
      'assets/images/photo_2026-10-29_15-51-15.jpg';

  // ── Products (shared with catalog, extended with category) ─
  static const String _img =
      'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png';

  static const List<CatalogProduct> products = [
    CatalogProduct(
      id: 'tp_1',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000/-',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_2',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000/-',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_3',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000/-',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_4',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000/-',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_5',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000/-',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_6',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000/-',
      imagePath: _img,
    ),
  ];
}
