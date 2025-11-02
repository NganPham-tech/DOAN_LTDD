// lib/controllers/quiz_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/quiz_api.dart';
import '../models/quiz_topic.dart';

class QuizController extends GetxController {
  var topics = <QuizTopic>[].obs;
  var currentQuestions = <QuizQuestion>[].obs;
  var userAnswers = <int>[].obs;
  var currentTopic = Rxn<QuizTopic>();
  var currentQuestionIndex = 0.obs;
  var isLoading = false.obs;
  var error = RxnString();
  DateTime? quizStartTime;

  @override
  void onInit() {
    super.onInit();
    print('QuizController onInit() called');
    loadQuizTopics();
  }

  // Getters
  bool get isQuizActive => currentTopic.value != null && currentQuestions.isNotEmpty;
  
  QuizQuestion? get currentQuestion => 
      currentQuestions.isNotEmpty && currentQuestionIndex.value < currentQuestions.length
      ? currentQuestions[currentQuestionIndex.value]
      : null;

  // Load quiz topics from MySQL via API
  Future<void> loadQuizTopics() async {
    print('loadQuizTopics() called');
    isLoading(true);
    try {
      print('Calling QuizAPI.getTopics()');
      final topicsList = await QuizAPI.getTopics();
      print('Received ${topicsList.length} topics');
      topics.assignAll(topicsList);
      error.value = null;
    } catch (e) {
      print('Error loading topics: $e');
      error.value = 'Failed to load quiz topics: $e';
      Get.snackbar('Error', 'Failed to load quiz topics', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
      print('loadQuizTopics() completed, isLoading: ${isLoading.value}');
    }
  }

  // Start a quiz with selected topic
  Future<void> startQuiz(QuizTopic topic) async {
    isLoading(true);
    try {
      currentTopic.value = topic;
      currentQuestionIndex.value = 0;
      userAnswers.clear();
      quizStartTime = DateTime.now();

      // Lấy câu hỏi từ MySQL API
      final questions = await QuizAPI.getQuestions(topic.id);
      currentQuestions.assignAll(questions);
      error.value = null;
    } catch (e) {
      error.value = 'Failed to start quiz: $e';
      Get.snackbar('Error', 'Failed to start quiz', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Answer current question
  void answerQuestion(int answerIndex) {
    if (currentQuestionIndex.value < userAnswers.length) {
      userAnswers[currentQuestionIndex.value] = answerIndex;
    } else {
      userAnswers.add(answerIndex);
    }
  }

  // Go to next question
  bool nextQuestion() {
    if (currentQuestionIndex.value < currentQuestions.length - 1) {
      currentQuestionIndex.value++;
      return true;
    }
    return false;
  }

  // Go to previous question
  bool previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      return true;
    }
    return false;
  }

  // Calculate and get quiz results
  QuizResult getQuizResult() {
    if (currentTopic.value == null || quizStartTime == null) {
      throw Exception('No active quiz to calculate results');
    }

    int correctAnswers = 0;
    for (int i = 0; i < currentQuestions.length; i++) {
      if (i < userAnswers.length && userAnswers[i] == currentQuestions[i].correctAnswerIndex) {
        correctAnswers++;
      }
    }

    int totalQuestions = currentQuestions.length;
    int wrongAnswers = totalQuestions - correctAnswers;
    double percentage = (correctAnswers / totalQuestions) * 100;
    int score = (percentage * 10).round(); // Score out of 1000

    return QuizResult(
      topicId: currentTopic.value!.id,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      timeTaken: DateTime.now().difference(quizStartTime!),
      completedAt: DateTime.now(),
      percentage: percentage,
    );
  }

  // End current quiz
  void endQuiz() {
    currentTopic.value = null;
    currentQuestions.clear();
    userAnswers.clear();
    currentQuestionIndex.value = 0;
    quizStartTime = null;
  }

  // Get difficulty color
  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get difficulty icon
  IconData getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.star_outline;
      case 'medium':
        return Icons.star_half;
      case 'hard':
        return Icons.star;
      default:
        return Icons.help_outline;
    }
  }
}