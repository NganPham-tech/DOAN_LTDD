import 'package:flutter/material.dart';
import '../models/quiz_topic.dart';

class QuizProvider with ChangeNotifier {
  List<QuizTopic> _topics = [];
  List<QuizQuestion> _currentQuestions = [];
  List<int> _userAnswers = [];
  QuizTopic? _currentTopic;
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _error;
  DateTime? _quizStartTime;

  // Getters
  List<QuizTopic> get topics => _topics;
  List<QuizQuestion> get currentQuestions => _currentQuestions;
  List<int> get userAnswers => _userAnswers;
  QuizTopic? get currentTopic => _currentTopic;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isQuizActive =>
      _currentTopic != null && _currentQuestions.isNotEmpty;
  QuizQuestion? get currentQuestion =>
      _currentQuestions.isNotEmpty &&
          _currentQuestionIndex < _currentQuestions.length
      ? _currentQuestions[_currentQuestionIndex]
      : null;

  // Load quiz topics (sample data)
  Future<void> loadQuizTopics() async {
    _setLoading(true);
    try {
      // Sample quiz topics
      _topics = [
        QuizTopic(
          id: 1,
          name: 'English Grammar',
          description:
              'Test your knowledge of English grammar rules and structures',
          imagePath: 'images/grammar.png',
          questionCount: 15,
          difficulty: 'Medium',
          tags: ['Grammar', 'English', 'Language'],
          estimatedTime: const Duration(minutes: 10),
        ),
        QuizTopic(
          id: 2,
          name: 'Vocabulary Building',
          description: 'Expand your vocabulary with common English words',
          imagePath: 'images/vocabulary.png',
          questionCount: 20,
          difficulty: 'Easy',
          tags: ['Vocabulary', 'Words', 'Definitions'],
          estimatedTime: const Duration(minutes: 12),
        ),
        QuizTopic(
          id: 3,
          name: 'Business English',
          description: 'Professional English for workplace communication',
          imagePath: 'images/business.png',
          questionCount: 18,
          difficulty: 'Hard',
          tags: ['Business', 'Professional', 'Communication'],
          estimatedTime: const Duration(minutes: 15),
        ),
        QuizTopic(
          id: 4,
          name: 'Academic Writing',
          description: 'Improve your academic and formal writing skills',
          imagePath: 'images/writing.png',
          questionCount: 12,
          difficulty: 'Hard',
          tags: ['Writing', 'Academic', 'Essay'],
          estimatedTime: const Duration(minutes: 20),
        ),
        QuizTopic(
          id: 5,
          name: 'Listening Comprehension',
          description: 'Test your English listening and understanding skills',
          imagePath: 'images/listening.png',
          questionCount: 16,
          difficulty: 'Medium',
          tags: ['Listening', 'Comprehension', 'Audio'],
          estimatedTime: const Duration(minutes: 18),
        ),
      ];
      _clearError();
    } catch (e) {
      _setError('Failed to load quiz topics: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Start a quiz with selected topic
  Future<void> startQuiz(QuizTopic topic) async {
    _setLoading(true);
    try {
      _currentTopic = topic;
      _currentQuestionIndex = 0;
      _userAnswers = [];
      _quizStartTime = DateTime.now();

      // Generate sample questions for the topic
      _currentQuestions = _generateQuestionsForTopic(topic);
      _clearError();
    } catch (e) {
      _setError('Failed to start quiz: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Answer current question
  void answerQuestion(int answerIndex) {
    if (_currentQuestionIndex < _userAnswers.length) {
      _userAnswers[_currentQuestionIndex] = answerIndex;
    } else {
      _userAnswers.add(answerIndex);
    }
    notifyListeners();
  }

  // Go to next question
  bool nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Go to previous question
  bool previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Calculate and get quiz results
  QuizResult getQuizResult() {
    if (_currentTopic == null || _quizStartTime == null) {
      throw Exception('No active quiz to calculate results');
    }

    int correctAnswers = 0;
    for (int i = 0; i < _currentQuestions.length; i++) {
      if (i < _userAnswers.length &&
          _userAnswers[i] == _currentQuestions[i].correctAnswerIndex) {
        correctAnswers++;
      }
    }

    int totalQuestions = _currentQuestions.length;
    int wrongAnswers = totalQuestions - correctAnswers;
    double percentage = (correctAnswers / totalQuestions) * 100;
    int score = (percentage * 10).round(); // Score out of 1000

    return QuizResult(
      topicId: _currentTopic!.id,
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
      timeTaken: DateTime.now().difference(_quizStartTime!),
      completedAt: DateTime.now(),
      percentage: percentage,
    );
  }

  // End current quiz
  void endQuiz() {
    _currentTopic = null;
    _currentQuestions = [];
    _userAnswers = [];
    _currentQuestionIndex = 0;
    _quizStartTime = null;
    notifyListeners();
  }

  // Generate sample questions for a topic
  List<QuizQuestion> _generateQuestionsForTopic(QuizTopic topic) {
    switch (topic.id) {
      case 1: // English Grammar
        return [
          QuizQuestion(
            id: 1,
            question: "Which sentence is grammatically correct?",
            options: [
              "He don't like coffee",
              "He doesn't like coffee",
              "He not like coffee",
              "He no likes coffee",
            ],
            correctAnswerIndex: 1,
            explanation:
                "The correct form is 'doesn't' (does not) for third person singular.",
            difficulty: "Easy",
          ),
          QuizQuestion(
            id: 2,
            question: "What is the past tense of 'go'?",
            options: ["goed", "went", "gone", "going"],
            correctAnswerIndex: 1,
            explanation: "'Went' is the irregular past tense form of 'go'.",
            difficulty: "Easy",
          ),
          // Add more grammar questions...
        ];
      case 2: // Vocabulary
        return [
          QuizQuestion(
            id: 1,
            question: "What does 'elaborate' mean?",
            options: [
              "Simple and basic",
              "Complex and detailed",
              "Fast and quick",
              "Old and outdated",
            ],
            correctAnswerIndex: 1,
            explanation:
                "'Elaborate' means detailed, complex, or carefully planned.",
            difficulty: "Medium",
          ),
          // Add more vocabulary questions...
        ];
      default:
        return [
          QuizQuestion(
            id: 1,
            question: "Sample question for ${topic.name}",
            options: ["Option A", "Option B", "Option C", "Option D"],
            correctAnswerIndex: 1,
            explanation: "This is a sample explanation.",
            difficulty: "Medium",
          ),
        ];
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
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
