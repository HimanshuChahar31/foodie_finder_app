import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/firebase_bootstrap.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  bool _cloudSyncEnabled = true;
  bool _firestoreNetworkDisabled = false;
  bool _googleSignInReady = false;
  static const MethodChannel _nativeConfigChannel = MethodChannel(
    'foodie_finder/native_config',
  );
  bool _authResolved = !FirebaseBootstrap.isInitialized;
  bool _isLoggedIn = false;
  String? _email;
  String? _phone;
  String? _name;
  String? _address;
  String? _location;
  String? _gender;
  String? _locationMode;
  double? _latitude;
  double? _longitude;
  int? _age;
  String _preferenceCategory = 'Veg';
  String _userRole = 'user'; // 'user' or 'admin'
  String? _verificationId;
  String? _authProviderId;
  String? _lastAuthError;

  bool get isLoggedIn => _isLoggedIn;
  bool get authResolved => _authResolved;
  String? get email => _email;
  String? get phone => _phone;
  String? get name => _name;
  String? get address => _address;
  String? get location => _location;
  String? get gender => _gender;
  String? get locationMode => _locationMode;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  int? get age => _age;
  String get preferenceCategory => _preferenceCategory;
  String get userRole => _userRole;
  bool get isAdmin => _userRole == 'admin';
  String? get userId => _auth?.currentUser?.uid;
  bool get hasPendingPhoneVerification => _verificationId != null;
  bool get usesPasswordSignIn => _authProviderId == 'password';
  String? get lastAuthError => _lastAuthError;
  bool get cloudSyncEnabled => _cloudSyncEnabled;
  bool get hasBasicDetails =>
      (_name?.trim().isNotEmpty ?? false) &&
      (_gender?.trim().isNotEmpty ?? false);
  bool get hasLocationDetails =>
      (_address?.trim().isNotEmpty ?? false) &&
      (_location?.trim().isNotEmpty ?? false) &&
      (_locationMode?.trim().isNotEmpty ?? false);
  bool get needsOnboarding => !hasBasicDetails || !hasLocationDetails;

  AuthProvider() {
    if (FirebaseBootstrap.isInitialized) {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      unawaited(_bootstrapSession());
      _auth!.authStateChanges().listen((user) async {
        try {
          if (user == null) {
            _clearSession();
          } else if (user.isAnonymous) {
            await _auth!.signOut();
            _clearSession();
          } else {
            _isLoggedIn = true;
            _applyFirebaseUser(user);
            await _loadProfileFromLocalCache();
            if (_cloudSyncEnabled) {
              await _loadProfileFromFirestoreSafe();
            }
            await _saveProfileToLocalCache();
          }
        } catch (e) {
          debugPrint('Auth state sync failed: $e');
          if (user != null && !user.isAnonymous) {
            _isLoggedIn = true;
            _applyFirebaseUser(user);
            await _loadProfileFromLocalCache();
          } else {
            _clearSession();
          }
        } finally {
          _authResolved = true;
          notifyListeners();
        }
      });
    }
  }

  Future<void> _bootstrapSession() async {
    final user = _auth?.currentUser;
    if (user == null) {
      _authResolved = true;
      notifyListeners();
      return;
    }

    if (user.isAnonymous) {
      await _auth?.signOut();
      _clearSession();
      _authResolved = true;
      notifyListeners();
      return;
    }

    _isLoggedIn = true;
    _applyFirebaseUser(user);
    await _loadProfileFromLocalCache();
    _authResolved = true;
    notifyListeners();

    if (_cloudSyncEnabled) {
      unawaited(
        _loadProfileFromFirestoreSafe().then((_) async {
          await _saveProfileToLocalCache();
          notifyListeners();
        }),
      );
    }
  }

  Future<void> _ensureGoogleSignInReady() async {
    if (_googleSignInReady) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: await _loadDefaultWebClientId(),
    );
    _googleSignInReady = true;
  }

  void _applyFirebaseUser(User user) {
    _email ??= user.email;
    _phone ??= user.phoneNumber;
    _name ??= user.displayName;
    final providerData = user.providerData
        .map((provider) => provider.providerId)
        .where((id) => id.isNotEmpty)
        .toList();
    _authProviderId = providerData.contains('password')
        ? 'password'
        : (providerData.isNotEmpty ? providerData.first : null);
  }

  void _clearSession() {
    _isLoggedIn = false;
    _lastAuthError = null;
    _email = null;
    _phone = null;
    _name = null;
    _address = null;
    _location = null;
    _gender = null;
    _locationMode = null;
    _latitude = null;
    _longitude = null;
    _age = null;
    _verificationId = null;
    _authProviderId = null;
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
    if (!FirebaseBootstrap.isInitialized || uid == null || !_cloudSyncEnabled) {
      return;
    }
    final firestore = _firestore ?? FirebaseFirestore.instance;
    await firestore.collection('users').doc(uid).set({
      'email': _email,
      'phone': _phone,
      'name': _name,
      'address': _address,
      'location': _location,
      'gender': _gender,
      'locationMode': _locationMode,
      'latitude': _latitude,
      'longitude': _longitude,
      'age': _age,
      'preferenceCategory': _preferenceCategory,
      'userRole': _userRole,
      'authProviderId': _authProviderId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _saveProfileToFirestoreSafe() async {
    if (!_cloudSyncEnabled) return;
    try {
      await _saveProfileToFirestore();
      _lastAuthError = null;
    } catch (e) {
      _handleFirestoreFailure(e);
      debugPrint('Profile save skipped: $e');
      _lastAuthError = _friendlyPersistenceError(e);
    }
  }

  Future<void> _loadProfileFromFirestore() async {
    final uid = userId;
    if (!FirebaseBootstrap.isInitialized || uid == null || !_cloudSyncEnabled) {
      return;
    }
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
    _locationMode = data['locationMode'] as String?;
    _latitude = (data['latitude'] as num?)?.toDouble();
    _longitude = (data['longitude'] as num?)?.toDouble();
    _age = data['age'] as int?;
    _preferenceCategory =
        (data['preferenceCategory'] as String?) ?? _preferenceCategory;
    _userRole = (data['userRole'] as String?) ?? _userRole;
    _authProviderId = (data['authProviderId'] as String?) ?? _authProviderId;
  }

  Future<void> _loadProfileFromFirestoreSafe() async {
    if (!_cloudSyncEnabled) return;
    try {
      await _loadProfileFromFirestore();
      _lastAuthError = null;
    } catch (e) {
      _handleFirestoreFailure(e);
      debugPrint('Profile load skipped: $e');
      _lastAuthError = _friendlyPersistenceError(e);
    }
  }

  void _syncProfileInBackground() {
    unawaited(
      _saveProfileToLocalCache().then((_) async {
        if (!_cloudSyncEnabled) return;
        await _saveProfileToFirestoreSafe();
        if (!_cloudSyncEnabled) return;
        await _loadProfileFromFirestoreSafe();
        await _saveProfileToLocalCache();
      }),
    );
  }

  void _handleFirestoreFailure(Object error) {
    final text = error.toString();
    if (text.contains('Cloud Firestore API has not been used') ||
        text.contains('firestore.googleapis.com') ||
        text.contains('PERMISSION_DENIED')) {
      _cloudSyncEnabled = false;
      unawaited(_disableFirestoreNetwork());
    }
  }

  Future<void> _disableFirestoreNetwork() async {
    if (_firestoreNetworkDisabled || !FirebaseBootstrap.isInitialized) return;
    _firestoreNetworkDisabled = true;
    try {
      final firestore = _firestore ?? FirebaseFirestore.instance;
      await firestore.disableNetwork();
    } catch (e) {
      debugPrint('Failed to disable Firestore network: $e');
    }
  }

  Future<void> _saveProfileToLocalCache() async {
    final key = _localProfileKey;
    if (key == null) return;
    final prefs = await SharedPreferences.getInstance();
    final profile = <String, Object?>{
      'email': _email,
      'phone': _phone,
      'name': _name,
      'address': _address,
      'location': _location,
      'gender': _gender,
      'locationMode': _locationMode,
      'latitude': _latitude,
      'longitude': _longitude,
      'age': _age,
      'preferenceCategory': _preferenceCategory,
      'userRole': _userRole,
      'authProviderId': _authProviderId,
    };
    final serialized = profile.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${entry.value}')
        .join('\n');
    await prefs.setString(key, serialized);
  }

  Future<void> _loadProfileFromLocalCache() async {
    final key = _localProfileKey;
    if (key == null) return;
    final prefs = await SharedPreferences.getInstance();
    final serialized = prefs.getString(key);
    if (serialized == null || serialized.trim().isEmpty) return;
    final values = <String, String>{};
    for (final line in serialized.split('\n')) {
      final separator = line.indexOf('=');
      if (separator <= 0) continue;
      values[line.substring(0, separator)] = line.substring(separator + 1);
    }
    _email ??= values['email'];
    _phone ??= values['phone'];
    _name ??= values['name'];
    _address ??= values['address'];
    _location ??= values['location'];
    _gender ??= values['gender'];
    _locationMode ??= values['locationMode'];
    _latitude ??= double.tryParse(values['latitude'] ?? '');
    _longitude ??= double.tryParse(values['longitude'] ?? '');
    _age ??= int.tryParse(values['age'] ?? '');
    _preferenceCategory = values['preferenceCategory'] ?? _preferenceCategory;
    _userRole = values['userRole'] ?? _userRole;
    _authProviderId = values['authProviderId'] ?? _authProviderId;
  }

  String? get _localProfileKey {
    final uid = userId;
    if (uid == null || uid.isEmpty) return null;
    return 'user_profile_$uid';
  }

  String? _friendlyPersistenceError(Object error) {
    final text = error.toString();
    if (text.contains('firestore.googleapis.com') ||
        text.contains('Cloud Firestore API has not been used') ||
        text.contains('PERMISSION_DENIED')) {
      return 'Cloud sync is not enabled yet. Your progress is still saved on this phone.';
    }
    return null;
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
    await _saveProfileToLocalCache();
    await _saveProfileToFirestoreSafe();
    notifyListeners();
  }

  Future<void> loginWithEmailPassword({
    required String identifier,
    required String password,
  }) async {
    if (!FirebaseBootstrap.isInitialized) {
      await _loginWithEmail(identifier);
      return;
    }

    final email = await _resolveEmailIdentifier(identifier);

    try {
      _auth ??= FirebaseAuth.instance;
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoggedIn = credential.user != null;
      _authProviderId = 'password';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Check your email and password, then try again.',
        );
      }
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'No account found for this email.',
        );
      }
      rethrow;
    }

    _email = email;
    _phone = null;
    final user = _auth?.currentUser;
    if (user != null) _applyFirebaseUser(user);
    notifyListeners();
    _syncProfileInBackground();
  }

  Future<void> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!FirebaseBootstrap.isInitialized) {
      await _loginWithEmail(email);
      _name = name;
      _authProviderId = 'password';
      await _saveProfileToLocalCache();
      await _saveProfileToFirestoreSafe();
      notifyListeners();
      return;
    }

    _auth ??= FirebaseAuth.instance;

    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'signup-failed',
          message: 'Could not create your account.',
        );
      }

      await user.updateDisplayName(name.trim());
      _isLoggedIn = true;
      _email = email.trim();
      _name = name.trim();
      _phone = null;
      _authProviderId = 'password';
      notifyListeners();
      _syncProfileInBackground();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'This email is already registered. Please log in.',
        );
      }
      rethrow;
    }
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
    final idToken = googleAuth.idToken?.trim();
    if (idToken == null || idToken.isEmpty) {
      throw Exception(
        'Google sign-in did not return a valid token. Please reinstall the latest app build and check Firebase Google sign-in setup.',
      );
    }
    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
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
    _authProviderId = 'google.com';
    notifyListeners();
    _syncProfileInBackground();
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
        await _saveProfileToLocalCache();
        await _saveProfileToFirestoreSafe();
        await _loadProfileFromFirestoreSafe();
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
    await _saveProfileToLocalCache();
    await _saveProfileToFirestoreSafe();
    await _loadProfileFromFirestoreSafe();
    notifyListeners();
  }

  Future<void> _loginWithPhone(String phone) async {
    await _ensureSignedIn();
    _phone = phone;
    _email = null;
    _isLoggedIn = true;
    await _saveProfileToLocalCache();
    await _saveProfileToFirestoreSafe();
    notifyListeners();
  }

  void setProfileDetails({required String name, required String address}) {
    _name = name;
    _address = address;
    unawaited(_saveProfileToLocalCache());
    _saveProfileToFirestoreSafe();
    notifyListeners();
  }

  Future<void> setPersonalDetails({
    required String name,
    required String gender,
    String? password,
  }) async {
    _name = name;
    _gender = gender;
    final nextPassword = password?.trim();
    if (nextPassword != null && nextPassword.isNotEmpty) {
      try {
        await updatePassword(nextPassword);
      } on FirebaseAuthException catch (e) {
        debugPrint('Password update skipped during onboarding: ${e.code}');
      } catch (e) {
        debugPrint('Password update skipped during onboarding: $e');
      }
    }
    notifyListeners();
    _syncProfileInBackground();
  }

  Future<void> setSignupProfile({
    required String name,
    required String gender,
  }) async {
    _name = name;
    _gender = gender;
    notifyListeners();
    _syncProfileInBackground();
  }

  Future<void> setLocationDetails({
    required String location,
    required String address,
    required String locationMode,
    double? latitude,
    double? longitude,
  }) async {
    _location = location;
    _address = address;
    _locationMode = locationMode;
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
    _syncProfileInBackground();
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
    unawaited(_saveProfileToLocalCache());
    _saveProfileToFirestoreSafe();
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
    _clearSession();
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

  Future<String?> _loadDefaultWebClientId() async {
    if (!FirebaseBootstrap.isInitialized) return null;
    try {
      final clientId = await _nativeConfigChannel.invokeMethod<String>(
        'getDefaultWebClientId',
      );
      final trimmed = clientId?.trim();
      return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
    } on PlatformException catch (e) {
      debugPrint('Default web client id unavailable: ${e.message}');
      return null;
    }
  }

  Future<String> _resolveEmailIdentifier(String identifier) async {
    final value = identifier.trim();
    if (value.contains('@')) {
      return value;
    }

    if (!FirebaseBootstrap.isInitialized) {
      return value;
    }

    if (!_cloudSyncEnabled) {
      throw FirebaseAuthException(
        code: 'name-login-unavailable',
        message:
            'Name login needs cloud sync. Please use your email and password on this device.',
      );
    }

    final firestore = _firestore ?? FirebaseFirestore.instance;
    final query = await firestore
        .collection('users')
        .where('name', isEqualTo: value)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found with this name.',
      );
    }

    final email = query.docs.first.data()['email'] as String?;
    if (email == null || email.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-email',
        message: 'This user does not have an email login.',
      );
    }

    return email.trim();
  }

  void updatePreferenceCategory(String category) {
    if (_preferenceCategory != category) {
      _preferenceCategory = category;
      unawaited(_saveProfileToLocalCache());
      _saveProfileToFirestoreSafe();
      notifyListeners();
    }
  }

  void setUserRole(String role) {
    if (_userRole != role) {
      _userRole = role;
      unawaited(_saveProfileToLocalCache());
      _saveProfileToFirestoreSafe();
      notifyListeners();
    }
  }
}
