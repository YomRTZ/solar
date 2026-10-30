import 'dart:typed_data';

class OrderDispatchUpdate {
  final String transporter;
  final String trackingNumber;
  final String dispatchDate;
  final String? proofImageAssetPath;
  final Uint8List? proofImageBytes;

  const OrderDispatchUpdate({
    required this.transporter,
    required this.trackingNumber,
    required this.dispatchDate,
    this.proofImageAssetPath,
    this.proofImageBytes,
  });
}

class OrderDispatchUpdates {
  static final Map<String, OrderDispatchUpdate> _updates = {};

  static OrderDispatchUpdate? forOrder(String orderId) => _updates[orderId];

  static void save(String orderId, OrderDispatchUpdate update) {
    _updates[orderId] = update;
  }
}
