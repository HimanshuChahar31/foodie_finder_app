class Dish {
  final String id;
  final String name;
  final List<String> ingredients;
  final double price;
  final int deliveryTime; // in minutes
  final double? distanceKm;
  final String restaurantName;
  final String location;
  final double rating;
  final String imageUrl;
  final String category; // Veg, Non-Veg, Vegan

  Dish({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.price,
    required this.deliveryTime,
    this.distanceKm,
    required this.restaurantName,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.category,
  });
}
