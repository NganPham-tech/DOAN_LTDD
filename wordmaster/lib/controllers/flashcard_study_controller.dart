// lib/controllers/flashcard_study_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/flashcard_api.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../services/tts_service.dart';

class FlashcardStudyController extends GetxController 
    with SingleGetTickerProviderMixin {
  
  final Deck deck;
  
  var flashcards = <Flashcard>[].obs;
  var currentIndex = 0.obs;
  var isLoading = true.obs;
  var progress = 0.0.obs;
  var isFront = true.obs;
  late AnimationController flipController;

  FlashcardStudyController(this.deck);

  @override
  void onInit() {
    super.onInit();
    print('FlashcardStudyController: onInit called');
    
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Initialize TTS
    _initializeTTS();
    
    loadFlashcards();
  }

  Future<void> _initializeTTS() async {
    try {
      print('FlashcardStudyController: Initializing TTS...');
      await TtsService.initialize();
      print('FlashcardStudyController: TTS initialized successfully');
    } catch (e) {
      print('FlashcardStudyController: TTS initialization failed: $e');
    }
  }

  Future<void> loadFlashcards() async {
    try {
      isLoading(true);
      final cards = await FlashcardAPI.getFlashcardsByDeck(deck.id);
      flashcards.assignAll(cards);
      updateProgress();
      
      // Tự động phát âm thẻ đầu tiên nếu là vocabulary
      if (flashcards.isNotEmpty && isVocabulary) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          speakText();
        });
      }
    } catch (e) {
      print('Error loading flashcards: $e');
      Get.snackbar('Lỗi', 'Không thể tải flashcard');
    } finally {
      isLoading(false);
    }
  }

  void updateProgress() {
    progress.value = currentIndex.value / flashcards.length;
  }

  void nextCard() {
    if (currentIndex.value < flashcards.length - 1) {
      currentIndex.value++;
      isFront.value = true;
      flipController.reset();
      updateProgress();
      
      // Tự động phát âm từ mới nếu là vocabulary
      if (isVocabulary) {
        Future.delayed(const Duration(milliseconds: 500), () {
          speakText();
        });
      }
    } else {
      showCompletionDialog();
    }
  }

  void previousCard() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      isFront.value = true;
      flipController.reset();
      updateProgress();
      
      // Tự động phát âm từ nếu là vocabulary
      if (isVocabulary) {
        Future.delayed(const Duration(milliseconds: 500), () {
          speakText();
        });
      }
    }
  }

  void flipCard() {
    if (isFront.value) {
      flipController.forward();
    } else {
      flipController.reverse();
    }
    isFront.value = !isFront.value;
  }

  void markAsRemembered() {
    // TODO: Implement API call to update learning progress
    // final card = flashcards[currentIndex.value];
    // FlashcardAPI.updateLearningProgress(LearningUpdate(
    //   userId: 1,
    //   flashcardId: card.id,
    //   status: 'Mastered',
    //   remembered: true,
    // ));
    nextCard();
  }

  void markForReview() {
    // TODO: Implement API call to update learning progress
    // final card = flashcards[currentIndex.value];
    // FlashcardAPI.updateLearningProgress(LearningUpdate(
    //   userId: 1,
    //   flashcardId: card.id,
    //   status: 'Learning',
    //   remembered: false,
    // ));
    nextCard();
  }

  void speakText() {
    print('FlashcardStudyController: speakText() called');
    print('hasCards: ${hasCards}');
    print('isVocabulary: ${isVocabulary}');
    
    if (!hasCards) {
      print('No cards available');
      return;
    }
    
    final word = flashcards[currentIndex.value].question;
    print('Speaking word: "$word"');
    print('TTS initialized: ${TtsService.isInitialized}');
    
    // Speak regardless of vocabulary type for testing
    TtsService.speak(word);
  }

  void showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Chúc mừng!'),
        content: const Text('Bạn đã hoàn thành deck này.'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Navigate back
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool get isVocabulary => 
      hasCards && flashcards[currentIndex.value].type == 'vocabulary';

  Flashcard get currentCard => flashcards[currentIndex.value];
  
  bool get hasCards => flashcards.isNotEmpty && currentIndex.value < flashcards.length;

  @override
  void onClose() {
    flipController.dispose();
    TtsService.stop();
    super.onClose();
  }
}