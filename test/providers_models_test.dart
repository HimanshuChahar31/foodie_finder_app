import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodie_finder/models/dish.dart';
import 'package:foodie_finder/models/restaurant.dart';
import 'package:foodie_finder/providers/booking_provider.dart';
import 'package:foodie_finder/providers/cart_provider.dart';
import 'package:foodie_finder/providers/dish_provider.dart';
import 'package:foodie_finder/providers/favorites_provider.dart';

Dish testDish({
  String id = 'dish-1',
  String name = 'Test Dish',
  double price = 100,
  int deliveryTime = 20,
  double? distanceKm = 2,
  String category = 'Veg',
}) {
  return Dish(
    id: id,
    name: name,
    ingredients: const ['Ingredient'],
    price: price,
    deliveryTime: deliveryTime,
    distanceKm: distanceKm,
    restaurantName: 'Test Kitchen',
    location: 'Test Market',
    rating: 4.5,
    imageUrl: 'assets/images/real/dishes/veg-pulao.jpg',
    category: category,
  );
}

void main() {
  group('Dish catalog data', () {
    final provider = DishProvider();
    final dishes = provider.dishes;
    final validCategories = {'Veg', 'Non-Veg', 'Vegan'};

    test('catalog has 30 dishes', () {
      expect(dishes, hasLength(30));
    });

    test('catalog exposes an unmodifiable list', () {
      expect(() => dishes.add(testDish()), throwsA(isA<UnsupportedError>()));
    });

    test('dish ids are unique', () {
      expect(dishes.map((dish) => dish.id).toSet(), hasLength(dishes.length));
    });

    test('dish names are unique', () {
      expect(dishes.map((dish) => dish.name).toSet(), hasLength(dishes.length));
    });

    test('catalog contains only valid categories', () {
      expect(
        dishes.every((dish) => validCategories.contains(dish.category)),
        isTrue,
      );
    });

    test('catalog contains Margherita Pizza', () {
      expect(dishes.map((dish) => dish.name), contains('Margherita Pizza'));
    });

    test('catalog contains Chicken Burger', () {
      expect(dishes.map((dish) => dish.name), contains('Chicken Burger'));
    });

    test('catalog contains Vegan Salad', () {
      expect(dishes.map((dish) => dish.name), contains('Vegan Salad'));
    });

    test('catalog contains Paneer Tikka', () {
      expect(dishes.map((dish) => dish.name), contains('Paneer Tikka'));
    });

    test('catalog contains Beef Steak', () {
      expect(dishes.map((dish) => dish.name), contains('Beef Steak'));
    });

    test('catalog contains Quinoa Bowl', () {
      expect(dishes.map((dish) => dish.name), contains('Quinoa Bowl'));
    });

    test('catalog contains Vegetable Stir Fry', () {
      expect(dishes.map((dish) => dish.name), contains('Vegetable Stir Fry'));
    });

    test('catalog contains Grilled Salmon', () {
      expect(dishes.map((dish) => dish.name), contains('Grilled Salmon'));
    });

    test('catalog contains Avocado Toast', () {
      expect(dishes.map((dish) => dish.name), contains('Avocado Toast'));
    });

    test('catalog contains Chicken Curry', () {
      expect(dishes.map((dish) => dish.name), contains('Chicken Curry'));
    });

    test('catalog contains Chole Bhature', () {
      expect(dishes.map((dish) => dish.name), contains('Chole Bhature'));
    });

    test('catalog contains Dal Makhani', () {
      expect(dishes.map((dish) => dish.name), contains('Dal Makhani'));
    });

    test('catalog contains Paneer Butter Masala', () {
      expect(dishes.map((dish) => dish.name), contains('Paneer Butter Masala'));
    });

    test('catalog contains Rajma Chawal', () {
      expect(dishes.map((dish) => dish.name), contains('Rajma Chawal'));
    });

    test('catalog contains Masala Dosa', () {
      expect(dishes.map((dish) => dish.name), contains('Masala Dosa'));
    });

    test('catalog contains Idli Sambar', () {
      expect(dishes.map((dish) => dish.name), contains('Idli Sambar'));
    });

    test('catalog contains Vegetable Biryani', () {
      expect(dishes.map((dish) => dish.name), contains('Vegetable Biryani'));
    });

    test('catalog contains Aloo Paratha Combo', () {
      expect(dishes.map((dish) => dish.name), contains('Aloo Paratha Combo'));
    });

    test('catalog contains Palak Paneer', () {
      expect(dishes.map((dish) => dish.name), contains('Palak Paneer'));
    });

    test('catalog contains Kadai Mushroom', () {
      expect(dishes.map((dish) => dish.name), contains('Kadai Mushroom'));
    });

    test('catalog contains Butter Chicken', () {
      expect(dishes.map((dish) => dish.name), contains('Butter Chicken'));
    });

    test('catalog contains Chicken Biryani', () {
      expect(dishes.map((dish) => dish.name), contains('Chicken Biryani'));
    });

    test('catalog contains Mutton Rogan Josh', () {
      expect(dishes.map((dish) => dish.name), contains('Mutton Rogan Josh'));
    });

    test('catalog contains Fish Curry Rice', () {
      expect(dishes.map((dish) => dish.name), contains('Fish Curry Rice'));
    });

    test('catalog contains Egg Curry', () {
      expect(dishes.map((dish) => dish.name), contains('Egg Curry'));
    });

    test('catalog contains Chicken Tikka', () {
      expect(dishes.map((dish) => dish.name), contains('Chicken Tikka'));
    });

    test('catalog contains Prawn Masala', () {
      expect(dishes.map((dish) => dish.name), contains('Prawn Masala'));
    });

    test('catalog contains Keema Pav', () {
      expect(dishes.map((dish) => dish.name), contains('Keema Pav'));
    });

    test('catalog contains Baingan Bharta', () {
      expect(dishes.map((dish) => dish.name), contains('Baingan Bharta'));
    });

    test('catalog contains Veg Pulao', () {
      expect(dishes.map((dish) => dish.name), contains('Veg Pulao'));
    });

    test('Margherita Pizza image asset exists', () {
      expect(
        File('assets/images/real/dishes/margherita-pizza.jpg').existsSync(),
        isTrue,
      );
    });

    test('Chicken Burger image asset exists', () {
      expect(
        File('assets/images/real/dishes/chicken-burger.jpg').existsSync(),
        isTrue,
      );
    });

    test('Vegan Salad image asset exists', () {
      expect(
        File('assets/images/real/dishes/vegan-salad.jpg').existsSync(),
        isTrue,
      );
    });

    test('Paneer Tikka image asset exists', () {
      expect(
        File('assets/images/real/dishes/paneer-tikka.jpg').existsSync(),
        isTrue,
      );
    });

    test('Beef Steak image asset exists', () {
      expect(
        File('assets/images/real/dishes/beef-steak.jpg').existsSync(),
        isTrue,
      );
    });

    test('Quinoa Bowl image asset exists', () {
      expect(
        File('assets/images/real/dishes/quinoa-bowl.jpg').existsSync(),
        isTrue,
      );
    });

    test('Vegetable Stir Fry image asset exists', () {
      expect(
        File('assets/images/real/dishes/vegetable-stir-fry.jpg').existsSync(),
        isTrue,
      );
    });

    test('Grilled Salmon image asset exists', () {
      expect(
        File('assets/images/real/dishes/grilled-salmon.jpg').existsSync(),
        isTrue,
      );
    });

    test('Avocado Toast image asset exists', () {
      expect(
        File('assets/images/real/dishes/avocado-toast.jpg').existsSync(),
        isTrue,
      );
    });

    test('Chicken Curry image asset exists', () {
      expect(
        File('assets/images/real/dishes/chicken-curry.jpg').existsSync(),
        isTrue,
      );
    });

    test('Chole Bhature image asset exists', () {
      expect(
        File('assets/images/real/dishes/chole-bhature.jpg').existsSync(),
        isTrue,
      );
    });

    test('Dal Makhani image asset exists', () {
      expect(
        File('assets/images/real/dishes/dal-makhani.jpg').existsSync(),
        isTrue,
      );
    });

    test('Paneer Butter Masala image asset exists', () {
      expect(
        File('assets/images/real/dishes/paneer-butter-masala.jpg').existsSync(),
        isTrue,
      );
    });

    test('Rajma Chawal image asset exists', () {
      expect(
        File('assets/images/real/dishes/rajma-chawal.jpg').existsSync(),
        isTrue,
      );
    });

    test('Masala Dosa image asset exists', () {
      expect(
        File('assets/images/real/dishes/masala-dosa.jpg').existsSync(),
        isTrue,
      );
    });

    test('Idli Sambar image asset exists', () {
      expect(
        File('assets/images/real/dishes/idli-sambar.jpg').existsSync(),
        isTrue,
      );
    });

    test('Vegetable Biryani image asset exists', () {
      expect(
        File('assets/images/real/dishes/vegetable-biryani.jpg').existsSync(),
        isTrue,
      );
    });

    test('Aloo Paratha Combo image asset exists', () {
      expect(
        File('assets/images/real/dishes/aloo-paratha-combo.jpg').existsSync(),
        isTrue,
      );
    });

    test('Palak Paneer image asset exists', () {
      expect(
        File('assets/images/real/dishes/palak-paneer.jpg').existsSync(),
        isTrue,
      );
    });

    test('Kadai Mushroom image asset exists', () {
      expect(
        File('assets/images/real/dishes/kadai-mushroom.jpg').existsSync(),
        isTrue,
      );
    });

    test('Butter Chicken image asset exists', () {
      expect(
        File('assets/images/real/dishes/butter-chicken.jpg').existsSync(),
        isTrue,
      );
    });

    test('Chicken Biryani image asset exists', () {
      expect(
        File('assets/images/real/dishes/chicken-biryani.jpg').existsSync(),
        isTrue,
      );
    });

    test('Mutton Rogan Josh image asset exists', () {
      expect(
        File('assets/images/real/dishes/mutton-rogan-josh.jpg').existsSync(),
        isTrue,
      );
    });

    test('Fish Curry Rice image asset exists', () {
      expect(
        File('assets/images/real/dishes/fish-curry-rice.jpg').existsSync(),
        isTrue,
      );
    });

    test('Egg Curry image asset exists', () {
      expect(
        File('assets/images/real/dishes/egg-curry.jpg').existsSync(),
        isTrue,
      );
    });

    test('Chicken Tikka image asset exists', () {
      expect(
        File('assets/images/real/dishes/chicken-tikka.jpg').existsSync(),
        isTrue,
      );
    });

    test('Prawn Masala image asset exists', () {
      expect(
        File('assets/images/real/dishes/prawn-masala.jpg').existsSync(),
        isTrue,
      );
    });

    test('Keema Pav image asset exists', () {
      expect(
        File('assets/images/real/dishes/keema-pav.jpg').existsSync(),
        isTrue,
      );
    });

    test('Baingan Bharta image asset exists', () {
      expect(
        File('assets/images/real/dishes/baingan-bharta.jpg').existsSync(),
        isTrue,
      );
    });

    test('Veg Pulao image asset exists', () {
      expect(
        File('assets/images/real/dishes/veg-pulao.jpg').existsSync(),
        isTrue,
      );
    });

    for (final dish in dishes) {
      group(dish.name, () {
        test('has a non-empty id', () {
          expect(dish.id.trim(), isNotEmpty);
        });

        test('has a numeric positive id', () {
          expect(int.tryParse(dish.id), isNotNull);
          expect(int.parse(dish.id), greaterThan(0));
        });

        test('has a non-empty name', () {
          expect(dish.name.trim(), isNotEmpty);
        });

        test('has at least one ingredient', () {
          expect(dish.ingredients, isNotEmpty);
        });

        test('has no blank ingredients', () {
          expect(
            dish.ingredients.every(
              (ingredient) => ingredient.trim().isNotEmpty,
            ),
            isTrue,
          );
        });

        test('has a positive price', () {
          expect(dish.price, greaterThan(0));
        });

        test('has a realistic delivery time', () {
          expect(dish.deliveryTime, inInclusiveRange(1, 60));
        });

        test('has a known category', () {
          expect(validCategories, contains(dish.category));
        });

        test('has a valid rating', () {
          expect(dish.rating, inInclusiveRange(0, 5));
        });

        test('has a restaurant name', () {
          expect(dish.restaurantName.trim(), isNotEmpty);
        });

        test('has a location', () {
          expect(dish.location.trim(), isNotEmpty);
        });

        test('has a local image asset path', () {
          expect(dish.imageUrl, startsWith('assets/images/real/dishes/'));
          expect(dish.imageUrl, isNot(contains('http')));
        });

        test('has an image file on disk', () {
          expect(File(dish.imageUrl).existsSync(), isTrue);
        });

        test('has a non-negative delivery distance', () {
          expect(dish.distanceKm, isNotNull);
          expect(dish.distanceKm!, greaterThanOrEqualTo(0));
        });

        test('appears in all-results filter output', () {
          expect(
            provider.filteredDishes('Veg').map((item) => item.id),
            contains(dish.id),
          );
        });
      });
    }
  });

  group('DishProvider filtering and scoring', () {
    late DishProvider provider;

    setUp(() {
      provider = DishProvider();
    });

    test('default category filter is All', () {
      expect(provider.selectedCategory, 'All');
    });

    test('default search query is empty', () {
      expect(provider.searchQuery, isEmpty);
    });

    test('category filters expose all supported categories', () {
      expect(provider.categoryFilters, ['All', 'Veg', 'Non-Veg', 'Vegan']);
    });

    test('category distribution totals 100 percent', () {
      final total = provider.categoryDistribution.values.fold<double>(
        0,
        (sum, value) => sum + value,
      );
      expect(total, closeTo(100, 0.0001));
    });

    test('category distribution includes Veg', () {
      expect(provider.categoryDistribution['Veg'], closeTo(40, 0.0001));
    });

    test('category distribution includes Non-Veg', () {
      expect(provider.categoryDistribution['Non-Veg'], closeTo(40, 0.0001));
    });

    test('category distribution includes Vegan', () {
      expect(provider.categoryDistribution['Vegan'], closeTo(20, 0.0001));
    });

    test('Veg category filter returns only veg dishes', () {
      provider.updateCategoryFilter('Veg');
      expect(
        provider.filteredDishes('Veg').every((dish) => dish.category == 'Veg'),
        isTrue,
      );
    });

    test('Non-Veg category filter returns only non-veg dishes', () {
      provider.updateCategoryFilter('Non-Veg');
      expect(
        provider
            .filteredDishes('Non-Veg')
            .every((dish) => dish.category == 'Non-Veg'),
        isTrue,
      );
    });

    test('Vegan category filter returns only vegan dishes', () {
      provider.updateCategoryFilter('Vegan');
      expect(
        provider
            .filteredDishes('Vegan')
            .every((dish) => dish.category == 'Vegan'),
        isTrue,
      );
    });

    test('search matches dish names case-insensitively', () {
      provider.updateSearchQuery('paneer');
      expect(
        provider.filteredDishes('Veg').map((dish) => dish.name),
        containsAll(['Paneer Tikka', 'Paneer Butter Masala', 'Palak Paneer']),
      );
    });

    test('search matches ingredients', () {
      provider.updateSearchQuery('saffron');
      expect(
        provider.filteredDishes('Veg').map((dish) => dish.name),
        containsAll(['Vegetable Biryani', 'Chicken Biryani']),
      );
    });

    test('search matches restaurant names', () {
      provider.updateSearchQuery('palace');
      expect(provider.filteredDishes('Veg').single.name, 'Margherita Pizza');
    });

    test('search can be combined with category filter', () {
      provider.updateCategoryFilter('Non-Veg');
      provider.updateSearchQuery('biryani');
      expect(provider.filteredDishes('Non-Veg').single.name, 'Chicken Biryani');
    });

    test('recommendations return exactly four dishes', () {
      expect(provider.recommendedDishes('Veg'), hasLength(4));
    });

    test('veg recommendations prefer veg dishes first', () {
      expect(provider.recommendedDishes('Veg').first.category, 'Veg');
    });

    test('non-veg recommendations prefer non-veg dishes first', () {
      expect(provider.recommendedDishes('Non-Veg').first.category, 'Non-Veg');
    });

    test('vegan recommendations prefer vegan dishes first', () {
      expect(provider.recommendedDishes('Vegan').first.category, 'Vegan');
    });

    test('most ordered dishes are sorted descending', () {
      final orders = provider.mostOrderedDishes;
      for (var i = 1; i < orders.length; i++) {
        expect(orders[i - 1].value, greaterThanOrEqualTo(orders[i].value));
      }
    });

    test('weekly spending spots preserve index positions', () {
      final spots = provider.spendingTrendSpots;
      for (var i = 0; i < spots.length; i++) {
        expect(spots[i].x, i.toDouble());
      }
    });

    test('recordOrder increments order count', () {
      final before = Map.fromEntries(provider.mostOrderedDishes);
      provider.recordOrder('1');
      final after = Map.fromEntries(provider.mostOrderedDishes);
      expect(after['Margherita Pizza'], (before['Margherita Pizza'] ?? 0) + 1);
    });

    test('recordOrder adds price to latest spending spot', () {
      final before = provider.spendingTrendSpots.last.y;
      provider.recordOrder('1');
      expect(provider.spendingTrendSpots.last.y, before + 449);
    });

    test('recordOrder notifies listeners once', () {
      var notifications = 0;
      provider.addListener(() => notifications++);
      provider.recordOrder('1');
      expect(notifications, 1);
    });

    test('recordOrder throws for unknown dish', () {
      expect(() => provider.recordOrder('unknown'), throwsArgumentError);
    });
  });

  group('FavoritesProvider', () {
    late FavoritesProvider provider;
    late List<Dish> dishes;

    setUp(() {
      provider = FavoritesProvider();
      dishes = [
        testDish(id: '1', name: 'First'),
        testDish(id: '2', name: 'Second'),
      ];
    });

    test('starts with no favorite ids', () {
      expect(provider.favoriteDishIds, isEmpty);
    });

    test('reports unknown dish as not favorite', () {
      expect(provider.isFavorite('1'), isFalse);
    });

    test('toggleFavorite adds a dish id', () {
      provider.toggleFavorite('1');
      expect(provider.isFavorite('1'), isTrue);
    });

    test('toggleFavorite removes an existing dish id', () {
      provider.toggleFavorite('1');
      provider.toggleFavorite('1');
      expect(provider.isFavorite('1'), isFalse);
    });

    test('favoriteDishIds is unmodifiable', () {
      provider.toggleFavorite('1');
      expect(
        () => provider.favoriteDishIds.add('2'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('favoritesFor returns matching dishes only', () {
      provider.toggleFavorite('2');
      expect(provider.favoritesFor(dishes).single.name, 'Second');
    });

    test('favoritesFor preserves source order', () {
      provider.toggleFavorite('2');
      provider.toggleFavorite('1');
      expect(provider.favoritesFor(dishes).map((dish) => dish.id), ['1', '2']);
    });

    test('toggleFavorite notifies listeners', () {
      var notifications = 0;
      provider.addListener(() => notifications++);
      provider.toggleFavorite('1');
      expect(notifications, 1);
    });
  });

  group('CartProvider', () {
    late CartProvider cart;
    late Dish nearDish;
    late Dish farDish;

    setUp(() {
      cart = CartProvider();
      nearDish = testDish(
        id: '1',
        name: 'Near Dish',
        price: 120,
        distanceKm: 2,
      );
      farDish = testDish(id: '2', name: 'Far Dish', price: 80, distanceKm: 5);
    });

    test('starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.total, 0);
    });

    test('addDish adds a cart item', () {
      cart.addDish(nearDish);
      expect(cart.items.single.dish.id, '1');
    });

    test('addDish increments quantity for duplicate dish', () {
      cart.addDish(nearDish);
      cart.addDish(nearDish);
      expect(cart.quantityFor('1'), 2);
    });

    test('itemCount sums quantities', () {
      cart.addDish(nearDish);
      cart.addDish(nearDish);
      cart.addDish(farDish);
      expect(cart.itemCount, 3);
    });

    test('itemsTotal sums subtotals', () {
      cart.addDish(nearDish);
      cart.addDish(nearDish);
      cart.addDish(farDish);
      expect(cart.itemsTotal, 320);
    });

    test('deliveryDistanceKm uses the farthest item', () {
      cart.addDish(nearDish);
      cart.addDish(farDish);
      expect(cart.deliveryDistanceKm, 5);
    });

    test('deliveryFee uses per-km rate', () {
      cart.addDish(farDish);
      expect(cart.deliveryFee, 100);
    });

    test('total includes items, delivery, and handling fee', () {
      cart.addDish(nearDish);
      expect(cart.total, 180);
    });

    test('decreaseDish lowers quantity', () {
      cart.addDish(nearDish);
      cart.addDish(nearDish);
      cart.decreaseDish('1');
      expect(cart.quantityFor('1'), 1);
    });

    test('decreaseDish removes final quantity', () {
      cart.addDish(nearDish);
      cart.decreaseDish('1');
      expect(cart.quantityFor('1'), 0);
    });

    test('decreaseDish ignores unknown dish ids', () {
      cart.decreaseDish('missing');
      expect(cart.items, isEmpty);
    });

    test('removeDish removes item', () {
      cart.addDish(nearDish);
      cart.removeDish('1');
      expect(cart.items, isEmpty);
    });

    test('placeOrder ignores empty carts', () {
      cart.placeOrder();
      expect(cart.orders, isEmpty);
    });

    test('placeOrder records an order', () {
      cart.addDish(nearDish);
      cart.placeOrder();
      expect(cart.orders, hasLength(1));
    });

    test('placeOrder clears cart items', () {
      cart.addDish(nearDish);
      cart.placeOrder();
      expect(cart.items, isEmpty);
    });

    test('orders are returned newest first', () {
      cart.addDish(nearDish);
      cart.placeOrder();
      cart.addDish(farDish);
      cart.placeOrder();
      expect(cart.orders.first.items.single.dish.id, '2');
    });

    test('clearAll clears items and orders', () {
      cart.addDish(nearDish);
      cart.placeOrder();
      cart.addDish(farDish);
      cart.clearAll();
      expect(cart.items, isEmpty);
      expect(cart.orders, isEmpty);
    });

    test('items getter is unmodifiable', () {
      cart.addDish(nearDish);
      expect(
        () => cart.items.add(CartItem(dish: farDish, quantity: 1)),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('orders getter is unmodifiable', () {
      cart.addDish(nearDish);
      cart.placeOrder();
      expect(() => cart.orders.clear(), throwsA(isA<UnsupportedError>()));
    });

    test('addDish notifies listeners', () {
      var notifications = 0;
      cart.addListener(() => notifications++);
      cart.addDish(nearDish);
      expect(notifications, 1);
    });
  });

  group('BookingProvider and models', () {
    test('BookingRecord stores constructor values', () {
      final bookedAt = DateTime(2026, 5, 8, 12);
      final scheduledAt = DateTime(2026, 5, 9, 20);
      final booking = BookingRecord(
        userName: 'Himanshu',
        contact: '9999999999',
        hotelName: 'Royal Dawat',
        cuisine: 'Indian',
        seatCount: 4,
        amount: 1200,
        bookedAt: bookedAt,
        scheduledAt: scheduledAt,
      );

      expect(booking.userName, 'Himanshu');
      expect(booking.contact, '9999999999');
      expect(booking.hotelName, 'Royal Dawat');
      expect(booking.cuisine, 'Indian');
      expect(booking.seatCount, 4);
      expect(booking.amount, 1200);
      expect(booking.bookedAt, bookedAt);
      expect(booking.scheduledAt, scheduledAt);
    });

    test('BookingProvider starts empty', () {
      expect(BookingProvider().bookings, isEmpty);
    });

    test('BookingProvider adds bookings', () {
      final provider = BookingProvider();
      provider.addBooking(
        BookingRecord(
          userName: 'User',
          contact: '123',
          hotelName: 'Hotel',
          cuisine: 'Indian',
          seatCount: 2,
          amount: 500,
          bookedAt: DateTime(2026, 5, 8),
          scheduledAt: DateTime(2026, 5, 9),
        ),
      );
      expect(provider.bookings, hasLength(1));
    });

    test('BookingProvider returns newest bookings first', () {
      final provider = BookingProvider();
      provider.addBooking(
        BookingRecord(
          userName: 'First',
          contact: '1',
          hotelName: 'One',
          cuisine: 'Indian',
          seatCount: 1,
          amount: 100,
          bookedAt: DateTime(2026, 5, 8),
          scheduledAt: DateTime(2026, 5, 9),
        ),
      );
      provider.addBooking(
        BookingRecord(
          userName: 'Second',
          contact: '2',
          hotelName: 'Two',
          cuisine: 'Indian',
          seatCount: 2,
          amount: 200,
          bookedAt: DateTime(2026, 5, 10),
          scheduledAt: DateTime(2026, 5, 11),
        ),
      );
      expect(provider.bookings.first.userName, 'Second');
    });

    test('BookingProvider clear removes bookings', () {
      final provider = BookingProvider();
      provider.addBooking(
        BookingRecord(
          userName: 'User',
          contact: '123',
          hotelName: 'Hotel',
          cuisine: 'Indian',
          seatCount: 2,
          amount: 500,
          bookedAt: DateTime(2026, 5, 8),
          scheduledAt: DateTime(2026, 5, 9),
        ),
      );
      provider.clear();
      expect(provider.bookings, isEmpty);
    });

    test('Restaurant stores constructor values', () {
      final restaurant = Restaurant(
        id: 'r1',
        name: 'Kake Di Hatti',
        rating: 4.6,
        distance: 2.5,
        pricePerSeat: 350,
        imageUrl: 'assets/images/real/restaurants/kake-di-hatti.jpg',
        cuisine: 'North Indian',
        description: 'Classic food',
      );

      expect(restaurant.id, 'r1');
      expect(restaurant.name, 'Kake Di Hatti');
      expect(restaurant.rating, 4.6);
      expect(restaurant.distance, 2.5);
      expect(restaurant.pricePerSeat, 350);
      expect(restaurant.imageUrl, contains('kake-di-hatti.jpg'));
      expect(restaurant.cuisine, 'North Indian');
      expect(restaurant.description, 'Classic food');
    });

    test('CartItem subtotal multiplies price and quantity', () {
      final item = CartItem(dish: testDish(price: 125), quantity: 3);
      expect(item.subtotal, 375);
    });

    test('OrderRecord stores totals', () {
      final order = OrderRecord(
        items: [CartItem(dish: testDish(price: 100), quantity: 2)],
        deliveryFee: 40,
        handlingFee: 20,
        total: 260,
        orderedAt: DateTime(2026, 5, 8),
      );
      expect(order.total, 260);
    });

    test('OrderRecord stores item list', () {
      final item = CartItem(dish: testDish(id: 'stored'), quantity: 1);
      final order = OrderRecord(
        items: [item],
        deliveryFee: 0,
        handlingFee: 0,
        total: 100,
        orderedAt: DateTime(2026, 5, 8),
      );
      expect(order.items.single.dish.id, 'stored');
    });

    test('testDish helper can create non-veg dishes', () {
      expect(testDish(category: 'Non-Veg').category, 'Non-Veg');
    });

    test('testDish helper can create dishes without distance', () {
      expect(testDish(distanceKm: null).distanceKm, isNull);
    });

    test('testDish helper keeps requested delivery time', () {
      expect(testDish(deliveryTime: 45).deliveryTime, 45);
    });

    test('testDish helper keeps requested name', () {
      expect(testDish(name: 'Custom Dish').name, 'Custom Dish');
    });
  });
}
