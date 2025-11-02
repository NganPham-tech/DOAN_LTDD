// lib/screens/flashcard/flashcard_overview_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/flashcard_overview_controller.dart';
import '../../../models/category.dart';
import 'flashcard_deck_list_screen.dart';

class FlashcardOverviewScreen extends StatelessWidget {
  const FlashcardOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FlashcardOverviewController>(
      init: FlashcardOverviewController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flashcard'),
            backgroundColor: const Color(0xFFd63384),
            foregroundColor: Colors.white,
            bottom: TabBar(
              controller: controller.tabController,
              indicatorColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Từ vựng'),
                Tab(text: 'Ngữ pháp'),
              ],
            ),
          ),
          body: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: controller.tabController,
                  children: [
                    _buildCategoryGrid(controller.vocabCategories, controller),
                    _buildCategoryGrid(controller.grammarCategories, controller),
                  ],
                )),
        );
      },
    );
  }

  Widget _buildCategoryGrid(RxList<Category> categories, FlashcardOverviewController controller) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có chủ đề nào',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(categories[index], controller);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category, FlashcardOverviewController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => FlashcardDeckListScreen(category: category));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: controller.parseColor(category.colorCode).withOpacity(0.1),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.parseColor(category.colorCode).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${category.deckCount} deck',
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.parseColor(category.colorCode),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,  // Default icon
                      size: 32,
                      color: controller.parseColor(category.colorCode),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description ?? 'Không có mô tả',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}