// lib/screens/dictation/dictation_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dictation_list_controller.dart';
import '../../models/dictation.dart';
import 'dictation_play_screen.dart';

class DictationListScreen extends StatefulWidget {
  const DictationListScreen({super.key});

  @override
  State<DictationListScreen> createState() => _DictationListScreenState();
}

class _DictationListScreenState extends State<DictationListScreen> {
  late DictationListController controller;

  @override
  void initState() {
    super.initState();
    print('DictationListScreen: initState called');
    controller = Get.put(DictationListController());
    print('DictationListScreen: Controller created in initState');
  }

  @override
  Widget build(BuildContext context) {
    print('DictationListScreen: Building screen...');
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Dictation'),
        backgroundColor: const Color(0xFFd63384),
        foregroundColor: Colors.white,
        actions: [
          // Debug button để test load
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print('🔄 Manual refresh triggered');
              controller.forceLoad();
            },
            tooltip: 'Refresh data',
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Cơ bản'),
            Tab(text: 'Trung cấp'),
            Tab(text: 'Nâng cao'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: List.generate(4, (index) {
          return _buildLessonList(controller, index);
        }),
      ),
    );
  }
  
  Widget _buildLessonList(DictationListController controller, int tabIndex) {
    return Obx(() {
      print('_buildLessonList: isLoading=${controller.isLoading.value}, tabIndex=$tabIndex');
      
      if (controller.isLoading.value) {
        print('Showing loading indicator');
        return const Center(child: CircularProgressIndicator());
      }
      
      final lessons = controller.getLessonsByTab(tabIndex);
      print('Tab $tabIndex has ${lessons.length} lessons');
      
      if (lessons.isEmpty) {
        print('No lessons found for tab $tabIndex');
        return const Center(
          child: Text(
            'Chưa có bài học nào',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }
      
      print('Building ListView with ${lessons.length} lessons');
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          print('Building lesson card ${index}: ${lessons[index].title}');
          return _buildLessonCard(lessons[index], controller);
        },
      );
    });
  }
  
  Widget _buildLessonCard(DictationLesson lesson, DictationListController controller) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => DictationPlayScreen(lesson: lesson));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    'images/timo.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: controller.getLevelColor(lesson.level),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lesson.levelText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.durationSeconds}s',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.text_fields,
                        '${lesson.totalWords} từ',
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.format_list_numbered,
                        '${lesson.segments.length} câu',
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => DictationPlayScreen(lesson: lesson));
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Bắt đầu'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFd63384),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('DictationListScreen: dispose called');
    super.dispose();
  }
}
