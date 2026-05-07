import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/firebase_bootstrap.dart';
import 'auth_provider.dart';

class BookingRecord {
  final String userName;
  final String contact;
  final String hotelName;
  final String cuisine;
  final int seatCount;
  final double amount;
  final DateTime bookedAt;
  final DateTime scheduledAt;

  const BookingRecord({
    required this.userName,
    required this.contact,
    required this.hotelName,
    required this.cuisine,
    required this.seatCount,
    required this.amount,
    required this.bookedAt,
    required this.scheduledAt,
  });
}

class BookingProvider extends ChangeNotifier {
  AuthProvider? _authProvider;
  FirebaseFirestore? _firestore;
  final List<BookingRecord> _bookings = [];

  List<BookingRecord> get bookings => List.unmodifiable(_bookings.reversed);

  void attachAuthProvider(AuthProvider authProvider) {
    final previousUid = _authProvider?.userId;
    _authProvider = authProvider;
    final currentUid = _authProvider?.userId;
    if (currentUid != null && currentUid != previousUid) {
      loadFromFirestore();
    }
  }

  void addBooking(BookingRecord booking) {
    _bookings.add(booking);
    _persistBooking(booking);
    notifyListeners();
  }

  void clear() {
    _bookings.clear();
    notifyListeners();
  }

  Future<void> loadFromFirestore() async {
    final uid = _authProvider?.userId;
    if (!FirebaseBootstrap.isInitialized || uid == null) return;
    _firestore ??= FirebaseFirestore.instance;
    final snapshot = await _firestore!
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .orderBy('bookedAt', descending: false)
        .get();
    _bookings
      ..clear()
      ..addAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          return BookingRecord(
            userName: (data['userName'] as String?) ?? 'Foodie User',
            contact: (data['contact'] as String?) ?? 'No contact',
            hotelName: (data['hotelName'] as String?) ?? 'Unknown Hotel',
            cuisine: (data['cuisine'] as String?) ?? 'Unknown Cuisine',
            seatCount: (data['seatCount'] as num?)?.toInt() ?? 0,
            amount: (data['amount'] as num?)?.toDouble() ?? 0,
            bookedAt:
                (data['bookedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            scheduledAt:
                (data['scheduledAt'] as Timestamp?)?.toDate() ??
                (data['bookedAt'] as Timestamp?)?.toDate() ??
                DateTime.now(),
          );
        }),
      );
    notifyListeners();
  }

  Future<void> _persistBooking(BookingRecord booking) async {
    final uid = _authProvider?.userId;
    if (!FirebaseBootstrap.isInitialized || uid == null) return;
    _firestore ??= FirebaseFirestore.instance;
    await _firestore!.collection('users').doc(uid).collection('bookings').add({
      'userName': booking.userName,
      'contact': booking.contact,
      'hotelName': booking.hotelName,
      'cuisine': booking.cuisine,
      'seatCount': booking.seatCount,
      'amount': booking.amount,
      'bookedAt': Timestamp.fromDate(booking.bookedAt),
      'scheduledAt': Timestamp.fromDate(booking.scheduledAt),
    });
  }
}
