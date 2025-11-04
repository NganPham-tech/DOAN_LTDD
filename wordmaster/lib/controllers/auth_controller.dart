import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:async';
import '../services/simple_firebase_auth_service.dart';
import '../models/home_models.dart' as models;
//D:\DEMOLTDD\wordmaster\lib\controllers\auth_controller.dart
class AuthController extends GetxController {
  final SimpleFirebaseAuthService _authService = SimpleFirebaseAuthService();

  // Observable variables
  var currentUser = Rx<models.User?>(null);
  var isLoading = false.obs;
  var error = Rx<String?>(null);

  // Getters
  bool get isLoggedIn {
    final loggedIn = currentUser.value != null;
    print('isLoggedIn getter called: $loggedIn (currentUser: ${currentUser.value?.email})');
    return loggedIn;
  }
  String? get userEmail => currentUser.value?.email;
  String? get userName => currentUser.value?.fullName;
  String? get firebaseUid => currentUser.value?.id;

  @override
  void onInit() {
    super.onInit();
    print('AuthController initialized');
    
    // Listen to Firebase auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  @override
  void onClose() {
    print('AuthController disposed');
    super.onClose();
  }

  
  void _onAuthStateChanged(firebase_auth.User? firebaseUser) async {
    print('Auth state changed: ${firebaseUser?.email}');
    
    if (firebaseUser != null) {
      // User is signed in
      currentUser.value = models.User(
        id: firebaseUser.uid, // Firebase UID
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName ?? '',
        username: firebaseUser.email?.split('@')[0] ?? '',
        phone: '',
        avatar: '',
      );
      error.value = null;
      
      print('User logged in: ${firebaseUser.email}');
      print('Firebase UID: ${firebaseUser.uid}');
    } else {
      // User is signed out
      currentUser.value = null;
      print('User logged out');
    }
  }

  
  
  /// Register new user with Firebase
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? phone,
  }) async {
    try {
      print('Starting registration...');
      isLoading.value = true;
      error.value = null;

      final userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (userCredential?.user != null) {
        print('Registration successful');
        print('Firebase UID: ${userCredential!.user!.uid}');
        
        Get.snackbar(
          'Thành công',
          'Đăng ký tài khoản thành công!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Registration failed: $e');
      error.value = _parseFirebaseError(e.toString());
      
      Get.snackbar(
        'Lỗi đăng ký',
        error.value!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  
  /// Login user with Firebase
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Starting login...');
      isLoading.value = true;
      error.value = null;

      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential?.user != null) {
        print('Login successful');
        print('Firebase UID: ${userCredential!.user!.uid}');
        
        // Manually update currentUser immediately after successful login
        currentUser.value = models.User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          fullName: userCredential.user!.displayName ?? '',
          username: userCredential.user!.email?.split('@')[0] ?? '',
          phone: '',
          avatar: '',
        );
        
        print('currentUser.value updated manually');
        print('isLoggedIn: ${isLoggedIn}');
        
        // Set loading to false immediately
        isLoading.value = false;
        
        // Force UI update by triggering reactive rebuild
        currentUser.refresh();
        
        Get.snackbar(
          'Đăng nhập thành công',
          'Chào mừng bạn trở lại!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Login failed: $e');
      error.value = _parseFirebaseError(e.toString());
      
      Get.snackbar(
        'Lỗi đăng nhập',
        error.value!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  
  /// Logout current user
  Future<void> logout() async {
    try {
      print('Logging out...');
      isLoading.value = true;
      error.value = null;

      await _authService.signOut();
      currentUser.value = null;
      
      print('Logout successful');
      
      Get.snackbar(
        'Đăng xuất',
        'Đã đăng xuất thành công',
        backgroundColor: const Color(0xFFd63384),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Logout failed: $e');
      error.value = 'Lỗi khi đăng xuất: $e';
      
      Get.snackbar(
        'Lỗi',
        error.value!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== PASSWORD RESET ====================
  
  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      print('Sending password reset email...');
      isLoading.value = true;
      error.value = null;

      await _authService.sendPasswordResetEmail(email);
      
      print('Password reset email sent');
      
      Get.snackbar(
        'Thành công',
        'Email đặt lại mật khẩu đã được gửi!\nVui lòng kiểm tra hộp thư của bạn.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      
      return true;
    } catch (e) {
      print('Password reset email failed: $e');
      error.value = _parseFirebaseError(e.toString());
      
      Get.snackbar(
        'Lỗi',
        error.value!,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  
  
  /// Clear error message
  void clearError() {
    error.value = null;
  }

  /// Parse Firebase error messages to Vietnamese
  String _parseFirebaseError(String error) {
    if (error.contains('user-not-found')) {
      return 'Email không tồn tại trong hệ thống';
    } else if (error.contains('wrong-password')) {
      return 'Mật khẩu không chính xác';
    } else if (error.contains('email-already-in-use')) {
      return 'Email đã được sử dụng';
    } else if (error.contains('weak-password')) {
      return 'Mật khẩu quá yếu, vui lòng chọn mật khẩu mạnh hơn';
    } else if (error.contains('invalid-email')) {
      return 'Email không hợp lệ';
    } else if (error.contains('network-request-failed')) {
      return 'Lỗi kết nối mạng, vui lòng thử lại';
    } else if (error.contains('too-many-requests')) {
      return 'Quá nhiều yêu cầu, vui lòng thử lại sau';
    } else {
      return 'Đã xảy ra lỗi: ${error.split(']').last.trim()}';
    }
  }

  /// Check if user is authenticated
  bool checkAuth() {
    return isLoggedIn;
  }
}