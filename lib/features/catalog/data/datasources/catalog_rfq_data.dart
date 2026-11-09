import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';

// Mock data for the catalog RFQ / Payment screens
class CatalogRfqData {
  static final List<CatalogRfqRequest> _requests = [
    CatalogRfqRequest(
      id: 'rfq_001',
      supplierName: 'SunTech Sol.',
      amount: 'Rs. 1,23,000',
      dateLabel: "Valid till 15th Oct'25",
      status: CatalogRfqStatus.received,
      items: [
        CatalogOrderItem(
          productName: '100×100 Solar Panel',
          qty: '10x1 =',
          price: 'Rs. 2,23,000',
        ),
        CatalogOrderItem(
          productName: '50×100 Solar Panel',
          qty: '5x1 =',
          price: 'Rs. 1,23,000',
        ),
      ],
      subTotal: 'Rs. 2,94,000',
      gst: 'Rs. 20,000',
      total: 'Rs. 3,23,000',
    ),
    CatalogRfqRequest(
      id: 'rfq_002',
      supplierName: 'SunTech Sol.',
      amount: 'Rs. 23,000',
      dateLabel: "Valid till 26th Oct'26",
      status: CatalogRfqStatus.pending,
      items: [
        CatalogOrderItem(
          productName: '10 KW Solar Panel',
          qty: '5x1 =',
          price: 'Rs. 1,15,000',
        ),
      ],
      subTotal: 'Rs. 1,15,000',
      gst: 'Rs. 10,000',
      total: 'Rs. 1,25,000',
    ),
  ];

  static List<CatalogRfqRequest> get requests => List.unmodifiable(_requests);

  static CatalogRfqRequest? getById(String id) {
    for (final request in _requests) {
      if (request.id == id) return request;
    }
    return null;
  }

  static void add(CatalogRfqRequest request) {
    _requests.insert(0, request);
  }

  static bool updateStatus(String id, CatalogRfqStatus status) {
    final index = _requests.indexWhere((request) => request.id == id);
    if (index == -1) return false;
    _requests[index] = _requests[index].copyWith(status: status);
    return true;
  }

  static bool receiveQuote(
    String id, {
    required String supplierName,
    required String amount,
    required String dateLabel,
    required List<CatalogOrderItem> items,
    required String subTotal,
    required String gst,
    required String total,
  }) {
    final index = _requests.indexWhere((request) => request.id == id);
    if (index == -1) return false;
    _requests[index] = _requests[index].copyWith(
      status: CatalogRfqStatus.received,
      supplierName: supplierName,
      amount: amount,
      dateLabel: dateLabel,
      items: List.unmodifiable(items),
      subTotal: subTotal,
      gst: gst,
      total: total,
    );
    return true;
  }
}
