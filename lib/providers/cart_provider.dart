import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dish.dart';
import '../firebase/firebase_bootstrap.dart';
import 'auth_provider.dart';

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

  AuthProvider? _authProvider;
  FirebaseFirestore? _firestore;

  final Map<String, CartItem> _items = {};
  final List<OrderRecord> _orders = [];

  List<CartItem> get items => List.unmodifiable(_items.values);
  List<OrderRecord> get orders => List.unmodifiable(_orders.reversed);
  int get itemCount =>
      _items.values.fold(0, (acc, item) => acc + item.quantity);
  double get itemsTotal =>
      _items.values.fold(0, (totalValue, item) => totalValue + item.subtotal);
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

  void attachAuthProvider(AuthProvider authProvider) {
    final previousUid = _authProvider?.userId;
    _authProvider = authProvider;
    final currentUid = _authProvider?.userId;
    if (currentUid != null && currentUid != previousUid) {
      loadOrdersFromFirestore();
    }
  }

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
    final order = OrderRecord(
      items: List.unmodifiable(_items.values),
      deliveryFee: deliveryFee,
      handlingFee: handlingFee,
      total: total,
      orderedAt: DateTime.now(),
    );
    _orders.add(order);
    _persistOrder(order);
    _items.clear();
    notifyListeners();
  }

  Future<void> _persistOrder(OrderRecord order) async {
    final uid = _authProvider?.userId;
    if (!FirebaseBootstrap.isInitialized || uid == null) return;
    _firestore ??= FirebaseFirestore.instance;
    await _firestore!.collection('users').doc(uid).collection('orders').add({
      'items': order.items
          .map(
            (item) => {
              'dishId': item.dish.id,
              'name': item.dish.name,
              'price': item.dish.price,
              'quantity': item.quantity,
            },
          )
          .toList(),
      'deliveryFee': order.deliveryFee,
      'handlingFee': order.handlingFee,
      'total': order.total,
      'orderedAt': Timestamp.fromDate(order.orderedAt),
    });
  }

  Future<void> loadOrdersFromFirestore() async {
    final uid = _authProvider?.userId;
    if (!FirebaseBootstrap.isInitialized || uid == null) return;
    _firestore ??= FirebaseFirestore.instance;
    final snapshot = await _firestore!
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('orderedAt', descending: false)
        .get();

    _orders
      ..clear()
      ..addAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          final storedItems = (data['items'] as List<dynamic>? ?? []).map((
            raw,
          ) {
            final item = raw as Map<String, dynamic>;
            final dish = Dish(
              id: (item['dishId'] as String?) ?? '',
              name: (item['name'] as String?) ?? 'Unknown Dish',
              ingredients: const [],
              price: (item['price'] as num?)?.toDouble() ?? 0,
              deliveryTime: 0,
              restaurantName: '',
              location: '',
              rating: 0,
              imageUrl: '',
              category: 'Veg',
            );
            return CartItem(
              dish: dish,
              quantity: (item['quantity'] as num?)?.toInt() ?? 0,
            );
          }).toList();
          return OrderRecord(
            items: storedItems,
            deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0,
            handlingFee: (data['handlingFee'] as num?)?.toDouble() ?? 0,
            total: (data['total'] as num?)?.toDouble() ?? 0,
            orderedAt:
                (data['orderedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
        }),
      );
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    _orders.clear();
    notifyListeners();
  }
}
