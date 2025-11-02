// lib/controllers/flashcard_overview_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/flashcard_api.dart';
import '../models/category.dart';
class FlashcardOverviewController extends GetxController 
    with SingleGetTickerProviderMixin {
  
  var isLoading = true.obs;
  var vocabCategories = <Category>[].obs;
  var grammarCategories = <Category>[].obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading(true);
      
      final vocabCats = await FlashcardAPI.getCategories(type: 'vocabulary');
      final grammarCats = await FlashcardAPI.getCategories(type: 'grammar');
      
      vocabCategories.assignAll(vocabCats);
      grammarCategories.assignAll(grammarCats);
      
    } catch (e) {
      print('Error loading categories: $e');
      Get.snackbar('Lỗi', 'Không thể tải danh sách chủ đề');
    } finally {
      isLoading(false);
    }
  }

  Color parseColor(String colorCode) {
    try {
      return Color(int.parse(colorCode.substring(1, 7), radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}