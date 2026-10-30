import 'package:flutter_app/features/vendor/domain/entities/vendor_rfq_request.dart';

/// Mock data for the vendor RFQ / Payment screens
class VendorRfqData {
  static const List<VendorRfqRequest> requests = [
    VendorRfqRequest(
      id: 'rfq_001',
      supplierName: 'SunTech Sol.',
      amount: 'Rs. 1,23,000',
      dateLabel: "Valid till 15th Oct'25",
      status: VendorRfqStatus.received,
      items: [
        VendorOrderItem(
          productName: '100×100 Solar Panel',
          qty: '10x1 =',
          price: 'Rs. 2,23,000',
        ),
        VendorOrderItem(
          productName: '50×100 Solar Panel',
          qty: '5x1 =',
          price: 'Rs. 1,23,000',
        ),
      ],
      subTotal: 'Rs. 2,94,000',
      gst: 'Rs. 20,000',
      total: 'Rs. 3,23,000',
    ),
    VendorRfqRequest(
      id: 'rfq_002',
      supplierName: 'SunTech Sol.',
      amount: 'Rs. 23,000',
      dateLabel: "Valid till 26th Oct'26",
      status: VendorRfqStatus.pending,
      items: [
        VendorOrderItem(
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
}
