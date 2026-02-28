import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';
import 'package:dual_role_delivery_app/application/favorites/favorites_controller.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:dual_role_delivery_app/core/utils/price_formatter.dart';
import 'package:dual_role_delivery_app/core/widgets/wagba_image.dart';
import 'package:dual_role_delivery_app/domain/models/wagba_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealDetailsScreen extends ConsumerStatefulWidget {
  final WagbaMeal meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  bool _addCheese = true;
  bool _extraTopping = false;

  double get _totalPrice {
    var total = widget.meal.price;
    if (_addCheese) total += 1.5;
    if (_extraTopping) total += 2.0;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoritesProvider).contains(widget.meal.id);
    return Scaffold(
      backgroundColor: WagbaColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  WagbaImage(
                    path: widget.meal.imagePath,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? WagbaColors.primary : Colors.white,
                        ),
                        onPressed: () => ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(widget.meal.id),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.meal.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: WagbaColors.primary, size: 18),
                          const SizedBox(width: 6),
                          Text(widget.meal.rating.toStringAsFixed(1)),
                          const Spacer(),
                          Text(
                            formatInr(widget.meal.price),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: WagbaColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.meal.description,
                        style: const TextStyle(color: WagbaColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Add-ons',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _AddonTile(
                        title: 'Add cheese',
                        price: 1.5,
                        value: _addCheese,
                        onChanged: (value) => setState(() => _addCheese = value),
                      ),
                      const SizedBox(height: 8),
                      _AddonTile(
                        title: 'Add extra topping',
                        price: 2.0,
                        value: _extraTopping,
                        onChanged: (value) => setState(() => _extraTopping = value),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: WagbaColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(color: WagbaColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatInr(_totalPrice),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addMeal(widget.meal);
                        context.go('/cart');
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddonTile extends StatelessWidget {
  final String title;
  final double price;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AddonTile({
    required this.title,
    required this.price,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WagbaColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: WagbaColors.primary,
        title: Text(title),
        subtitle: Text('+${formatInr(price)}'),
      ),
    );
  }
}
