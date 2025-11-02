// lib/controllers/dictation_result_controller.dart
import 'package:get/get.dart';
import '../models/dictation.dart';
import '../services/dictation_scoring_service.dart';

class DictationResultController extends GetxController {
  final DictationResult result;
  var showComparison = true.obs;

  DictationResultController(this.result);

  bool get isPassed => DictationScoringService.isPassed(result);
  Map<String, int> get errors => DictationScoringService.analyzeErrors(result);

  void retryLesson() {
    Get.back();
  }

  void goHome() {
    Get.until((route) => route.isFirst);
  }
}