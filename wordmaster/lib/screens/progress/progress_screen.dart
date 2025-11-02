// lib/screens/progress/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../controllers/progress_controller.dart';
import '../../../controllers/auth_controller.dart'; // Thêm import AuthController
import '../../data/progress_api.dart' as api;
import '../../../controllers/main_navigation_controller.dart';
import '../auth/register_screen.dart'; // Sửa đường dẫn import
//D:\DEMOLTDD\wordmaster\lib\screens\progress\progress_screen.dart
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressController = Get.put(ProgressController());
    final authController = Get.find<AuthController>(); // Lấy AuthController
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() {
          // Kiểm tra nếu chưa đăng nhập
          if (!authController.isLoggedIn) {
            return _buildLoginRequiredWidget(authController);
          }
          
          if (progressController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (progressController.errorMessage.value != null) {
            return _buildErrorWidget(progressController);
          }
          
          if (progressController.userProgress.value == null) {
            return const Center(child: Text('Không có dữ liệu'));
          }
          
          return _buildContent(progressController);
        }),
      ),
    );
  }

  // Widget hiển thị khi chưa đăng nhập
  Widget _buildLoginRequiredWidget(AuthController authController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon lớn
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.analytics_outlined,
                size: 60,
                color: Colors.blueAccent,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tiêu đề
            const Text(
              'Thống kê học tập',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Mô tả
            Text(
              'Đăng nhập để xem thống kê chi tiết về quá trình học tập của bạn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Các tính năng khi đăng nhập
            _buildFeatureList(),
            
            const SizedBox(height: 40),
            
            // Nút đăng nhập
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Chuyển đến tab Profile (tab cuối cùng - index 4)
                  Get.until((route) => route.isFirst); // Quay về màn hình chính
                  Future.delayed(const Duration(milliseconds: 100), () {
                    // Sử dụng GetX để chuyển tab
                    final mainNavigation = Get.find<MainNavigationController>();
                    mainNavigation.changeTab(4); // Chuyển đến tab Profile
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFd63384),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Đăng nhập ngay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Nút đăng ký
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Chuyển đến tab Profile và mở màn hình đăng ký
                  Get.until((route) => route.isFirst);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    final mainNavigation = Get.find<MainNavigationController>();
                    mainNavigation.changeTab(4); // Chuyển đến tab Profile
                    // Giả sử ProfileScreen có thể điều hướng đến RegisterScreen
                    Get.to(() => const RegisterScreen());
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFd63384),
                  side: const BorderSide(color: Color(0xFFd63384), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Danh sách tính năng khi đăng nhập
  Widget _buildFeatureList() {
    final features = [
      {
        'icon': Icons.timeline,
        'title': 'Theo dõi tiến độ',
        'description': 'Xem biểu đồ học tập 7 ngày qua'
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Thành tích',
        'description': 'Mở khóa huy hiệu và phần thưởng'
      },
      {
        'icon': Icons.local_fire_department,
        'title': 'Streak học tập',
        'description': 'Duy trì chuỗi ngày học liên tiếp'
      },
      {
        'icon': Icons.insights,
        'title': 'Thống kê chi tiết',
        'description': 'Phân tích hiệu quả học tập'
      },
    ];

    return Column(
      children: features.map((feature) => _buildFeatureItem(
        icon: feature['icon'] as IconData,
        title: feature['title'] as String,
        description: feature['description'] as String,
      )).toList(),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ProgressController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value!,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.loadData(),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProgressController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.loadData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller),
            const SizedBox(height: 20),
            _buildSummaryCards(controller),
            const SizedBox(height: 24),
            _buildProgressChart(controller),
            const SizedBox(height: 24),
            _buildRecentActivities(controller),
            const SizedBox(height: 24),
            _buildAchievements(controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ProgressController controller) {
    return Row(
      children: [
        const Icon(Icons.analytics, size: 28, color: Colors.blueAccent),
        const SizedBox(width: 12),
        const Text(
          'Tiến độ học tập',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                'Cấp ${controller.userProgress.value?.level ?? 0}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(ProgressController controller) {
    final progress = controller.userProgress.value!;
    
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      children: [
        _buildSummaryCard(
          icon: Icons.flash_on,
          title: 'Từ đã học',
          value: progress.totalLearned.toString(),
          subtitle: '${progress.totalMastered} đã thuộc',
          color: Colors.blue,
        ),
        _buildSummaryCard(
          icon: Icons.local_fire_department,
          title: 'Streak',
          value: '${progress.currentStreak} ngày',
          subtitle: 'Cao nhất: ${progress.bestStreak}',
          color: Colors.orange,
        ),
        _buildSummaryCard(
          icon: Icons.psychology,
          title: 'Tỷ lệ nhớ',
          value: '${progress.memoryRate}%',
          subtitle: 'Hiệu quả học tập',
          color: Colors.green,
        ),
        _buildSummaryCard(
          icon: Icons.quiz,
          title: 'Bài Quiz',
          value: progress.totalQuizzes.toString(),
          subtitle: '${progress.perfectQuizCount} bài perfect',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(ProgressController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiến độ 7 ngày qua',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              width: double.infinity,
              child: BarChart(controller.barChartData),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 12, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text('Số thẻ học mỗi ngày', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(ProgressController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hoạt động gần đây',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: controller.recentActivities
                  .take(5)
                  .map((activity) => _buildActivityItem(activity))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(api.Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon, size: 20, color: activity.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            activity.timeAgo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(ProgressController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Huy hiệu thành tích',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.achievements.length,
            itemBuilder: (context, index) {
              return _buildAchievementCard(controller.achievements[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(api.Achievement achievement) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: achievement.isUnlocked ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: achievement.isUnlocked ? Colors.white : Colors.grey[100],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  achievement.icon,
                  size: 20,
                  color: achievement.isUnlocked ? achievement.color : Colors.grey,
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      achievement.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: achievement.isUnlocked ? Colors.black87 : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (achievement.isUnlocked) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 10, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            '+${achievement.points}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        'Chưa mở khóa',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
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