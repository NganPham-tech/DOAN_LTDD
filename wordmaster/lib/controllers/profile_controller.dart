// lib/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  var isLoadingApiData = false.obs;
  var errorMessage = RxnString();
  var apiData = <String, dynamic>{}.obs;
  
  // Inject AuthController
  final authController = Get.find<AuthController>();

  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080';
    } else {
      return 'http://localhost:8080';
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Sử dụng WidgetsBinding để đảm bảo context đã sẵn sàng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadApiData();
    });
  }

  Future<void> loadApiData() async {
    try {
      isLoadingApiData(true);
      errorMessage(null);

      // Lấy firebaseUid từ arguments hoặc từ user provider
      final firebaseUid = Get.arguments?['firebaseUid'] ?? _getFirebaseUidFromContext();
      
      if (firebaseUid == null || firebaseUid.isEmpty) {
        errorMessage('Không tìm thấy Firebase UID');
        return;
      }

      print('Loading profile for Firebase UID: $firebaseUid');

      final response = await http.get(
        Uri.parse('$baseUrl/users/profile?firebaseUid=$firebaseUid'),
      ).timeout(const Duration(seconds: 10));

      print('Profile API response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          apiData(data['data']);
          errorMessage(null);
          print('Profile data loaded successfully');
        } else {
          errorMessage(data['message'] ?? 'Lỗi không xác định');
        }
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      errorMessage('Không thể kết nối server');
      print('Socket Error: $e');
    } on TimeoutException catch (e) {
      errorMessage('Timeout khi kết nối');
      print('Timeout Error: $e');
    } catch (e) {
      errorMessage('Lỗi: ${e.toString()}');
      print('Error loading API data: $e');
    } finally {
      isLoadingApiData(false);
    }
  }

  
  String? _getFirebaseUidFromContext() {
    try {
     
      final firebaseUid = authController.firebaseUid;
      print('Getting Firebase UID from AuthController: $firebaseUid');
      return firebaseUid;
    } catch (e) {
      print('Error getting firebaseUid from AuthController: $e');
      return null;
    }
  }

 
  Map<String, dynamic>? get userData => apiData['user'] as Map<String, dynamic>?;
  Map<String, dynamic>? get progressData => apiData['progress'] as Map<String, dynamic>?;
  Map<String, dynamic>? get learningSummaryData => apiData['learningSummary'] as Map<String, dynamic>?;
  List<dynamic>? get achievementsData => apiData['achievements'] as List<dynamic>?;
  List<dynamic>? get recentActivitiesData => apiData['recentActivities'] as List<dynamic>?;

  String getLevelTitle(int level) {
    if (level <= 2) return 'Newbie Explorer';
    if (level <= 5) return 'Word Explorer';
    if (level <= 10) return 'Vocabulary Master';
    if (level <= 20) return 'Language Expert';
    return 'Legend Scholar';
  }
}