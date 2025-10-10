import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/test_user_provider.dart';
import '../providers/user_provider.dart';

/// Wrapper để detect provider type và sử dụng interface chung
class AuthProviderWrapper {
  static bool isTestMode(BuildContext context) {
    try {
      Provider.of<TestUserProvider>(context, listen: false);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(BuildContext context, String email, String password) {
    if (isTestMode(context)) {
      return Provider.of<TestUserProvider>(context, listen: false)
          .login(email, password);
    } else {
      return Provider.of<UserProvider>(context, listen: false)
          .login(email, password);
    }
  }

  static Future<bool> register(BuildContext context, String fullName, String email, String password) {
    if (isTestMode(context)) {
      return Provider.of<TestUserProvider>(context, listen: false)
          .register(fullName, email, password);
    } else {
      return Provider.of<UserProvider>(context, listen: false)
          .register(fullName, email, password);
    }
  }

  static Future<bool> forgotPassword(BuildContext context, String email) {
    if (isTestMode(context)) {
      return Provider.of<TestUserProvider>(context, listen: false)
          .forgotPassword(email);
    } else {
      // UserProvider doesn't have forgotPassword method, so simulate it
      return Future.value(true);
    }
  }

  static bool isLoading(BuildContext context) {
    if (isTestMode(context)) {
      return Provider.of<TestUserProvider>(context, listen: false).isLoading;
    } else {
      return Provider.of<UserProvider>(context, listen: false).isLoading;
    }
  }

  static String? getError(BuildContext context) {
    if (isTestMode(context)) {
      return Provider.of<TestUserProvider>(context, listen: false).error;
    } else {
      return Provider.of<UserProvider>(context, listen: false).error;
    }
  }
}