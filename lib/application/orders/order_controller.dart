import 'dart:convert';

import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';
import 'package:dual_role_delivery_app/domain/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersController extends StateNotifier<List<Order>> {
  OrdersController() : super(const []) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('wagba_orders');
    if (raw == null) return;
    final decoded = jsonDecode(raw) as List<dynamic>;
    state = decoded.map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> addOrder(Order order) async {
    state = [order, ...state];
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state.map((order) => order.toJson()).toList();
    await prefs.setString('wagba_orders', jsonEncode(encoded));
  }

  Order? getById(String id) {
    try {
      return state.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }
}

final ordersProvider = StateNotifierProvider<OrdersController, List<Order>>((ref) {
  return OrdersController();
});

final latestOrderProvider = Provider<Order?>((ref) {
  final orders = ref.watch(ordersProvider);
  return orders.isEmpty ? null : orders.first;
});

final orderItemsTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.total);
});
