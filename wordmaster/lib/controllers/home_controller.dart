// lib/controllers/home_controller.dart
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';
import '../screens/flashcard/flashcard_overview_screen.dart';
import '../screens/dictation/dictation_list_screen.dart';
class HomeController extends GetxController {
  var isLoading = true.obs;
  var userProgress = <String, dynamic>{}.obs;
  var recommendedDecks = <Map<String, dynamic>>[].obs;
  var recentActivities = <Map<String, dynamic>>[].obs;
  var statistics = <String, dynamic>{}.obs;
  var todayFlashcard = <String, dynamic>{}.obs;

  final quickActions = <Map<String, dynamic>>[
    {'icon': Icons.flash_on, 'label': 'Flashcard', 'badge': 0},
    {'icon': Icons.repeat, 'label': 'Ôn tập', 'badge': 5},
    {'icon': Icons.quiz, 'label': 'Quiz', 'badge': 0},
    {'icon': Icons.mic, 'label': 'Dictation', 'badge': 0},
    {'icon': Icons.record_voice_over, 'label': 'Shadowing', 'badge': 0},
    {'icon': Icons.menu_book, 'label': 'Grammar', 'badge': 2},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading(true);
      
      // Giả lập firebaseUid - bạn có thể thay bằng Get.find<UserProvider>().currentUser?.id
      final firebaseUid = 'user123'; 
      
      final data = await ApiService.get('/users/home?firebaseUid=$firebaseUid');
      
      print('Home API response: Success');

      if (data['success'] == true) {
        userProgress(Map<String, dynamic>.from(data['data']['userProgress'] ?? {}));
        recommendedDecks(List<Map<String, dynamic>>.from(data['data']['recommendedDecks'] ?? []));
        recentActivities(List<Map<String, dynamic>>.from(data['data']['recentActivities'] ?? []));
        statistics(Map<String, dynamic>.from(data['data']['statistics'] ?? {}));
        todayFlashcard(Map<String, dynamic>.from(data['data']['todayFlashcard'] ?? {}));
        
        // Cập nhật badge cho quick actions
        final cardsToReview = statistics['cardsToReview'] ?? 0;
        quickActions[1]['badge'] = cardsToReview;
        quickActions.refresh();
        
        print('Home data loaded successfully');
      }
    } catch (e) {
      print('Error loading home data: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu trang chủ',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void handleFeatureNavigation(String feature) {
    switch (feature) {
      case 'Flashcard':
      case 'Ôn tập':
        Get.to(() => FlashcardOverviewScreen());
        break;
      case 'Dictation':
        Get.to(() => DictationListScreen());
        break;
      default:
        Get.snackbar(
          'Thông báo',
          'Tính năng $feature đang phát triển',
          backgroundColor: Color(0xFFd63384),
          colorText: Colors.white,
        );
    }
  }
}