import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/mysql_helper.dart';

class UserProvider with ChangeNotifier {
  final MySQLHelper _mysqlHelper = MySQLHelper();
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');

    if (userId != null) {
      await loadUser(userId);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _mysqlHelper.getUserByEmail(email);

      if (user != null && user.password == password) {
        // In production, use proper password hashing
        _currentUser = user;

        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('current_user_id', user.userID!);

        // Update last login
        await _mysqlHelper.updateUser(user.copyWith(lastLogin: DateTime.now()));

        notifyListeners();
        return true;
      } else {
        _error = 'Email hoặc mật khẩu không đúng';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error during login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      // Check if email already exists
      final existingUser = await _mysqlHelper.getUserByEmail(email);
      if (existingUser != null) {
        _error = 'Email đã được sử dụng';
        return false;
      }

      // Create new user
      final newUser = User(
        fullName: fullName,
        email: email,
        password: password, // In production, hash the password
        createdAt: DateTime.now(),
      );

      final userId = await _mysqlHelper.insertUser(newUser);
      _currentUser = newUser.copyWith(userID: userId);

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_user_id', userId);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error during registration: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _currentUser = null;

    // Clear saved login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');

    notifyListeners();
  }

  Future<void> loadUser(int userId) async {
    _setLoading(true);
    _error = null;

    try {
      _currentUser = await _mysqlHelper.getUserById(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading user: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUser(User user) async {
    _setLoading(true);
    _error = null;

    try {
      await _mysqlHelper.updateUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating user: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
