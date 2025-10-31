// lib/controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../providers/simple_firebase_user_provider.dart';
import '../services/api_service.dart';
import '../providers/locale_provider.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var userProgress = <String, dynamic>{}.obs;
  var recommendedDecks = <Map<String, dynamic>>[].obs;
  var recentActivities = <Map<String, dynamic>>[].obs;
  var statistics = <String, dynamic>{}.obs;
  var todayFlashcard = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      
      final userProvider = Get.find<SimpleFirebaseUserProvider>();
      final localeProvider = Get.find<LocaleProvider>();

      if (!userProvider.isLoggedIn) {
        isLoading.value = false;
        return;
      }

      final firebaseUid = userProvider.currentUser?.id;
      final locale = localeProvider.locale.languageCode;

      final data = await ApiService.get(
        '/users/home?firebaseUid=$firebaseUid&locale=$locale'
      );

      if (data['success'] == true) {
        userProgress.value = Map<String, dynamic>.from(data['data']['userProgress'] ?? {});
        recommendedDecks.value = List<Map<String, dynamic>>.from(data['data']['recommendedDecks'] ?? []);
        recentActivities.value = List<Map<String, dynamic>>.from(data['data']['recentActivities'] ?? []);
        statistics.value = Map<String, dynamic>.from(data['data']['statistics'] ?? {});
        todayFlashcard.value = Map<String, dynamic>.from(data['data']['todayFlashcard'] ?? {});
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}