import 'package:flutter_app/features/orders/domain/entities/order.dart';

class OrdersData {
  static final List<Order> _orders = [
    const Order(
      id: '#ORD123456',
      productName: '10 KW Solar Panel',
      productImagePath:
          'assets/solarimages/8c95b22c561eba1d7752be96d662579cfd873d93.jpg',
      price: '45000',
      deliveryLocation: 'Pune, Maharashtra',
      buyer: 'Green Energy Installers',
      orderDate: '10 Sept 2026',
      status: OrderStatus.pending,
      quantity: 2,
      subtotal: 90000,
      gstPercent: 18,
    ),
    const Order(
      id: '#ORD1234564',
      productName: '10 KW Solar Panel',
      productImagePath:
          'assets/solarimages/fdd201d94ef3bf047ca70bbe9fc6ef424e0afe26.png',
      price: '45000',
      deliveryLocation: 'Mumbai, Maharashtra',
      buyer: 'SunRise Solar Co.',
      orderDate: '05 Sept 2026',
      status: OrderStatus.delivered,
      quantity: 2,
      subtotal: 90000,
      gstPercent: 18,
    ),
  ];

  static List<Order> get orders => List.unmodifiable(_orders);

  static Order? getById(String id) {
    for (final order in _orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  static void add(Order order) {
    _orders.insert(0, order);
  }

  static bool updateStatus(String id, OrderStatus status) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index == -1) return false;
    _orders[index] = _orders[index].copyWith(status: status);
    return true;
  }
}
