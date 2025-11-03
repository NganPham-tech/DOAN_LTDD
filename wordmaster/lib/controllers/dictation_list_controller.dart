// lib/controllers/dictation_list_controller.dart
import 'package:get/get.dart';
import '../services/dictation_service.dart';
import '../models/dictation.dart';
import 'package:flutter/material.dart';
class DictationListController extends GetxController 
    with SingleGetTickerProviderMixin {
  
  var isLoading = true.obs;
  var allLessons = <DictationLesson>[].obs;
  late TabController tabController;

  DictationListController() {
    print('DictationListController: Constructor called');
  }

  @override
  void onInit() {
    super.onInit();
    print('DictationListController: onInit called');
    tabController = TabController(length: 4, vsync: this);
    
   
    Future.delayed(const Duration(milliseconds: 100), () {
      loadLessons();
    });
  }

  @override
  void onReady() {
    super.onReady();
    print('DictationListController: onReady called');
    
   
    if (allLessons.isEmpty && !isLoading.value) {
      print('DictationListController: onReady backup load');
      loadLessons();
    }
  }

  void forceLoad() {
    print('DictationListController: forceLoad called');
    loadLessons();
  }

  Future<void> loadLessons() async {
    try {
      isLoading(true);
      print('DictationListController: Bắt đầu tải lessons...');
      
      final lessons = await DictationService.getAllLessons();
      print('DictationListController: Tải được ${lessons.length} lessons');
      
      allLessons.assignAll(lessons);
      
      
      if (lessons.isNotEmpty) {
        print('First lesson: ${lessons.first.title}');
      }
      
    } catch (e) {
      print('DictationListController error: $e');
      
      
      final sampleLessons = _createSampleLessons();
      allLessons.assignAll(sampleLessons);
      print('Sử dụng sample data: ${sampleLessons.length} lessons');
      
      Get.snackbar(
        'Lỗi',
        'Không thể tải từ server, sử dụng dữ liệu mẫu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  List<DictationLesson> _createSampleLessons() {
    return [
      DictationLesson(
        id: 1,
        title: 'Daily Conversation - Basic',
        description: 'Basic daily conversation phrases for beginners',
        level: DictationLevel.beginner,
        thumbnailPath: 'images/timo.jpg',
        durationSeconds: 60,
        fullTranscript: 'Hello, how are you today? I am fine, thank you.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'Hello, how are you today?',
            startTimeMs: 0,
            endTimeMs: 3000,
          ),
          DictationSegment(
            index: 1,
            text: 'I am fine, thank you.',
            startTimeMs: 3000,
            endTimeMs: 6000,
          ),
        ],
      ),
      DictationLesson(
        id: 2,
        title: 'Business Meeting - Intermediate',
        description: 'Common business meeting vocabulary',
        level: DictationLevel.intermediate,
        thumbnailPath: 'images/timo.jpg',
        durationSeconds: 90,
        fullTranscript: 'Let us discuss the quarterly report and sales figures.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'Let us discuss the quarterly report.',
            startTimeMs: 0,
            endTimeMs: 4000,
          ),
        ],
      ),
      DictationLesson(
        id: 3,
        title: 'Academic Lecture - Advanced',
        description: 'Complex academic vocabulary and expressions',
        level: DictationLevel.advanced,
        thumbnailPath: 'images/timo.jpg',
        durationSeconds: 120,
        fullTranscript: 'The paradigm shift in contemporary educational methodologies requires comprehensive analysis.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'The paradigm shift in contemporary educational methodologies requires comprehensive analysis.',
            startTimeMs: 0,
            endTimeMs: 8000,
          ),
        ],
      ),
    ];
  }

  List<DictationLesson> getLessonsByTab(int tabIndex) {
    if (tabIndex == 0) return allLessons; // Tất cả
    
    final level = tabIndex == 1 
        ? DictationLevel.beginner 
        : tabIndex == 2 
            ? DictationLevel.intermediate 
            : DictationLevel.advanced;
            
    return allLessons.where((lesson) => lesson.level == level).toList();
  }

  Color getLevelColor(DictationLevel level) {
    switch (level) {
      case DictationLevel.beginner:
        return Colors.green;
      case DictationLevel.intermediate:
        return Colors.orange;
      case DictationLevel.advanced:
        return Colors.red;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}