// lib/controllers/progress_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/progress_api.dart';
//D:\DEMOLTDD\wordmaster\lib\controllers\progress_controller.dart
class ProgressController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = RxnString();
  
  var userProgress = Rxn<UserProgress>();
  var weeklyProgress = <DailyProgress>[].obs;
  var recentActivities = <Activity>[].obs;
  var achievements = <Achievement>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('ProgressController onInit() called');
    loadData();
  }

  Future<void> loadData() async {
    try {
      print('ProgressController loadData() called');
      isLoading(true);
      errorMessage(null);
      
      print('Loading progress data...');

      final progress = await ProgressAPI.getUserProgress();
      final weekly = await ProgressAPI.getWeeklyProgress();
      final activities = await ProgressAPI.getRecentActivities();
      final achievementsData = await ProgressAPI.getAchievements();
      
      print('UserProgress loaded: ${progress.totalLearned} learned, ${progress.totalQuizzes} quizzes');
      print('WeeklyProgress loaded: ${weekly.length} days');
      for (var day in weekly) {
        print('  ${day.date}: ${day.cardsLearned} cards, ${day.quizzesCompleted} quizzes');
      }
      print('Activities loaded: ${activities.length} items');
      print('Achievements loaded: ${achievementsData.length} items');
      
      
      final cardValues = weekly.map((e) => e.cardsLearned).toList();
      final quizValues = weekly.map((e) => e.quizzesCompleted).toList();
      print('Cards learned values: $cardValues');
      print('Quiz completed values: $quizValues');
      
      userProgress(progress);
      weeklyProgress.assignAll(weekly);
      recentActivities.assignAll(activities);
      achievements.assignAll(achievementsData);
      
    } catch (e) {
      print('Error loading progress data: $e');
      String userFriendlyMessage = 'Không thể tải dữ liệu tiến độ';
      
      
      if (e.toString().contains('kết nối')) {
        userFriendlyMessage = 'Lỗi kết nối mạng. Vui lòng thử lại.';
      } else if (e.toString().contains('User chưa đăng nhập')) {
        userFriendlyMessage = 'Vui lòng đăng nhập để xem tiến độ';
      }
      
      errorMessage(userFriendlyMessage);
    } finally {
      isLoading(false);
    }
  }

  // Thêm method để retry load data
  Future<void> retryLoadData() async {
    print('Retrying to load progress data...');
    await loadData();
  }

  // Helper methods để lấy dữ liệu cho chart
  BarChartData get barChartData {
    print('Building chart data with ${weeklyProgress.length} data points');
    
    // Debug: In ra tất cả data points
    for (int i = 0; i < weeklyProgress.length; i++) {
      final day = weeklyProgress[i];
      print('Day $i: ${day.date} - ${day.cardsLearned} cards, ${day.quizzesCompleted} quizzes');
    }
    
    if (weeklyProgress.isEmpty) {
      print('weeklyProgress is empty!');
      return BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barGroups: [],
      );
    }
    
    final allValues = weeklyProgress.map((e) => e.cardsLearned.toDouble()).toList();
    print('All cardsLearned values: $allValues');
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    final maxY = maxValue + 5;
    print('Max value: $maxValue, Chart maxY: $maxY');
    
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final day = weeklyProgress[groupIndex];
            return BarTooltipItem(
              '${day.cardsLearned} thẻ\n${day.quizzesCompleted} quiz',
              const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final date = weeklyProgress[value.toInt()].date;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${date.day}/${date.month}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: weeklyProgress.asMap().entries.map((entry) {
        final index = entry.key;
        final day = entry.value;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: day.cardsLearned.toDouble(),
              color: Colors.blueAccent,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList(),
    );
  }
}