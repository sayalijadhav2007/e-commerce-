import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends StateNotifier<Set<String>> {
  FavoritesController() : super(<String>{}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('wagba_favorites');
    if (raw == null) return;
    final decoded = jsonDecode(raw) as List<dynamic>;
    state = decoded.map((id) => id.toString()).toSet();
  }

  Future<void> toggleFavorite(String mealId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(mealId)) {
      updated.remove(mealId);
    } else {
      updated.add(mealId);
    }
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wagba_favorites', jsonEncode(state.toList()));
  }

  bool isFavorite(String mealId) => state.contains(mealId);
}

final favoritesProvider = StateNotifierProvider<FavoritesController, Set<String>>((ref) {
  return FavoritesController();
});
