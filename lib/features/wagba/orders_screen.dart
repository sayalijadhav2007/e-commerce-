import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';
import 'package:dual_role_delivery_app/application/orders/order_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:dual_role_delivery_app/core/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: WagbaColors.background,
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'No orders yet. Place your first order!',
                style: TextStyle(color: WagbaColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: WagbaColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order.address,
                        style: const TextStyle(color: WagbaColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            order.status,
                            style: const TextStyle(color: WagbaColors.primary),
                          ),
                          const Spacer(),
                          Text(
                            formatInr(order.total),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.go('/track/${order.id}'),
                              child: const Text('Track Order'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final cart = ref.read(cartProvider.notifier);
                                for (final item in order.items) {
                                  cart.addMeal(item.meal, quantity: item.quantity);
                                }
                                context.go('/cart');
                              },
                              child: const Text('Reorder'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
