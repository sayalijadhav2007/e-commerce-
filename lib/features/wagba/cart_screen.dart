import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:dual_role_delivery_app/core/utils/price_formatter.dart';
import 'package:dual_role_delivery_app/core/widgets/wagba_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final delivery = ref.watch(cartDeliveryFeeProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: WagbaColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Your cart is empty. Start adding meals!',
                  style: TextStyle(color: WagbaColors.textSecondary),
                ),
              )
            else
              ...items.map(
                (item) => _CartItemCard(
                  item: item,
                  onDecrement: () {
                    ref
                        .read(cartProvider.notifier)
                        .updateQuantity(item.meal.id, item.quantity - 1);
                  },
                  onIncrement: () {
                    ref
                        .read(cartProvider.notifier)
                        .updateQuantity(item.meal.id, item.quantity + 1);
                  },
                  onRemove: () {
                    ref.read(cartProvider.notifier).removeMeal(item.meal.id);
                  },
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Promo Code',
                suffixIcon: TextButton(
                  onPressed: () {},
                  child: const Text('Apply'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _PriceRow(label: 'Subtotal', value: subtotal),
            const SizedBox(height: 8),
            _PriceRow(label: 'Delivery', value: delivery),
            const Divider(height: 24, color: WagbaColors.outline),
            _PriceRow(label: 'Total', value: total, highlight: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: items.isEmpty ? null : () => context.go('/checkout'),
              child: const Text('Proceed to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WagbaColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          WagbaImage(
            path: item.meal.imagePath,
            width: 72,
            height: 72,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.meal.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  formatInr(item.meal.price),
                  style: const TextStyle(color: WagbaColors.primary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close, color: WagbaColors.textSecondary),
              ),
              Row(
                children: [
                  _StepperButton(icon: Icons.remove, onTap: onDecrement),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('${item.quantity}'),
                  ),
                  _StepperButton(icon: Icons.add, onTap: onIncrement),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: WagbaColors.chip,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _PriceRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = highlight
        ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)
        : const TextStyle(color: WagbaColors.textSecondary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(formatInr(value), style: style),
      ],
    );
  }
}
