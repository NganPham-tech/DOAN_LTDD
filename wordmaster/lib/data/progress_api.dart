// lib/data/progress_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/user.dart' as models;

class ProgressAPI {
  
  static String get baseUrl {
    
    return 'http://10.0.2.2:8080';
   
  }
  
  static const Duration timeoutDuration = Duration(seconds: 15); 
  static const int maxRetries = 3;

  
  static Future<Map<String, dynamic>> getAllProgressData(int userId) async {
    int retryCount = 0;
    
    while (retryCount < maxRetries) {
      try {
        final url = '$baseUrl/progress/user?userId=$userId';
        print('Calling API (attempt ${retryCount + 1}/$maxRetries): $url');
        
        final response = await http.get(
          Uri.parse(url),
        ).timeout(timeoutDuration);

        print('API Response Status: ${response.statusCode}');
        print('API Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('Parsed JSON data: $data');
          
          final result = data['data'] as Map<String, dynamic>;
          print('Returning data: $result');
          
          return result;
        } else {
          throw Exception('API returned status ${response.statusCode}');
        }
      } catch (e) {
        retryCount++;
        print('Error on attempt $retryCount: $e');
        
        if (retryCount >= maxRetries) {
          print('Max retries reached. Throwing error.');
          throw Exception('Không thể kết nối đến server sau $maxRetries lần thử. Vui lòng kiểm tra kết nối mạng.');
        }
        
        // Đợi trước khi retry
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }
    
    throw Exception('Unexpected error in getAllProgressData');
  }


  static Future<UserProgress> getUserProgress() async {
    final userId = await _getUserId();
    final data = await getAllProgressData(userId);
    final userProgress = data['userProgress'] as Map<String, dynamic>;
    return UserProgress.fromJson(userProgress);
  }

  static Future<List<DailyProgress>> getWeeklyProgress() async {
    final userId = await _getUserId();
    final data = await getAllProgressData(userId);
    final weeklyProgress = data['weeklyProgress'] as List;
    return weeklyProgress.map((item) => DailyProgress.fromJson(item)).toList();
  }

  static Future<List<Activity>> getRecentActivities() async {
    final userId = await _getUserId();
    final data = await getAllProgressData(userId);
    final activities = data['recentActivities'] as List;
    return activities.map((item) => Activity.fromJson(item)).toList();
  }

  static Future<List<Achievement>> getAchievements() async {
    final userId = await _getUserId();
    final data = await getAllProgressData(userId);
    final achievements = data['achievements'] as List;
    return achievements.map((item) => Achievement.fromJson(item)).toList();
  }


  static Future<int> _getUserId() async {
    try {
      final authController = Get.find<AuthController>();
      
      if (!authController.isLoggedIn) {
        throw Exception('User chưa đăng nhập');
      }
      
      
      final user = authController.currentUser.value as models.User?;
      if (user == null || user.userID == null) {
        throw Exception('Không thể lấy thông tin user');
      }
      
      final userId = user.userID!;
      print('Retrieved userId from auth: $userId');
      return userId;
    } catch (e) {
      print('Error getting userId: $e');
    
      print('Using fallback userId = 2');
      return 2;
    }
  }
}

// Models
class UserProgress {
  final int totalLearned;
  final int totalMastered;
  final int currentStreak;
  final int bestStreak;
  final int totalPoints;
  final int level;
  final int perfectQuizCount;
  final int memoryRate;
  final int totalQuizzes;

  UserProgress({
    required this.totalLearned,
    required this.totalMastered,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalPoints,
    required this.level,
    required this.perfectQuizCount,
    required this.memoryRate,
    required this.totalQuizzes,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      totalLearned: json['totalLearned'] as int,
      totalMastered: json['totalMastered'] as int,
      currentStreak: json['currentStreak'] as int,
      bestStreak: json['bestStreak'] as int,
      totalPoints: json['totalPoints'] as int,
      level: json['level'] as int,
      perfectQuizCount: json['perfectQuizCount'] as int,
      memoryRate: json['memoryRate'] as int,
      totalQuizzes: json['totalQuizzes'] as int,
    );
  }
}

class DailyProgress {
  final DateTime date;
  final int cardsLearned;
  final int quizzesCompleted;

  DailyProgress({
    required this.date,
    required this.cardsLearned,
    required this.quizzesCompleted,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      date: DateTime.parse(json['date']),
      cardsLearned: json['cardsLearned'] as int,
      quizzesCompleted: json['quizzesCompleted'] as int,
    );
  }
}

class Activity {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String timeAgo;

  Activity({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.timeAgo,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: _getIconFromString(json['icon'] as String),
      color: _getColorFromHex(json['color'] as String),
      timeAgo: json['timeAgo'] as String,
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'school': return Icons.school;
      case 'refresh': return Icons.refresh;
      case 'quiz': return Icons.quiz;
      case 'check_circle': return Icons.check_circle;
      default: return Icons.circle;
    }
  }

  static Color _getColorFromHex(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
}

class Achievement {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int points;
  final bool isUnlocked;
  final int progress;
  final int requirementValue;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.points,
    required this.isUnlocked,
    required this.progress,
    required this.requirementValue,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: _getIconFromString(json['icon'] as String),
      color: _getColorFromHex(json['color'] as String),
      points: json['points'] as int,
      isUnlocked: json['isUnlocked'] as bool,
      progress: json['progress'] as int,
      requirementValue: json['requirementValue'] as int,
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'school': return Icons.school;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'quiz': return Icons.quiz;
      case 'grade': return Icons.grade;
      case 'star': return Icons.star;
      default: return Icons.circle;
    }
  }

  static Color _getColorFromHex(String hex) {
    return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
}