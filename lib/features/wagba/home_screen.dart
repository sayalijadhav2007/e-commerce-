import 'package:dual_role_delivery_app/application/auth/auth_controller.dart';
import 'package:dual_role_delivery_app/application/cart/cart_controller.dart';
import 'package:dual_role_delivery_app/application/favorites/favorites_controller.dart';
import 'package:dual_role_delivery_app/application/meals/meal_filters.dart';
import 'package:dual_role_delivery_app/core/utils/price_formatter.dart';
import 'package:dual_role_delivery_app/data/wagba_providers.dart';
import 'package:dual_role_delivery_app/core/theme/wagba_colors.dart';
import 'package:dual_role_delivery_app/core/widgets/wagba_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredMeals = ref.watch(filteredMealsProvider);
    final categoriesAsync = ref.watch(wagbaCategoriesProvider);
    final favorites = ref.watch(favoritesProvider);
    final user = ref.watch(userProfileProvider);
    return Scaffold(
      backgroundColor: WagbaColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${user.name}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.city}, ${user.country}',
                          style: const TextStyle(color: WagbaColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/orders'),
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for meals',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: WagbaColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
              ),
              const SizedBox(height: 20),
              _PromoBanner(
                onTap: () => context.go('/meal/meal-1'),
              ),
              const SizedBox(height: 24),
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (items) {
                  final categories = [
                    const _CategoryChipData(id: 'all', label: 'All'),
                    ...items.map(
                      (category) => _CategoryChipData(
                        id: category.id,
                        label: category.name,
                      ),
                    ),
                  ];
                  return SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = (selectedCategory == null &&
                                category.id == 'all') ||
                            selectedCategory == category.id;
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedCategoryProvider.notifier).state =
                                category.id == 'all' ? null : category.id;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? WagbaColors.primary
                                  : WagbaColors.chip,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              category.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? WagbaColors.textPrimary
                                    : WagbaColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: categories.length,
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 52,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const Text('Failed to load categories'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Meals',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.go('/categories'),
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              filteredMeals.when(
                data: (items) {
                  return Column(
                    children: items.map((meal) {
                      return _MealCard(
                        mealName: meal.name,
                        imagePath: meal.imagePath,
                        price: meal.price,
                        rating: meal.rating,
                        isFavorite: favorites.contains(meal.id),
                        onTap: () => context.go('/meal/${meal.id}', extra: meal),
                        onAdd: () =>
                            ref.read(cartProvider.notifier).addMeal(meal),
                        onFavorite: () => ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(meal.id),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Failed to load meals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _PromoBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF331400), Color(0xFFFF6A00)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hot Deal!',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Smoky BBQ Burger',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Order now and get 25% off',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Order Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            WagbaImage(
              path: 'assets/images/meal_burger.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String mealName;
  final String imagePath;
  final double rating;
  final double price;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const _MealCard({
    required this.mealName,
    required this.imagePath,
    required this.rating,
    required this.price,
    required this.onTap,
    required this.onAdd,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WagbaColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            WagbaImage(
              path: imagePath,
              width: 84,
              height: 84,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: WagbaColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatInr(price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: WagbaColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                        isFavorite ? WagbaColors.primary : Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(48, 34),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChipData {
  final String id;
  final String label;

  const _CategoryChipData({required this.id, required this.label});
}
