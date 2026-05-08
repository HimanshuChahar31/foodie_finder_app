import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/dish.dart';

class DishProvider extends ChangeNotifier {
  static String _dishImage(String fileName) =>
      'assets/images/real/dishes/$fileName';

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
      imageUrl: _dishImage(
        'margherita-pizza.jpg',
      ),
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
      imageUrl: _dishImage(
        'chicken-burger.jpg',
      ),
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
      imageUrl: _dishImage(
        'vegan-salad.jpg',
      ),
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
      imageUrl: _dishImage(
        'paneer-tikka.jpg',
      ),
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
      imageUrl: _dishImage(
        'beef-steak.jpg',
      ),
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
      imageUrl: _dishImage(
        'quinoa-bowl.jpg',
      ),
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
      imageUrl: _dishImage(
        'vegetable-stir-fry.jpg',
      ),
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
      imageUrl: _dishImage(
        'grilled-salmon.jpg',
      ),
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
      imageUrl: _dishImage(
        'avocado-toast.jpg',
      ),
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
      imageUrl: _dishImage(
        'chicken-curry.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '11',
      name: 'Chole Bhature',
      ingredients: ['Chickpeas', 'Bhatura', 'Onion', 'Masala'],
      price: 289,
      deliveryTime: 18,
      distanceKm: 2.3,
      restaurantName: 'Punjabi Zaika',
      location: 'Sector 14',
      rating: 4.5,
      imageUrl: _dishImage(
        'chole-bhature.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '12',
      name: 'Dal Makhani',
      ingredients: ['Black Lentils', 'Butter', 'Cream', 'Spices'],
      price: 399,
      deliveryTime: 24,
      distanceKm: 2.8,
      restaurantName: 'Punjab Grill',
      location: 'Central Market',
      rating: 4.7,
      imageUrl: _dishImage(
        'dal-makhani.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '13',
      name: 'Paneer Butter Masala',
      ingredients: ['Paneer', 'Tomato Gravy', 'Butter', 'Kasuri Methi'],
      price: 459,
      deliveryTime: 23,
      distanceKm: 2.6,
      restaurantName: 'Royal Tandoor',
      location: 'MG Road',
      rating: 4.8,
      imageUrl: _dishImage(
        'paneer-butter-masala.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '14',
      name: 'Rajma Chawal',
      ingredients: ['Kidney Beans', 'Rice', 'Onion', 'Spices'],
      price: 319,
      deliveryTime: 19,
      distanceKm: 1.9,
      restaurantName: 'Ghar Ka Khana',
      location: 'Lake View',
      rating: 4.4,
      imageUrl: _dishImage(
        'rajma-chawal.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '15',
      name: 'Masala Dosa',
      ingredients: ['Rice Crepe', 'Potato Masala', 'Sambar', 'Chutney'],
      price: 259,
      deliveryTime: 16,
      distanceKm: 1.7,
      restaurantName: 'Udupi Sagar',
      location: 'South Avenue',
      rating: 4.6,
      imageUrl: _dishImage(
        'masala-dosa.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '16',
      name: 'Idli Sambar',
      ingredients: ['Idli', 'Sambar', 'Coconut Chutney', 'Podi'],
      price: 219,
      deliveryTime: 14,
      distanceKm: 1.4,
      restaurantName: 'Madras Cafe',
      location: 'Green Park',
      rating: 4.3,
      imageUrl: _dishImage(
        'idli-sambar.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '17',
      name: 'Vegetable Biryani',
      ingredients: ['Basmati Rice', 'Mixed Veg', 'Saffron', 'Spices'],
      price: 429,
      deliveryTime: 26,
      distanceKm: 3.0,
      restaurantName: 'Biryani Blues',
      location: 'Ring Road',
      rating: 4.5,
      imageUrl: _dishImage(
        'vegetable-biryani.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '18',
      name: 'Aloo Paratha Combo',
      ingredients: ['Paratha', 'Potato Filling', 'Curd', 'Pickle'],
      price: 249,
      deliveryTime: 15,
      distanceKm: 1.8,
      restaurantName: 'Paratha Point',
      location: 'Model Town',
      rating: 4.2,
      imageUrl: _dishImage(
        'aloo-paratha-combo.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '19',
      name: 'Palak Paneer',
      ingredients: ['Spinach', 'Paneer', 'Garlic', 'Cream'],
      price: 439,
      deliveryTime: 21,
      distanceKm: 2.5,
      restaurantName: 'Green Spice',
      location: 'Civil Lines',
      rating: 4.6,
      imageUrl: _dishImage(
        'palak-paneer.jpg',
      ),
      category: 'Veg',
    ),
    Dish(
      id: '20',
      name: 'Kadai Mushroom',
      ingredients: ['Mushroom', 'Capsicum', 'Onion', 'Kadai Masala'],
      price: 419,
      deliveryTime: 22,
      distanceKm: 2.2,
      restaurantName: 'Veggie Delight',
      location: 'Nehru Place',
      rating: 4.4,
      imageUrl: _dishImage(
        'kadai-mushroom.jpg',
      ),
      category: 'Vegan',
    ),
    Dish(
      id: '21',
      name: 'Butter Chicken',
      ingredients: ['Chicken', 'Tomato Gravy', 'Butter', 'Cream'],
      price: 649,
      deliveryTime: 27,
      distanceKm: 3.3,
      restaurantName: 'Mughlai Darbar',
      location: 'Connaught Place',
      rating: 4.8,
      imageUrl: _dishImage(
        'butter-chicken.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '22',
      name: 'Chicken Biryani',
      ingredients: ['Basmati Rice', 'Chicken', 'Saffron', 'Fried Onion'],
      price: 579,
      deliveryTime: 28,
      distanceKm: 3.6,
      restaurantName: 'Nawabi Handi',
      location: 'Old Delhi',
      rating: 4.7,
      imageUrl: _dishImage(
        'chicken-biryani.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '23',
      name: 'Mutton Rogan Josh',
      ingredients: ['Mutton', 'Kashmiri Chili', 'Yogurt', 'Spices'],
      price: 899,
      deliveryTime: 32,
      distanceKm: 4.1,
      restaurantName: 'Kashmir Kitchen',
      location: 'Mall Road',
      rating: 4.7,
      imageUrl: _dishImage(
        'mutton-rogan-josh.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '24',
      name: 'Fish Curry Rice',
      ingredients: ['Fish', 'Coconut Curry', 'Curry Leaves', 'Rice'],
      price: 699,
      deliveryTime: 29,
      distanceKm: 3.9,
      restaurantName: 'Coastal Pot',
      location: 'Harbor Street',
      rating: 4.5,
      imageUrl: _dishImage(
        'fish-curry-rice.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '25',
      name: 'Egg Curry',
      ingredients: ['Boiled Eggs', 'Tomato Onion Gravy', 'Spices', 'Coriander'],
      price: 389,
      deliveryTime: 20,
      distanceKm: 2.4,
      restaurantName: 'Desi Rasoi',
      location: 'Station Road',
      rating: 4.3,
      imageUrl: _dishImage(
        'egg-curry.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '26',
      name: 'Chicken Tikka',
      ingredients: ['Chicken', 'Yogurt', 'Spices', 'Lemon'],
      price: 559,
      deliveryTime: 24,
      distanceKm: 3.1,
      restaurantName: 'Tandoori Nights',
      location: 'Khan Market',
      rating: 4.6,
      imageUrl: _dishImage(
        'chicken-tikka.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '27',
      name: 'Prawn Masala',
      ingredients: ['Prawns', 'Onion', 'Tomato', 'Coastal Spices'],
      price: 799,
      deliveryTime: 30,
      distanceKm: 4.4,
      restaurantName: 'Sea Breeze',
      location: 'Marine Drive',
      rating: 4.6,
      imageUrl: _dishImage(
        'prawn-masala.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '28',
      name: 'Keema Pav',
      ingredients: ['Mutton Keema', 'Pav', 'Onion', 'Masala'],
      price: 469,
      deliveryTime: 21,
      distanceKm: 2.9,
      restaurantName: 'Bombay Bites',
      location: 'Linking Road',
      rating: 4.4,
      imageUrl: _dishImage(
        'keema-pav.jpg',
      ),
      category: 'Non-Veg',
    ),
    Dish(
      id: '29',
      name: 'Baingan Bharta',
      ingredients: ['Roasted Eggplant', 'Onion', 'Tomato', 'Spices'],
      price: 369,
      deliveryTime: 19,
      distanceKm: 2.1,
      restaurantName: 'Village Tadka',
      location: 'Heritage Lane',
      rating: 4.3,
      imageUrl: _dishImage(
        'baingan-bharta.jpg',
      ),
      category: 'Vegan',
    ),
    Dish(
      id: '30',
      name: 'Veg Pulao',
      ingredients: ['Basmati Rice', 'Carrot', 'Peas', 'Whole Spices'],
      price: 299,
      deliveryTime: 18,
      distanceKm: 2.0,
      restaurantName: 'Annapurna Meals',
      location: 'Temple Road',
      rating: 4.2,
      imageUrl: _dishImage(
        'veg-pulao.jpg',
      ),
      category: 'Vegan',
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
    'Butter Chicken': 21,
    'Chicken Biryani': 26,
    'Paneer Butter Masala': 19,
    'Masala Dosa': 23,
    'Dal Makhani': 15,
    'Mutton Rogan Josh': 11,
    'Chole Bhature': 20,
    'Veg Pulao': 13,
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
