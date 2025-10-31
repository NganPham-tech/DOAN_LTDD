import 'package:get/get.dart';
import '../data/progress_api.dart';

class ProgressController extends GetxController {
  var userProgress = Rx<UserProgress?>(null);
  var weeklyProgress = <DailyProgress>[].obs;
  var recentActivities = <Activity>[].obs;
  var achievements = <Achievement>[].obs;
  var isLoading = true.obs;
  var error = RxString('');

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading(true);
      error('');
      final progress = await ProgressAPI.getUserProgress();
      final weekly = await ProgressAPI.getWeeklyProgress();
      final activities = await ProgressAPI.getRecentActivities();
      final achievementsList = await ProgressAPI.getAchievements();

      userProgress(progress);
      weeklyProgress(weekly);
      recentActivities(activities);
      achievements(achievementsList);
    } catch (e) {
      print('Error loading progress data: $e');
      error('Không thể tải dữ liệu tiến độ');
    } finally {
      isLoading(false);
    }
  }
}