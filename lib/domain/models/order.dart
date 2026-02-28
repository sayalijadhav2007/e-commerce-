import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status;
  final DateTime createdAt;
  final String address;
  final double latitude;
  final double longitude;
  final String paymentMethod;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map((item) => {
                'mealId': item.meal.id,
                'name': item.meal.name,
                'price': item.meal.price,
                'imagePath': item.meal.imagePath,
                'quantity': item.quantity,
              })
          .toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'paymentMethod': paymentMethod,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>).map((item) {
      final map = item as Map<String, dynamic>;
      return CartItem.fromJson(map);
    }).toList();

    return Order(
      id: json['id'] as String,
      items: items,
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
    );
  }
}
