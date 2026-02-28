import 'package:dual_role_delivery_app/data/wagba_repository.dart';
import 'package:dual_role_delivery_app/domain/models/wagba_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wagbaRepositoryProvider = Provider<WagbaRepository>((ref) {
  return WagbaRepository();
});

final wagbaCategoriesProvider = FutureProvider<List<WagbaCategory>>((ref) async {
  final repo = ref.read(wagbaRepositoryProvider);
  return repo.loadCategories();
});

final wagbaMealsProvider = FutureProvider<List<WagbaMeal>>((ref) async {
  final repo = ref.read(wagbaRepositoryProvider);
  return repo.loadMeals();
});
