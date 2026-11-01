import 'package:flutter/material.dart';

// Order status enum
enum OrderStatus {
  pending,
  dispatched,
  delivered;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFFE9C7);
      case OrderStatus.dispatched:
        return const Color(0xFFC3E1FE);
      case OrderStatus.delivered:
        return const Color(0xFFD3F3E1);
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFCC7A00);
      case OrderStatus.dispatched:
        return const Color(0xFF113CF5);
      case OrderStatus.delivered:
        return const Color(0xFF217552);
    }
  }
}

// Order data model
class Order {
  final String id;
  final String productName;
  final String productImagePath;
  final String price;
  final String deliveryLocation;
  final String buyer;
  final String orderDate;
  final OrderStatus status;
  final int quantity;
  final double subtotal;
  final double gstPercent;

  const Order({
    required this.id,
    required this.productName,
    required this.productImagePath,
    required this.price,
    required this.deliveryLocation,
    required this.buyer,
    required this.orderDate,
    required this.status,
    required this.quantity,
    required this.subtotal,
    required this.gstPercent,
  });

  double get gstAmount => subtotal * gstPercent / 100;
  double get total => subtotal + gstAmount;

  Order copyWith({OrderStatus? status}) => Order(
    id: id,
    productName: productName,
    productImagePath: productImagePath,
    price: price,
    deliveryLocation: deliveryLocation,
    buyer: buyer,
    orderDate: orderDate,
    status: status ?? this.status,
    quantity: quantity,
    subtotal: subtotal,
    gstPercent: gstPercent,
  );
}
