// lib/screens/quiz/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/quiz_controller.dart';
import '../../../models/quiz_topic.dart';
import '../../../services/tts_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizTopic topic;

  const QuizScreen({super.key, required this.topic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController quizController = Get.find<QuizController>();
  int? _selectedAnswer;
  bool _showExplanation = false;
  final TextEditingController _textController = TextEditingController();
  String _userTextAnswer = '';

  @override
  void initState() {
    super.initState();
    // Initialize shared TTS service (singleton)
    TtsService.initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quizController.startQuiz(widget.topic);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    TtsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topic.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _showQuitDialog(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Obx(() {
        if (quizController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading quiz...'),
              ],
            ),
          );
        }

        if (quizController.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading quiz',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(quizController.error.value!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        }

        final currentQuestion = quizController.currentQuestion;
        if (currentQuestion == null) {
          return const Center(child: Text('No questions available'));
        }

        final progress = (quizController.currentQuestionIndex.value + 1) / quizController.currentQuestions.length;

        return Column(
          children: [
            // Progress bar
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${quizController.currentQuestionIndex.value + 1} of ${quizController.currentQuestions.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Question content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(currentQuestion.difficulty),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentQuestion.difficulty,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentQuestion.question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Answer options - Different UI based on question type
                    Expanded(child: _buildAnswerWidget(currentQuestion)),

                    // Explanation (if shown)
                    if (_showExplanation) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.blue[700],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Explanation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentQuestion.explanation,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[800],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (quizController.currentQuestionIndex.value > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _showExplanation
                            ? null
                            : () {
                                quizController.previousQuestion();
                                _resetAnswerState();
                              },
                        child: const Text('Previous'),
                      ),
                    ),
                  if (quizController.currentQuestionIndex.value > 0)
                    const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _selectedAnswer == null ? null : _handleNext,
                      child: Text(_getNextButtonText()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswer = index;
    });
    quizController.answerQuestion(index);
  }

  Widget _buildAnswerWidget(QuizQuestion question) {
    switch (question.questionType) {
      case 'Listening':
        return _buildListeningWidget(question);
      case 'FillInBlank':
        return _buildFillInBlankWidget(question);
      case 'MultipleChoice':
      default:
        return _buildMultipleChoiceWidget(question);
    }
  }

  // Widget cho MultipleChoice quiz
  Widget _buildMultipleChoiceWidget(QuizQuestion question) {
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final isSelected = _selectedAnswer == index;
        final isCorrect = index == question.correctAnswerIndex;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnswerOption(
            text: question.options[index],
            isSelected: isSelected,
            isCorrect: _showExplanation ? isCorrect : null,
            onTap: _showExplanation ? null : () => _selectAnswer(index),
          ),
        );
      },
    );
  }

  // Widget cho Listening quiz
  Widget _buildListeningWidget(QuizQuestion question) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Play audio button
          Card(
            elevation: 2,
            child: InkWell(
              onTap: () async {
                final text = question.audioText ?? '';
                if (text.isEmpty) return;
                // Use shared TTS service
                await TtsService.speak(text);
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.volume_up,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to listen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Text input field
          TextField(
            controller: _textController,
            enabled: !_showExplanation,
            onChanged: (value) {
              setState(() {
                _userTextAnswer = value;
                // Auto-select answer when user types
                if (value.trim().isNotEmpty) {
                  _selectedAnswer = 0; // Dummy selection to enable Submit button
                }
              });
            },
            decoration: InputDecoration(
              labelText: 'Type what you hear',
              hintText: 'Enter your answer here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: _showExplanation ? Colors.grey[100] : Colors.white,
              prefixIcon: const Icon(Icons.edit),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),

          // Show correct answer if explanation is shown
          if (_showExplanation) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Correct Answer:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.audioText ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_userTextAnswer.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Your answer:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userTextAnswer,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget cho FillInBlank quiz
  Widget _buildFillInBlankWidget(QuizQuestion question) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hint if available
          if (question.hint != null && question.hint!.isNotEmpty) ...[
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.tips_and_updates, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hint: ${question.hint}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // First letter hint
          if (question.firstLetter != null && question.firstLetter!.isNotEmpty) ...[
            Text(
              'First letter: ${question.firstLetter}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Word length hint
          if (question.wordLength != null && question.wordLength! > 0) ...[
            Text(
              'Word length: ${question.wordLength} letters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Text input field
          TextField(
            controller: _textController,
            enabled: !_showExplanation,
            onChanged: (value) {
              setState(() {
                _userTextAnswer = value;
                if (value.trim().isNotEmpty) {
                  _selectedAnswer = 0; // Dummy selection to enable Submit button
                }
              });
            },
            decoration: InputDecoration(
              labelText: 'Fill in the blank',
              hintText: 'Type or select from word bank',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: _showExplanation ? Colors.grey[100] : Colors.white,
              prefixIcon: const Icon(Icons.edit),
            ),
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // Word bank buttons
          if (question.options.isNotEmpty) ...[
            Text(
              'Word Bank:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.options.asMap().entries.map((entry) {
                final index = entry.key;
                final word = entry.value;
                final isSelected = _selectedAnswer == index;

                return ActionChip(
                  label: Text(word),
                  onPressed: _showExplanation
                      ? null
                      : () {
                          setState(() {
                            _textController.text = word;
                            _userTextAnswer = word;
                            _selectedAnswer = index;
                          });
                        },
                  backgroundColor: isSelected
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : null,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                );
              }).toList(),
            ),
          ],

          // Show correct answer if explanation is shown
          if (_showExplanation) ...[
            const SizedBox(height: 16),
            Card(
              color: _selectedAnswer == question.correctAnswerIndex
                  ? Colors.green[50]
                  : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _selectedAnswer == question.correctAnswerIndex
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _selectedAnswer == question.correctAnswerIndex
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Correct Answer:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _selectedAnswer == question.correctAnswerIndex
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.options[question.correctAnswerIndex],
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedAnswer == question.correctAnswerIndex
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleNext() {
    if (!_showExplanation) {
      final currentQuestion = quizController.currentQuestion;

      if (currentQuestion != null) {
        // For text-based answers (Listening, FillInBlank)
        if (currentQuestion.questionType == 'Listening') {
          // Check if user's answer matches the audio text
          final correctAnswer = currentQuestion.audioText ?? '';
          final isCorrect = _userTextAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

          // Submit the answer (0 for correct, -1 for incorrect)
          quizController.answerQuestion(isCorrect ? 0 : -1);
        } else if (currentQuestion.questionType == 'FillInBlank') {
          // Answer already selected via _selectedAnswer
          quizController.answerQuestion(_selectedAnswer ?? -1);
        }
        // MultipleChoice already handled by _selectAnswer
      }

      setState(() {
        _showExplanation = true;
      });
    } else {
      final hasNext = quizController.nextQuestion();

      if (hasNext) {
        _resetAnswerState();
      } else {
        _finishQuiz();
      }
    }
  }

  void _resetAnswerState() {
    setState(() {
      _selectedAnswer = null;
      _showExplanation = false;
      _textController.clear();
      _userTextAnswer = '';
    });
  }

  void _finishQuiz() {
    final result = quizController.getQuizResult();
    Get.off(() => QuizResultScreen(result: result));
  }

  String _getNextButtonText() {
    if (!_showExplanation) {
      return 'Submit Answer';
    }

    final isLast = quizController.currentQuestionIndex.value == quizController.currentQuestions.length - 1;
    return isLast ? 'Finish Quiz' : 'Next Question';
  }

  Color _getDifficultyColor(String difficulty) {
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

  void _showQuitDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Quit Quiz?'),
        content: const Text(
          'Are you sure you want to quit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close quiz
              quizController.endQuiz();
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }
}

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.text,
    required this.isSelected,
    this.isCorrect,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    if (isCorrect != null) {
      // Show results
      if (isCorrect!) {
        backgroundColor = Colors.green[50]!;
        borderColor = Colors.green;
        textColor = Colors.green[800]!;
        icon = Icons.check_circle;
      } else if (isSelected) {
        backgroundColor = Colors.red[50]!;
        borderColor = Colors.red;
        textColor = Colors.red[800]!;
        icon = Icons.cancel;
      } else {
        backgroundColor = Colors.grey[50]!;
        borderColor = Colors.grey[300]!;
        textColor = Colors.grey[600]!;
      }
    } else {
      // Normal state
      if (isSelected) {
        backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
        borderColor = Theme.of(context).primaryColor;
        textColor = Theme.of(context).primaryColor;
      } else {
        backgroundColor = Colors.white;
        borderColor = Colors.grey[300]!;
        textColor = Colors.black87;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(
                icon,
                color: isCorrect! ? Colors.green : Colors.red,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}