import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/dish.dart';

class DishProvider extends ChangeNotifier {
  final List<Dish> _dishes = [
    Dish(
      id: '1',
      name: 'Margherita Pizza',
      ingredients: ['Tomato', 'Mozzarella', 'Basil'],
      price: 449,
      deliveryTime: 25,
      distanceKm: 2.4,
      restaurantName: 'Pizza Palace',
      location: 'Downtown',
      rating: 4.5,
      imageUrl: 'https://picsum.photos/300/200?random=1',
      category: 'Veg',
    ),
    Dish(
      id: '2',
      name: 'Chicken Burger',
      ingredients: ['Chicken', 'Lettuce', 'Tomato', 'Bun'],
      price: 349,
      deliveryTime: 15,
      distanceKm: 1.6,
      restaurantName: 'Burger Joint',
      location: 'Uptown',
      rating: 4.2,
      imageUrl: 'https://picsum.photos/300/200?random=2',
      category: 'Non-Veg',
    ),
    Dish(
      id: '3',
      name: 'Vegan Salad',
      ingredients: ['Lettuce', 'Avocado', 'Tomato', 'Olive Oil'],
      price: 399,
      deliveryTime: 10,
      distanceKm: 1.2,
      restaurantName: 'Green Eats',
      location: 'Midtown',
      rating: 4.8,
      imageUrl: 'https://picsum.photos/300/200?random=3',
      category: 'Vegan',
    ),
    Dish(
      id: '4',
      name: 'Paneer Tikka',
      ingredients: ['Paneer', 'Spices', 'Yogurt', 'Onion'],
      price: 499,
      deliveryTime: 20,
      distanceKm: 2.0,
      restaurantName: 'Indian Spice',
      location: 'East Side',
      rating: 4.7,
      imageUrl: 'https://picsum.photos/300/200?random=4',
      category: 'Veg',
    ),
    Dish(
      id: '5',
      name: 'Beef Steak',
      ingredients: ['Beef', 'Garlic', 'Herbs', 'Potatoes'],
      price: 1199,
      deliveryTime: 30,
      distanceKm: 4.8,
      restaurantName: 'Steak House',
      location: 'West End',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/300/200?random=5',
      category: 'Non-Veg',
    ),
    Dish(
      id: '6',
      name: 'Quinoa Bowl',
      ingredients: ['Quinoa', 'Chickpeas', 'Veggies', 'Tahini'],
      price: 429,
      deliveryTime: 12,
      distanceKm: 1.5,
      restaurantName: 'Healthy Bites',
      location: 'North Park',
      rating: 4.6,
      imageUrl: 'https://picsum.photos/300/200?random=6',
      category: 'Vegan',
    ),
    Dish(
      id: '7',
      name: 'Vegetable Stir Fry',
      ingredients: ['Broccoli', 'Carrots', 'Bell Peppers', 'Soy Sauce'],
      price: 379,
      deliveryTime: 18,
      distanceKm: 2.7,
      restaurantName: 'Asian Fusion',
      location: 'South Gate',
      rating: 4.3,
      imageUrl: 'https://picsum.photos/300/200?random=7',
      category: 'Veg',
    ),
    Dish(
      id: '8',
      name: 'Grilled Salmon',
      ingredients: ['Salmon', 'Lemon', 'Herbs', 'Rice'],
      price: 1099,
      deliveryTime: 25,
      distanceKm: 4.2,
      restaurantName: 'Seafood Delight',
      location: 'Harbor View',
      rating: 4.8,
      imageUrl: 'https://picsum.photos/300/200?random=8',
      category: 'Non-Veg',
    ),
    Dish(
      id: '9',
      name: 'Avocado Toast',
      ingredients: ['Avocado', 'Bread', 'Tomato', 'Seeds'],
      price: 329,
      deliveryTime: 10,
      distanceKm: 1.1,
      restaurantName: 'Breakfast Club',
      location: 'City Center',
      rating: 4.4,
      imageUrl: 'https://picsum.photos/300/200?random=9',
      category: 'Vegan',
    ),
    Dish(
      id: '10',
      name: 'Chicken Curry',
      ingredients: ['Chicken', 'Coconut Milk', 'Spices', 'Rice'],
      price: 599,
      deliveryTime: 22,
      distanceKm: 3.4,
      restaurantName: 'Curry House',
      location: 'Old Town',
      rating: 4.6,
      imageUrl: 'https://picsum.photos/300/200?random=10',
      category: 'Non-Veg',
    ),
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  final Map<String, int> _orderHistory = {
    'Margherita Pizza': 28,
    'Chicken Burger': 22,
    'Vegan Salad': 18,
    'Paneer Tikka': 16,
    'Beef Steak': 12,
    'Quinoa Bowl': 20,
    'Vegetable Stir Fry': 14,
    'Grilled Salmon': 19,
    'Avocado Toast': 24,
    'Chicken Curry': 17,
  };

  final List<double> _weeklySpending = [1850, 2420, 2160, 2940, 2680, 3320];

  List<Dish> get dishes => List.unmodifiable(_dishes);
  List<String> get categoryFilters => ['All', 'Veg', 'Non-Veg', 'Vegan'];
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void updateCategoryFilter(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  List<Dish> filteredDishes(String preferenceCategory) {
    var results = _dishes;
    if (_selectedCategory != 'All') {
      results = results
          .where((dish) => dish.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      results = results.where((dish) {
        return dish.name.toLowerCase().contains(lowerQuery) ||
            dish.ingredients.join(' ').toLowerCase().contains(lowerQuery) ||
            dish.restaurantName.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    return _sortByScore(results, preferenceCategory);
  }

  List<Dish> recommendedDishes(String preferenceCategory) {
    return _sortByScore(_dishes, preferenceCategory).take(4).toList();
  }

  List<Dish> _sortByScore(List<Dish> dishes, String preferenceCategory) {
    final scored = dishes
        .map((dish) => MapEntry(dish, _scoreForDish(dish, preferenceCategory)))
        .toList();
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((entry) => entry.key).toList();
  }

  double _scoreForDish(Dish dish, String preferenceCategory) {
    final ratingScore = (dish.rating / 5.0) * 0.5;
    final preferenceScore =
        _preferenceMatch(dish.category, preferenceCategory) * 0.35;
    final distanceScore = (1 - (dish.deliveryTime / 35).clamp(0.0, 1.0)) * 0.15;
    return ratingScore + preferenceScore + distanceScore;
  }

  double _preferenceMatch(String dishCategory, String preferenceCategory) {
    if (dishCategory == preferenceCategory) {
      return 1.0;
    }
    if (preferenceCategory == 'Veg' && dishCategory == 'Vegan') {
      return 0.7;
    }
    if (preferenceCategory == 'Vegan' && dishCategory == 'Veg') {
      return 0.3;
    }
    return 0.1;
  }

  Map<String, double> get categoryDistribution {
    final total = _dishes.length.toDouble();
    final counts = <String, int>{'Veg': 0, 'Non-Veg': 0, 'Vegan': 0};
    for (final dish in _dishes) {
      counts[dish.category] = (counts[dish.category] ?? 0) + 1;
    }
    return counts.map((key, value) => MapEntry(key, value / total * 100));
  }

  List<MapEntry<String, int>> get mostOrderedDishes {
    return _orderHistory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  List<FlSpot> get spendingTrendSpots {
    return _weeklySpending.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  void recordOrder(String dishId) {
    final dish = _dishes.firstWhere(
      (item) => item.id == dishId,
      orElse: () => throw ArgumentError('Dish not found: $dishId'),
    );
    _orderHistory[dish.name] = (_orderHistory[dish.name] ?? 0) + 1;
    _weeklySpending[_weeklySpending.length - 1] += dish.price;
    notifyListeners();
  }
}
