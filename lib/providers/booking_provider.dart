import 'package:flutter/material.dart';

class BookingRecord {
  final String userName;
  final String contact;
  final String hotelName;
  final String cuisine;
  final int seatCount;
  final double amount;
  final DateTime bookedAt;

  const BookingRecord({
    required this.userName,
    required this.contact,
    required this.hotelName,
    required this.cuisine,
    required this.seatCount,
    required this.amount,
    required this.bookedAt,
  });
}

class BookingProvider extends ChangeNotifier {
  final List<BookingRecord> _bookings = [];

  List<BookingRecord> get bookings => List.unmodifiable(_bookings.reversed);

  void addBooking(BookingRecord booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void clear() {
    _bookings.clear();
    notifyListeners();
  }
}
