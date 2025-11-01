// lib/controllers/dictation_play_controller.dart
import 'package:get/get.dart';
import '../models/dictation.dart';
import '../services/tts_service.dart';
import '../services/dictation_scoring_service.dart';
import 'package:flutter/material.dart';
import '../screens/dictation/dictation_result_screen.dart';
class DictationPlayController extends GetxController {
  final DictationLesson lesson;
  
  final textController = TextEditingController();
  var isPlaying = false.obs;
  var showTranscript = false.obs;
  var playCount = 0.obs;
  var currentSegmentIndex = 0.obs;
  var isSegmentMode = false.obs;
  var speechRate = 0.5.obs;
  DateTime? startTime;

  DictationPlayController(this.lesson);

  @override
  void onInit() {
    super.onInit();
    print('🚀 DictationPlayController: onInit called');
    _initializeTTS();
    startTime = DateTime.now();
  }

  Future<void> _initializeTTS() async {
    try {
      print('🔊 DictationPlayController: Initializing TTS...');
      await TtsService.initialize();
      await TtsService.setLanguage('en-US');
      await TtsService.setSpeechRate(speechRate.value);
      print('✅ DictationPlayController: TTS initialized successfully');
    } catch (e) {
      print('❌ DictationPlayController: TTS initialization failed: $e');
    }
  }

  Future<void> initializeTTS() async {
    await _initializeTTS();
  }

  Future<void> playFullAudio() async {
    if (isPlaying.value) return;
    
    print('🔊 DictationPlayController: playFullAudio called');
    isPlaying(true);
    playCount.value++;
    
    try {
      // Force apply speech rate trước khi phát
      await TtsService.setSpeechRate(speechRate.value);
      print('🎯 Speaking text: "${lesson.fullTranscript}"');
      
      // Delay nhỏ để đảm bảo setting được apply
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Sử dụng TTS để đọc transcript
      await TtsService.speak(lesson.fullTranscript);
      
    } catch (e) {
      print('❌ DictationPlayController: playFullAudio error: $e');
    } finally {
      isPlaying(false);
    }
  }

  Future<void> playSegment(int index) async {
    print('🔊 DictationPlayController: playSegment($index) called');
    print('📊 isPlaying: ${isPlaying.value}, segments length: ${lesson.segments.length}');
    
    if (isPlaying.value || index >= lesson.segments.length) {
      print('❌ Cannot play segment: isPlaying=${isPlaying.value}, index=$index, max=${lesson.segments.length}');
      return;
    }
    
    isPlaying(true);
    currentSegmentIndex.value = index;
    
    try {
      // Force apply speech rate trước khi phát segment
      await TtsService.setSpeechRate(speechRate.value);
      print('🎯 Playing segment $index: "${lesson.segments[index].text}"');
      
      // Delay nhỏ để đảm bảo setting được apply
      await Future.delayed(const Duration(milliseconds: 100));
      
      final segment = lesson.segments[index];
      await TtsService.speak(segment.text);
      
      print('✅ Segment $index completed');
    } catch (e) {
      print('❌ DictationPlayController: playSegment error: $e');
    } finally {
      isPlaying(false);
    }
  }

  String getSpeedLabel(double rate) {
    if (rate <= 0.4) return 'Rất chậm';
    if (rate <= 0.5) return 'Chậm';
    if (rate <= 0.6) return 'Bình thường';
    if (rate <= 0.8) return 'Nhanh';
    return 'Rất nhanh';
  }

  void submitAnswer() {
    final userInput = textController.text.trim();
    
    if (userInput.isEmpty) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng nhập câu trả lời trước khi nộp bài',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
      );
      return;
    }
    
    // Tính điểm sử dụng DictationScoringService
    final result = DictationScoringService.scoreText(
      lessonId: lesson.id,
      userInput: userInput,
      correctText: lesson.fullTranscript,
      timeSpentSeconds: startTime != null 
          ? DateTime.now().difference(startTime!).inSeconds 
          : 0,
    );
    
    // Chuyển đến màn hình kết quả
    Get.off(() => DictationResultScreen(result: result));
  }

  @override
  void onClose() {
    textController.dispose();
    TtsService.stop();
    super.onClose();
  }
}