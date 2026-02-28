import 'package:dual_role_delivery_app/data/wagba_providers.dart';
import 'package:dual_role_delivery_app/domain/models/wagba_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredMealsProvider = Provider<AsyncValue<List<WagbaMeal>>>((ref) {
  final selected = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final mealsAsync = ref.watch(wagbaMealsProvider);

  return mealsAsync.whenData((meals) {
    final filteredByCategory = (selected == null || selected == 'all')
        ? meals
        : meals.where((meal) => meal.categoryId == selected).toList();
    if (query.isEmpty) return filteredByCategory;
    return filteredByCategory
        .where((meal) => meal.name.toLowerCase().contains(query))
        .toList();
  });
});
