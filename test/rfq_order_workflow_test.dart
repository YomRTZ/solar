import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/orders/data/datasources/orders_data.dart';
import 'package:flutter_app/features/orders/domain/entities/order.dart';
import 'package:flutter_app/features/rfq/data/datasources/rfq_data.dart';
import 'package:flutter_app/features/rfq/domain/entities/rfq.dart';
import 'package:flutter_app/features/catalog/data/datasources/catalog_rfq_data.dart';
import 'package:flutter_app/features/catalog/domain/entities/catalog_rfq_request.dart';

void main() {
  test(
    'supplier quote updates its vendor request and dispatch updates order',
    () {
      const requestId = 'workflow-test-rfq';
      RFQData.add(
        const RFQ(
          id: requestId,
          rfqNumber: '#RFQ-TEST',
          productTitle: 'Test Solar Panel',
          imagePath: '',
          price: '1000',
          requiredQty: '2 Units',
          location: 'New Delhi',
          buyerName: 'Test Buyer',
          expectedDelivery: 'To be confirmed',
          status: RFQStatus.newRequest,
        ),
      );
      CatalogRfqData.add(
        const CatalogRfqRequest(
          id: requestId,
          supplierName: 'Test Supplier',
          amount: 'Rs. 2,360',
          dateLabel: 'Sent today',
          status: CatalogRfqStatus.pending,
          items: [
            CatalogOrderItem(
              productName: 'Test Solar Panel',
              qty: '2 x 1 =',
              price: 'Rs. 2,000',
            ),
          ],
          subTotal: 'Rs. 2,000',
          gst: 'Rs. 360',
          total: 'Rs. 2,360',
        ),
      );

      expect(
        RFQData.update(
          RFQData.getById(requestId)!.copyWith(
            status: RFQStatus.pending,
            quoteUnitPrice: '1,000',
            quoteGst: '18%',
            quoteDeliveryDate: 'Tomorrow',
          ),
        ),
        isTrue,
      );
      expect(
        CatalogRfqData.receiveQuote(
          requestId,
          supplierName: 'Test Supplier',
          amount: 'Rs. 2,360',
          dateLabel: 'Quote received today',
          items: const [
            CatalogOrderItem(
              productName: 'Test Solar Panel',
              qty: '2 x 1 =',
              price: 'Rs. 2,000',
            ),
          ],
          subTotal: 'Rs. 2,000',
          gst: 'Rs. 360',
          total: 'Rs. 2,360',
        ),
        isTrue,
      );
      expect(RFQData.getById(requestId)?.status, RFQStatus.pending);
      expect(
        CatalogRfqData.getById(requestId)?.status,
        CatalogRfqStatus.received,
      );
      expect(CatalogRfqData.getById(requestId)?.total, 'Rs. 2,360');

      const orderId = 'workflow-test-order';
      OrdersData.add(
        const Order(
          id: orderId,
          productName: 'Test Solar Panel',
          productImagePath: '',
          price: '1000',
          deliveryLocation: 'New Delhi',
          buyer: 'Test Buyer',
          orderDate: 'Today',
          status: OrderStatus.pending,
          quantity: 2,
          subtotal: 2000,
          gstPercent: 18,
        ),
      );
      expect(OrdersData.updateStatus(orderId, OrderStatus.dispatched), isTrue);
      expect(OrdersData.getById(orderId)?.status, OrderStatus.dispatched);
    },
  );
}
