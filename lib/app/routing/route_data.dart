import 'package:flutter_app/features/catalog/domain/entities/catalog_product.dart';

class OtpRouteData {
  const OtpRouteData({required this.mobileNumber, required this.role});

  final String mobileNumber;
  final String role;
}

class VendorCartRouteData {
  const VendorCartRouteData({
    required this.cartItems,
    required this.initialQuantities,
  });

  final List<CatalogProduct> cartItems;
  final Map<String, int> initialQuantities;
}
