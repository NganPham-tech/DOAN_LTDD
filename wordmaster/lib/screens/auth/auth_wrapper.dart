import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'login_screen.dart';
import '../main_navigation.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Get AuthController instance
    final authController = Get.find<AuthController>();

    return Obx(() {
      print('AuthWrapper Obx rebuilding...');
      print('authController.isLoggedIn: ${authController.isLoggedIn}');
      print('currentUser: ${authController.currentUser.value?.email}');
      print('IsLoading: ${authController.isLoading.value}');
      print('error: ${authController.error.value}');
      
      // Show loading spinner while checking authentication state
      if (authController.isLoading.value) {
        print('Showing loading spinner');
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFd63384),
            ),
          ),
        );
      }

      // Show error if there's an authentication error
      if (authController.error.value != null) {
        print('Showing error screen');
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Lỗi xác thực',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    authController.error.value!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    authController.clearError();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFd63384),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        );
      }

      // Always show main app - let individual screens handle login requirements
      print('Showing MainNavigation (guest or logged-in user)');
      return const MainNavigation();
    });
  }
}