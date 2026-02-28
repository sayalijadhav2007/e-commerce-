import 'dart:convert';

import 'package:dual_role_delivery_app/domain/models/wagba_models.dart';
import 'package:flutter/services.dart';

class WagbaRepository {
  List<WagbaCategory>? _cachedCategories;
  List<WagbaMeal>? _cachedMeals;

  Future<List<WagbaCategory>> loadCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;
    final csv = await rootBundle.loadString('assets/data/categories.csv');
    _cachedCategories = _parseCategories(csv);
    return _cachedCategories!;
  }

  Future<List<WagbaMeal>> loadMeals() async {
    if (_cachedMeals != null) return _cachedMeals!;
    final csv = await rootBundle.loadString('assets/data/meals.csv');
    _cachedMeals = _parseMeals(csv);
    return _cachedMeals!;
  }

  List<WagbaCategory> _parseCategories(String csv) {
    final lines = const LineSplitter().convert(csv);
    if (lines.isEmpty) return [];
    return lines.skip(1).where((line) => line.trim().isNotEmpty).map((line) {
      final parts = line.split(',');
      return WagbaCategory(
        id: parts[0].trim(),
        name: parts[1].trim(),
        imagePath: parts[2].trim(),
      );
    }).toList();
  }

  List<WagbaMeal> _parseMeals(String csv) {
    final lines = const LineSplitter().convert(csv);
    if (lines.isEmpty) return [];
    return lines.skip(1).where((line) => line.trim().isNotEmpty).map((line) {
      final parts = line.split(',');
      return WagbaMeal(
        id: parts[0].trim(),
        name: parts[1].trim(),
        price: double.parse(parts[2].trim()),
        rating: double.parse(parts[3].trim()),
        description: parts[4].trim(),
        categoryId: parts[5].trim(),
        imagePath: parts[6].trim(),
      );
    }).toList();
  }
}
