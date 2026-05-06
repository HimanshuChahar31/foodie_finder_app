import 'package:flutter/material.dart';
import '../models/dish.dart';

class CartItem {
  final Dish dish;
  final int quantity;

  const CartItem({required this.dish, required this.quantity});

  double get subtotal => dish.price * quantity;
}

class OrderRecord {
  final List<CartItem> items;
  final double deliveryFee;
  final double handlingFee;
  final double total;
  final DateTime orderedAt;

  const OrderRecord({
    required this.items,
    required this.deliveryFee,
    required this.handlingFee,
    required this.total,
    required this.orderedAt,
  });
}

class CartProvider extends ChangeNotifier {
  static const double deliveryPerKm = 20;
  static const double handlingFee = 20;

  final Map<String, CartItem> _items = {};
  final List<OrderRecord> _orders = [];

  List<CartItem> get items => List.unmodifiable(_items.values);
  List<OrderRecord> get orders => List.unmodifiable(_orders.reversed);
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get itemsTotal =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);
  double get deliveryDistanceKm => _items.isEmpty
      ? 0
      : _items.values
            .map((item) => item.dish.distanceKm ?? 0)
            .reduce((a, b) => a > b ? a : b);
  double get deliveryFee =>
      _items.isEmpty ? 0 : deliveryPerKm * deliveryDistanceKm;
  double get total =>
      itemsTotal + deliveryFee + (_items.isEmpty ? 0 : handlingFee);

  int quantityFor(String dishId) => _items[dishId]?.quantity ?? 0;

  void addDish(Dish dish) {
    final current = _items[dish.id];
    _items[dish.id] = CartItem(
      dish: dish,
      quantity: (current?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  void decreaseDish(String dishId) {
    final current = _items[dishId];
    if (current == null) return;
    if (current.quantity <= 1) {
      _items.remove(dishId);
    } else {
      _items[dishId] = CartItem(
        dish: current.dish,
        quantity: current.quantity - 1,
      );
    }
    notifyListeners();
  }

  void removeDish(String dishId) {
    _items.remove(dishId);
    notifyListeners();
  }

  void placeOrder() {
    if (_items.isEmpty) return;
    _orders.add(
      OrderRecord(
        items: List.unmodifiable(_items.values),
        deliveryFee: deliveryFee,
        handlingFee: handlingFee,
        total: total,
        orderedAt: DateTime.now(),
      ),
    );
    _items.clear();
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _orders.clear();
    notifyListeners();
  }
}
