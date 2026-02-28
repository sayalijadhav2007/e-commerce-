import 'dart:convert';

import 'package:dual_role_delivery_app/data/wagba_providers.dart';
import 'package:dual_role_delivery_app/domain/models/wagba_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final WagbaMeal meal;
  final int quantity;

  const CartItem({required this.meal, required this.quantity});

  double get total => meal.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(meal: meal, quantity: quantity ?? this.quantity);
  }

  Map<String, dynamic> toJson() {
    return {
      'mealId': meal.id,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJsonWithMeal(Map<String, dynamic> json, WagbaMeal meal) {
    return CartItem(meal: meal, quantity: (json['quantity'] as num).toInt());
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      meal: WagbaMeal(
        id: json['mealId'] as String,
        name: json['name'] as String,
        imagePath: json['imagePath'] as String,
        rating: 0,
        price: (json['price'] as num).toDouble(),
        description: '',
        categoryId: '',
      ),
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}

class CartController extends StateNotifier<List<CartItem>> {
  CartController(this.ref) : super(const []) {
    _load();
  }

  final Ref ref;

  void addMeal(WagbaMeal meal, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.meal.id == meal.id);
    if (existingIndex == -1) {
      state = [...state, CartItem(meal: meal, quantity: quantity)];
    } else {
      final existing = state[existingIndex];
      final updated = existing.copyWith(quantity: existing.quantity + quantity);
      final updatedState = [...state];
      updatedState[existingIndex] = updated;
      state = updatedState;
    }
    _persist();
  }

  void updateQuantity(String mealId, int quantity) {
    if (quantity <= 0) {
      removeMeal(mealId);
      return;
    }
    state = [
      for (final item in state)
        if (item.meal.id == mealId)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
    _persist();
  }

  void removeMeal(String mealId) {
    state = state.where((item) => item.meal.id != mealId).toList();
    _persist();
  }

  void clear() {
    state = const [];
    _persist();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('wagba_cart');
    if (raw == null) return;
    final decoded = jsonDecode(raw) as List<dynamic>;
    final repo = ref.read(wagbaRepositoryProvider);
    final meals = await repo.loadMeals();
    final items = <CartItem>[];
    for (final entry in decoded) {
      final map = entry as Map<String, dynamic>;
      final mealId = map['mealId'] as String;
      final meal = meals.firstWhere(
        (item) => item.id == mealId,
        orElse: () => meals.first,
      );
      items.add(CartItem.fromJsonWithMeal(map, meal));
    }
    state = items;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = state.map((item) => item.toJson()).toList();
    await prefs.setString('wagba_cart', jsonEncode(encoded));
  }
}

final cartProvider = StateNotifierProvider<CartController, List<CartItem>>(
  (ref) => CartController(ref),
);

final cartSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.total);
});

final cartDeliveryFeeProvider = Provider<double>((ref) => 2.5);

final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final delivery = ref.watch(cartDeliveryFeeProvider);
  return subtotal + delivery;
});
