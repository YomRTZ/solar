import '../models/tender_category.dart';
import '../models/catalog_product.dart';

/// Mock data used across the three Tender screens
class TenderData {
  // ── Categories ─────────────────────────────────────────────
  static const List<TenderCategory> categories = [
    TenderCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/images/icons/image_1380.png',
    ),
    TenderCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/images/icons/image_1.png',
    ),
    TenderCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/images/icons/image_1_1.png',
    ),
    TenderCategory(
      id: 'cat_cables',
      name: 'Cables',
      iconPath: 'assets/images/icons/image_1_2.png',
    ),
  ];

  // ── Quick-access categories shown in the home row ──────────
  static const List<TenderCategory> homeCategories = [
    TenderCategory(
      id: 'cat_solar',
      name: 'Solar Panel',
      iconPath: 'assets/images/icons/image_1380.png',
    ),
    TenderCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/images/icons/image_1.png',
    ),
    TenderCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/images/icons/image_1_1.png',
    ),
    TenderCategory(
      id: 'cat_cables',
      name: 'Cables',
      iconPath: 'assets/images/icons/image_1_2.png',
    ),
    TenderCategory(
      id: 'cat_more',
      name: 'View More',
      iconPath: 'assets/images/icons/5ceff9d5d9cae078a369c65ead35be73405d7dcd.png',
    ),
  ];

  // ── Banner promo image ─────────────────────────────────────
  static const String bannerImage =
      'assets/images/solarimages/8c95b22c561eba1d7752be96d662579cfd873d93.jpg';

  // ── Products (shared with catalog, extended with category) ─
  static const String _img =
      'assets/images/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png';

  static const List<CatalogProduct> products = [
    CatalogProduct(
      id: 'tp_1',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_2',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_3',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_4',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_5',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000',
      imagePath: _img,
    ),
    CatalogProduct(
      id: 'tp_6',
      name: '100 X 100 Solar Panel Matched Premium',
      subtitle: '90mm x 6m Pvc Stormwater Pipe',
      price: 'Rs.10000',
      imagePath: _img,
    ),
  ];
}
