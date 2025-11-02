import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordmaster/models/quiz_topic.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';
import '../screens/flashcard/flashcard_overview_screen.dart';
import '../screens/dictation/dictation_list_screen.dart';
import '../screens/quiz/quiz_topics_screen.dart';
class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  
  var isLoading = true.obs;
  var userProgress = <String, dynamic>{}.obs;
  var recommendedDecks = <Map<String, dynamic>>[].obs;
  var recentActivities = <Map<String, dynamic>>[].obs;
  var statistics = <String, dynamic>{}.obs;
  var todayFlashcard = <String, dynamic>{}.obs;

  final List<Map<String, dynamic>> quickActions = [
    {'icon': Icons.flash_on, 'label': 'Flashcard', 'badge': 0},
    {'icon': Icons.quiz, 'label': 'Quiz', 'badge': 0},
    {'icon': Icons.mic, 'label': 'Dictation', 'badge': 0},
    {'icon': Icons.menu_book, 'label': 'Grammar', 'badge': 2},
  ];

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading(true);
      
      if (!authController.isLoggedIn) {
        isLoading(false);
        return;
      }

      final firebaseUid = authController.firebaseUid;
      
    
      final data = await ApiService.get('/users/home?firebaseUid=$firebaseUid');
      
      print('Home API response: Success');

      if (data['success'] == true) {
        userProgress.assignAll(Map<String, dynamic>.from(
          data['data']['userProgress'] ?? {}
        ));
        recommendedDecks.assignAll(List<Map<String, dynamic>>.from(
          data['data']['recommendedDecks'] ?? []
        ));
        recentActivities.assignAll(List<Map<String, dynamic>>.from(
          data['data']['recentActivities'] ?? []
        ));
        statistics.assignAll(Map<String, dynamic>.from(
          data['data']['statistics'] ?? {}
        ));
        todayFlashcard.assignAll(Map<String, dynamic>.from(
          data['data']['todayFlashcard'] ?? {}
        ));
        
        print('Home data loaded successfully');
      }
    } catch (e) {
      print('Error loading home data: $e');
    } finally {
      isLoading(false);
    }
  }

  void handleFeatureNavigation(String feature) {
    switch (feature) {
      case 'Flashcard':
        Get.to(() => const FlashcardOverviewScreen());
        break;
      case 'Dictation':
        Get.to(() => const DictationListScreen());
        break;
      case 'Quiz':
        Get.to(() => const QuizTopicsScreen());
      default:
        Get.snackbar(
          'Thông báo',
          'Tính năng $feature đang phát triển',
          backgroundColor: const Color(0xFFd63384),
          colorText: Colors.white,
        );
    }
  }


  void updateQuickActionsBadge() {
   
    if (quickActions.length > 3) {
      quickActions[3]['badge'] = statistics['grammarExercises'] ?? 2;
    }
  }
}