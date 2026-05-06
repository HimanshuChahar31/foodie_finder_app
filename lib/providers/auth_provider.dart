import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _phone;
  String? _name;
  String? _address;
  String? _location;
  String _preferenceCategory = 'Veg';
  String _userRole = 'user'; // 'user' or 'admin'

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get phone => _phone;
  String? get name => _name;
  String? get address => _address;
  String? get location => _location;
  String get preferenceCategory => _preferenceCategory;
  String get userRole => _userRole;
  bool get isAdmin => _userRole == 'admin';

  void loginWithEmail(String email) {
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  void loginWithPhone(String phone) {
    _phone = phone;
    _isLoggedIn = true;
    notifyListeners();
  }

  void setProfileDetails({required String name, required String address}) {
    _name = name;
    _address = address;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String address,
    required String location,
    String? email,
    String? phone,
  }) {
    _name = name;
    _address = address;
    _location = location;
    _email = email?.trim().isEmpty ?? true ? null : email?.trim();
    _phone = phone?.trim().isEmpty ?? true ? null : phone?.trim();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _email = null;
    _phone = null;
    _name = null;
    _address = null;
    _location = null;
    notifyListeners();
  }

  void updatePreferenceCategory(String category) {
    if (_preferenceCategory != category) {
      _preferenceCategory = category;
      notifyListeners();
    }
  }

  void setUserRole(String role) {
    if (_userRole != role) {
      _userRole = role;
      notifyListeners();
    }
  }
}
