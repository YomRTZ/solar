import '../../models/catalog_product.dart';

class OtpRouteData {
  const OtpRouteData({required this.mobileNumber, required this.role});

  final String mobileNumber;
  final String role;
}

class AdvTenderCartRouteData {
  const AdvTenderCartRouteData({
    required this.cartItems,
    required this.initialQuantities,
  });

  final List<CatalogProduct> cartItems;
  final Map<String, int> initialQuantities;
}
