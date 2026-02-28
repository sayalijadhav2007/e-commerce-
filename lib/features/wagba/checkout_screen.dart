import 'package:dual_role_delivery_app/application/auth/auth_controller.dart';
import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';
import 'package:dual_role_delivery_app/application/orders/order_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:dual_role_delivery_app/core/utils/price_formatter.dart';
import 'package:dual_role_delivery_app/domain/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _selectedAddress = 0;
  int _selectedPayment = 0;

  @override
  Widget build(BuildContext context) {
    final subtotal = ref.watch(cartSubtotalProvider);
    final delivery = ref.watch(cartDeliveryFeeProvider);
    final total = ref.watch(cartTotalProvider);
    final user = ref.watch(userProfileProvider);
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: WagbaColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Address',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Home',
              subtitle: user.address,
              selected: _selectedAddress == 0,
              onTap: () => setState(() => _selectedAddress = 0),
            ),
            const SizedBox(height: 12),
            _SelectableCard(
              title: 'Work',
              subtitle: 'BKC, Mumbai',
              selected: _selectedAddress == 1,
              onTap: () => setState(() => _selectedAddress = 1),
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            RadioGroup<int>(
              groupValue: _selectedPayment,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedPayment = value);
                }
              },
              child: const Column(
                children: [
                  _RadioTile(
                    title: 'Cash on Delivery',
                    value: 0,
                  ),
                  SizedBox(height: 8),
                  _RadioTile(
                    title: 'Credit/Debit Card',
                    value: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _SummaryRow(label: 'Subtotal', value: subtotal),
            const SizedBox(height: 8),
            _SummaryRow(label: 'Delivery', value: delivery),
            const Divider(height: 24, color: WagbaColors.outline),
            _SummaryRow(label: 'Total', value: total, highlight: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () async {
                      final order = Order(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        items: cartItems,
                        subtotal: subtotal,
                        deliveryFee: delivery,
                        total: total,
                        status: 'Preparing',
                        createdAt: DateTime.now(),
                        address: _selectedAddress == 0
                            ? user.address
                            : 'BKC, Mumbai',
                        latitude: user.latitude,
                        longitude: user.longitude,
                        paymentMethod:
                            _selectedPayment == 0 ? 'Cash on Delivery' : 'Card',
                      );
                      await ref.read(ordersProvider.notifier).addOrder(order);
                      ref.read(cartProvider.notifier).clear();
                      if (!context.mounted) return;
                      context.go('/order-done', extra: order.id);
                    },
              child: const Text('Confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WagbaColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? WagbaColors.primary : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? WagbaColors.primary : WagbaColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: WagbaColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String title;
  final int value;

  const _RadioTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WagbaColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: RadioListTile<int>(
        value: value,
        title: Text(title),
        activeColor: WagbaColors.primary,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _SummaryRow({
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
