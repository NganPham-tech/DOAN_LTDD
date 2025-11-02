import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/simple_firebase_auth_service.dart';
import '../models/home_models.dart' as models;
//D:\DEMOLTDD\wordmaster\lib\providers\simple_firebase_user_provider.dart
class SimpleFirebaseUserProvider with ChangeNotifier {
  final SimpleFirebaseAuthService _authService = SimpleFirebaseAuthService();

  models.User? _currentUser;
  bool _isLoading = false;
  String? _error;

  models.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  // Initialize provider and listen to auth state changes
  SimpleFirebaseUserProvider() {
    print('SimpleFirebaseUserProvider initialized');
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    print('Auth state changed: ${firebaseUser?.email}');
    if (firebaseUser != null) {
      // User is signed in
      _currentUser = models.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName ?? '',
        username: firebaseUser.email?.split('@')[0] ?? '',
        phone: '',
        avatar: '',
      );
      _error = null;
      notifyListeners();
    } else {
      // User is signed out
      _currentUser = null;
      notifyListeners();
    }
  }

  // Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? phone,
  }) async {
    print('Starting registration...');
    _setLoading(true);
    _error = null;

    try {
      final userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      print('Registration successful');
      return userCredential?.user != null;
    } catch (e) {
      print('Registration failed: $e');
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    print('Starting login...');
    _setLoading(true);
    _error = null;

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Login successful');
      return userCredential?.user != null;
    } catch (e) {
      print('Login failed: $e');
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    print('👋 Logging out...');
    _setLoading(true);
    _error = null;

    try {
      await _authService.signOut();
      _currentUser = null;
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout failed: $e');
      _error = 'Lỗi khi đăng xuất: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    print('📧 Sending password reset email...');
    _setLoading(true);
    _error = null;

    try {
      await _authService.sendPasswordResetEmail(email);
      print('✅ Password reset email sent');
      return true;
    } catch (e) {
      print('❌ Password reset email failed: $e');
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
