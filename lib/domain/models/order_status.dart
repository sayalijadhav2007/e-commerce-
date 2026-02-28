import 'package:flutter/material.dart';

enum OrderStatus {
  assigned,
  pickedUp,
  outForDelivery,
  delivered,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.assigned:
        return 'Assigned';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.outForDelivery:
        return 'Out For Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.assigned:
        return Colors.blueGrey.shade400;
      case OrderStatus.pickedUp:
        return Colors.amber.shade700;
      case OrderStatus.outForDelivery:
        return Colors.blue.shade700;
      case OrderStatus.delivered:
        return Colors.green.shade600;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.assigned:
        return Icons.assignment_ind_outlined;
      case OrderStatus.pickedUp:
        return Icons.shopping_bag_outlined;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.verified_outlined;
    }
  }

  OrderStatus? get next {
    switch (this) {
      case OrderStatus.assigned:
        return OrderStatus.pickedUp;
      case OrderStatus.pickedUp:
        return OrderStatus.outForDelivery;
      case OrderStatus.outForDelivery:
        return OrderStatus.delivered;
      case OrderStatus.delivered:
        return null;
    }
  }
}
