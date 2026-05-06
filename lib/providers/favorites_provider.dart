import 'package:flutter/material.dart';
import '../models/dish.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteDishIds = {};

  Set<String> get favoriteDishIds => Set.unmodifiable(_favoriteDishIds);

  bool isFavorite(String dishId) => _favoriteDishIds.contains(dishId);

  List<Dish> favoritesFor(List<Dish> dishes) {
    return dishes.where((dish) => _favoriteDishIds.contains(dish.id)).toList();
  }

  void toggleFavorite(String dishId) {
    if (_favoriteDishIds.contains(dishId)) {
      _favoriteDishIds.remove(dishId);
    } else {
      _favoriteDishIds.add(dishId);
    }
    notifyListeners();
  }
}
