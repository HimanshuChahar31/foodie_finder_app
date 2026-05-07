import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase/firebase_bootstrap.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  bool _googleSignInReady = false;
  bool _isLoggedIn = false;
  String? _email;
  String? _phone;
  String? _name;
  String? _address;
  String? _location;
  String? _gender;
  int? _age;
  String _preferenceCategory = 'Veg';
  String _userRole = 'user'; // 'user' or 'admin'
  String? _verificationId;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get phone => _phone;
  String? get name => _name;
  String? get address => _address;
  String? get location => _location;
  String? get gender => _gender;
  int? get age => _age;
  String get preferenceCategory => _preferenceCategory;
  String get userRole => _userRole;
  bool get isAdmin => _userRole == 'admin';
  String? get userId => _auth?.currentUser?.uid;
  bool get hasPendingPhoneVerification => _verificationId != null;

  AuthProvider() {
    if (FirebaseBootstrap.isInitialized) {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _auth!.authStateChanges().listen((user) async {
        _isLoggedIn = user != null;
        if (user != null) {
          _applyFirebaseUser(user);
          await _loadProfileFromFirestore();
        }
        notifyListeners();
      });
    }
  }

  Future<void> _ensureGoogleSignInReady() async {
    if (_googleSignInReady) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInReady = true;
  }

  void _applyFirebaseUser(User user) {
    _email ??= user.email;
    _phone ??= user.phoneNumber;
    _name ??= user.displayName;
  }

  Future<void> _ensureSignedIn() async {
    if (!FirebaseBootstrap.isInitialized) return;
    _auth ??= FirebaseAuth.instance;
    if (_auth!.currentUser == null) {
      await _auth!.signInAnonymously();
    }
  }

  Future<void> _saveProfileToFirestore() async {
    final uid = userId;
    if (!FirebaseBootstrap.isInitialized || uid == null) return;
    final firestore = _firestore ?? FirebaseFirestore.instance;
    await firestore.collection('users').doc(uid).set({
      'email': _email,
      'phone': _phone,
      'name': _name,
      'address': _address,
      'location': _location,
      'gender': _gender,
      'age': _age,
      'preferenceCategory': _preferenceCategory,
      'userRole': _userRole,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _loadProfileFromFirestore() async {
    final uid = userId;
    if (!FirebaseBootstrap.isInitialized || uid == null) return;
    final firestore = _firestore ?? FirebaseFirestore.instance;
    final snapshot = await firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null) return;
    _email = data['email'] as String?;
    _phone = data['phone'] as String?;
    _name = data['name'] as String?;
    _address = data['address'] as String?;
    _location = data['location'] as String?;
    _gender = data['gender'] as String?;
    _age = data['age'] as int?;
    _preferenceCategory =
        (data['preferenceCategory'] as String?) ?? _preferenceCategory;
    _userRole = (data['userRole'] as String?) ?? _userRole;
  }

  void loginWithEmail(String email) {
    _loginWithEmail(email);
  }

  void loginWithPhone(String phone) {
    _loginWithPhone(phone);
  }

  Future<void> _loginWithEmail(String email) async {
    await _ensureSignedIn();
    _email = email;
    _phone = null;
    _isLoggedIn = true;
    await _saveProfileToFirestore();
    notifyListeners();
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!FirebaseBootstrap.isInitialized) {
      await _loginWithEmail(email);
      return;
    }

    try {
      _auth ??= FirebaseAuth.instance;
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoggedIn = credential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        final credential = await _auth!.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        _isLoggedIn = credential.user != null;
      } else {
        rethrow;
      }
    }

    _email = email;
    _phone = null;
    final user = _auth?.currentUser;
    if (user != null) _applyFirebaseUser(user);
    await _saveProfileToFirestore();
    await _loadProfileFromFirestore();
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    if (!FirebaseBootstrap.isInitialized) {
      throw Exception('Firebase is not initialized.');
    }

    _auth ??= FirebaseAuth.instance;
    await _ensureGoogleSignInReady();

    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      throw Exception('Google sign-in is not supported on this platform.');
    }

    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth!.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) {
      throw Exception('Google sign-in did not return a user.');
    }

    _isLoggedIn = true;
    _email = user.email ?? googleUser.email;
    _phone = user.phoneNumber;
    _name ??= user.displayName ?? googleUser.displayName;
    await _saveProfileToFirestore();
    await _loadProfileFromFirestore();
    notifyListeners();
  }

  Future<void> sendPhoneOtp(String phoneNumber) async {
    if (!FirebaseBootstrap.isInitialized) {
      await _loginWithPhone(phoneNumber);
      return;
    }
    final normalized = _normalizePhone(phoneNumber);
    _auth ??= FirebaseAuth.instance;
    await _auth!.verifyPhoneNumber(
      phoneNumber: normalized,
      verificationCompleted: (credential) async {
        await _auth!.signInWithCredential(credential);
        _isLoggedIn = true;
        _phone = normalized;
        _email = null;
        _verificationId = null;
        await _saveProfileToFirestore();
        await _loadProfileFromFirestore();
        notifyListeners();
      },
      verificationFailed: (e) {
        throw FirebaseAuthException(code: e.code, message: e.message);
      },
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
        notifyListeners();
      },
    );
  }

  Future<void> verifyPhoneOtp({
    required String phoneNumber,
    required String smsCode,
  }) async {
    if (!FirebaseBootstrap.isInitialized) {
      await _loginWithPhone(phoneNumber);
      return;
    }
    final verificationId = _verificationId;
    if (verificationId == null) {
      throw FirebaseAuthException(
        code: 'missing-verification-id',
        message: 'Request OTP first.',
      );
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    _auth ??= FirebaseAuth.instance;
    await _auth!.signInWithCredential(credential);
    _isLoggedIn = true;
    _phone = _normalizePhone(phoneNumber);
    _email = null;
    _verificationId = null;
    await _saveProfileToFirestore();
    await _loadProfileFromFirestore();
    notifyListeners();
  }

  Future<void> _loginWithPhone(String phone) async {
    await _ensureSignedIn();
    _phone = phone;
    _email = null;
    _isLoggedIn = true;
    await _saveProfileToFirestore();
    notifyListeners();
  }

  void setProfileDetails({required String name, required String address}) {
    _name = name;
    _address = address;
    _saveProfileToFirestore();
    notifyListeners();
  }

  Future<void> setBasicDetails({
    required String name,
    required String gender,
    required int age,
  }) async {
    _name = name;
    _gender = gender;
    _age = age;
    await _saveProfileToFirestore();
    notifyListeners();
  }

  Future<void> setSignupProfile({
    required String name,
    required String gender,
  }) async {
    _name = name;
    _gender = gender;
    await _saveProfileToFirestore();
    notifyListeners();
  }

  Future<void> setLocationDetails({required String location}) async {
    _location = location;
    await _saveProfileToFirestore();
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
    _saveProfileToFirestore();
    notifyListeners();
  }

  void logout() {
    _logout();
  }

  Future<void> _logout() async {
    if (FirebaseBootstrap.isInitialized) {
      _auth ??= FirebaseAuth.instance;
      if (_googleSignInReady) {
        await GoogleSignIn.instance.signOut();
      }
      await _auth!.signOut();
    }
    _isLoggedIn = false;
    _email = null;
    _phone = null;
    _name = null;
    _address = null;
    _location = null;
    _gender = null;
    _age = null;
    notifyListeners();
  }

  String _normalizePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.startsWith('+')) return trimmed;
    final digitsOnly = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length == 10) return '+91$digitsOnly';
    return '+$digitsOnly';
  }

  Future<void> updatePassword(String newPassword) async {
    if (!FirebaseBootstrap.isInitialized) return;
    _auth ??= FirebaseAuth.instance;
    final user = _auth!.currentUser;
    if (user == null) return;
    await user.updatePassword(newPassword);
  }

  void updatePreferenceCategory(String category) {
    if (_preferenceCategory != category) {
      _preferenceCategory = category;
      _saveProfileToFirestore();
      notifyListeners();
    }
  }

  void setUserRole(String role) {
    if (_userRole != role) {
      _userRole = role;
      _saveProfileToFirestore();
      notifyListeners();
    }
  }
}
