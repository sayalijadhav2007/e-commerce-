import 'package:dual_role_delivery_app/application/orders/order_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderDoneScreen extends ConsumerWidget {
  final String? orderId;

  const OrderDoneScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = orderId == null
        ? ref.watch(latestOrderProvider)
        : ref.watch(ordersProvider.notifier).getById(orderId!);
    return Scaffold(
      backgroundColor: WagbaColors.background.withAlpha(242),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: WagbaColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.celebration, size: 44, color: WagbaColors.primary),
              const SizedBox(height: 12),
              Text(
                'Order confirmed successfully',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Order ${order?.id ?? ''} is being prepared in Mumbai.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: WagbaColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Back Home'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: order == null
                          ? null
                          : () => context.go('/track/${order.id}'),
                      child: const Text('Track Order'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
