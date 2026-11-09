import 'package:flutter_app/features/catalog/domain/entities/catalog_category.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

// Mock data used across the three Vendor screens
class CatalogData {
  static const List<CatalogCategory> categories = [
    CatalogCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/icons/ic_category_solar_panel.png',
    ),
    CatalogCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/icons/ic_category_battery.png',
    ),
    CatalogCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/icons/ic_category_inverters.png',
    ),
    CatalogCategory(
      id: 'cat_cables',
      name: 'Cables',
      iconPath: 'assets/icons/ic_category_cable.png',
    ),
  ];

  static const List<CatalogCategory> homeCategories = [
    CatalogCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/icons/ic_category_solar_panel.png',
    ),
    CatalogCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/icons/ic_category_battery.png',
    ),
    CatalogCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/icons/ic_category_inverters.png',
    ),
    CatalogCategory(
      id: 'cat_cables',
      name: 'Cables',
      iconPath: 'assets/icons/ic_category_cable.png',
    ),
    CatalogCategory(
      id: 'cat_solar',
      name: 'Solar Panels',
      iconPath: 'assets/icons/ic_category_solar_panel.png',
    ),
    CatalogCategory(
      id: 'cat_battery',
      name: 'Battery',
      iconPath: 'assets/icons/ic_category_battery.png',
    ),
    CatalogCategory(
      id: 'cat_inverters',
      name: 'Inverters',
      iconPath: 'assets/icons/ic_category_inverters.png',
    ),
    CatalogCategory(
      id: 'cat_more',
      name: 'View More',
      iconPath: 'assets/icons/ic_view_more.png',
    ),
  ];

  // ── Products (shared with catalog, extended with category) ─
  static const String _img = 'assets/solarimages/solar_panel_product.png';

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
