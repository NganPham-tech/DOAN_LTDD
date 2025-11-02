// lib/screens/flashcard/flashcard_deck_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flashcard_deck_list_controller.dart';
import '../../../models/category.dart';
import '../../../models/deck.dart';
import 'flashcard_study_screen.dart';

class FlashcardDeckListScreen extends StatelessWidget {
  final Category category;

  const FlashcardDeckListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashcardDeckListController>(
      init: FlashcardDeckListController(category),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(category.name),
          ),
          body: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.decks.isEmpty
                  ? const Center(child: Text('Chưa có deck nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.decks.length,
                      itemBuilder: (context, index) {
                        return _buildDeckCard(controller.decks[index], controller);
                      },
                    )),
        );
      },
    );
  }

  Widget _buildDeckCard(Deck deck, FlashcardDeckListController controller) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'images/timo.jpg',
                width: 80,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Deck Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deck.description ?? 'Không có mô tả',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Progress and Stats
                  Row(
                    children: [
                      controller.buildProgressIndicator(deck.progress),
                      const SizedBox(width: 8),
                      Text(
                        '${deck.learnedCards}/${deck.totalCards}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            deck.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Start Button
            ElevatedButton(
              onPressed: () {
                Get.to(() => FlashcardStudyScreen(deck: deck));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Học'),
            ),
          ],
        ),
      ),
    );
  }
}