// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
// wordmaster/lib/screens/auth/login_screen.dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  var _isPasswordVisible = false.obs;
  var _rememberMe = false.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = Get.find<AuthController>();
    
    final success = await authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Navigation is handled by AuthWrapper listening to auth state
    // No need to manually navigate
    if (success) {
      print('Login successful, AuthWrapper will handle navigation');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFd63384).withOpacity(0.1),
              const Color(0xFFae3ec9).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Logo Section
                          _buildLogoSection(),
                          
                          const SizedBox(height: 24),
                          
                          // Login Form
                          _buildLoginForm(authController),
                          
                          const SizedBox(height: 16),
                          
                          // Register Link
                          _buildRegisterLink(),
                          
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFd63384), Color(0xFFae3ec9)],
              ),
            ),
            child: const Icon(
              Icons.school,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'WordMaster',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFd63384),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Học tiếng Anh thông minh',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AuthController authController) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Email Field
              _buildEmailField(),
              
              const SizedBox(height: 14),
              
              // Password Field
              _buildPasswordField(),
              
              const SizedBox(height: 12),
              
              // Remember Me & Forgot Password
              _buildRememberAndForgot(),
              
              const SizedBox(height: 20),
              
              // Login Button
              _buildLoginButton(authController),
              
              const SizedBox(height: 16),
              
              // Social Login Divider
              _buildSocialDivider(),
              
              const SizedBox(height: 16),
              
              // Social Login Buttons
              _buildSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Địa chỉ email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFd63384),
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập email';
        }
        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
          return 'Email không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible.value,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible.value
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () {
            _isPasswordVisible.value = !_isPasswordVisible.value;
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFd63384),
            width: 2,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        return null;
      },
    ));
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Row(
          children: [
            Checkbox(
              value: _rememberMe.value,
              onChanged: (value) {
                _rememberMe.value = value ?? false;
              },
              activeColor: const Color(0xFFd63384),
            ),
            const Text('Ghi nhớ đăng nhập'),
          ],
        )),
        TextButton(
          onPressed: () {
            Get.to(() => const ForgotPasswordScreen());
          },
          child: const Text(
            'Quên mật khẩu?',
            style: TextStyle(color: Color(0xFFd63384)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthController authController) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: authController.isLoading.value ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFd63384),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: authController.isLoading.value
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    ));
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Hoặc đăng nhập bằng',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Thông báo',
                'Tính năng đăng nhập Google đang phát triển',
                backgroundColor: const Color(0xFFd63384),
                colorText: Colors.white,
              );
            },
            icon: Icon(Icons.g_mobiledata, color: Colors.red[600]),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.red[600]!),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Thông báo',
                'Tính năng đăng nhập Facebook đang phát triển',
                backgroundColor: const Color(0xFFd63384),
                colorText: Colors.white,
              );
            },
            icon: Icon(Icons.facebook, color: Colors.blue[600]),
            label: const Text('Facebook'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.blue[600]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Chưa có tài khoản? '),
          TextButton(
            onPressed: () {
              Get.to(() => const RegisterScreen());
            },
            child: const Text(
              'Đăng ký ngay',
              style: TextStyle(
                color: Color(0xFFd63384),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}