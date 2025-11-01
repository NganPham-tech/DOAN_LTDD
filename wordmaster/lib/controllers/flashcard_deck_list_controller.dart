// lib/controllers/flashcard_deck_list_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/flashcard_api.dart';
import '../models/category.dart';
import '../models/deck.dart';
class FlashcardDeckListController extends GetxController {
  final Category category;
  
  var isLoading = true.obs;
  var decks = <Deck>[].obs;

  FlashcardDeckListController(this.category);

  @override
  void onInit() {
    super.onInit();
    loadDecks();
  }

  Future<void> loadDecks() async {
    try {
      isLoading(true);
      final deckList = await FlashcardAPI.getDecksByCategory(category.id);
      decks.assignAll(deckList);
    } catch (e) {
      print('Error loading decks: $e');
      Get.snackbar('Lỗi', 'Không thể tải danh sách deck');
    } finally {
      isLoading(false);
    }
  }

  Widget buildProgressIndicator(double progress) {
    return Expanded(
      flex: 2,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(
          progress > 0.7 ? Colors.green : Colors.blueAccent,
        ),
        minHeight: 6,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}