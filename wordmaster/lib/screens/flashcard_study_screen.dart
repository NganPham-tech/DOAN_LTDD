import 'package:flutter/material.dart';
import 'session_result_screen.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';

import '../data/api_texttospeach.dart';

enum CardDifficulty { again, hard, good, easy }

class FlashcardStudyScreen extends StatefulWidget {
  final Deck deck;
  final List<Flashcard> flashcards;

  const FlashcardStudyScreen({
    super.key,
    required this.deck,
    required this.flashcards,
  });

  @override
  _FlashcardStudyScreenState createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool isFront = true;
  bool showAnswerButtons = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<CardDifficulty> cardResults = [];

  @override
  void initState() {
    super.initState();
    cardResults = List.filled(widget.flashcards.length, CardDifficulty.again);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    // Khởi tạo Text-to-Speech
    TextToSpeechApi.init();
  }

  void _flipCard() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      isFront = !isFront;
      showAnswerButtons = !isFront;
    });
  }

  // Hàm phát âm từ vựng
  Future<void> _speakWord(String text) async {
    try {
      await TextToSpeechApi.speak(text);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi phát âm: $e')));
    }
  }

  void _rateCard(CardDifficulty difficulty) {
    cardResults[currentIndex] = difficulty;

    if (currentIndex < widget.flashcards.length - 1) {
      // Transition mượt sang thẻ tiếp theo
      _animationController.reverse().then((_) {
        setState(() {
          currentIndex++;
          isFront = true;
          showAnswerButtons = false;
        });
        _animationController.reset();
      });
    } else {
      _finishSession();
    }
  }

  void _finishSession() {
    final rememberedCount = cardResults
        .where((r) => r == CardDifficulty.good || r == CardDifficulty.easy)
        .length;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SessionResultScreen(
          deck: widget.deck,
          totalCards: widget.flashcards.length,
          rememberedCount: rememberedCount,
          studyDuration: 0, // Tính thời gian thực tế
        ),
      ),
    );
  }

  IconData _getDifficultyIcon(CardDifficulty difficulty) {
    switch (difficulty) {
      case CardDifficulty.again:
        return Icons.close; // X - Quên
      case CardDifficulty.hard:
        return Icons.remove; // - - Khó nhớ
      case CardDifficulty.good:
        return Icons.check; // ✓ - Bình thường
      case CardDifficulty.easy:
        return Icons.done_all; // ✓✓ - Dễ nhớ
    }
  }

  String _getDifficultyTooltip(CardDifficulty difficulty) {
    switch (difficulty) {
      case CardDifficulty.again:
        return 'Quên';
      case CardDifficulty.hard:
        return 'Khó nhớ';
      case CardDifficulty.good:
        return 'Bình thường';
      case CardDifficulty.easy:
        return 'Dễ nhớ';
    }
  }

  Color _getDifficultyColor(CardDifficulty difficulty) {
    switch (difficulty) {
      case CardDifficulty.again:
        return Colors.red;
      case CardDifficulty.hard:
        return Colors.orange;
      case CardDifficulty.good:
        return Colors.blue;
      case CardDifficulty.easy:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.deck.name)),
        body: const Center(child: Text('Không có thẻ nào để học')),
      );
    }

    final currentCard = widget.flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'Phát âm từ hiện tại',
            onPressed: () async {
              final currentCard = widget.flashcards[currentIndex];
              await _speakWord(currentCard.question);
            },
          ),
          IconButton(
            icon: const Icon(Icons.volume_off),
            tooltip: 'Dừng phát âm',
            onPressed: () async {
              await TextToSpeechApi.stop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (currentIndex + 1) / widget.flashcards.length,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thẻ ${currentIndex + 1}/${widget.flashcards.length}'),
                if (currentCard.nextReviewDate != null)
                  Text(
                    'Ôn lại: ${currentCard.nextReviewDate!.toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          // Flashcard
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    final isShowingFront = _animation.value < 0.5;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_animation.value * 3.14159),
                      child: Card(
                        elevation: 8,
                        margin: const EdgeInsets.all(24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isShowingFront
                                  ? [Colors.blue[50]!, Colors.blue[100]!]
                                  : [Colors.green[50]!, Colors.green[100]!],
                            ),
                          ),
                          child: isShowingFront
                              ? _buildFrontSide(currentCard)
                              : Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(3.14159),
                                  child: _buildBackSide(currentCard),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Rating Buttons
          if (showAnswerButtons) _buildRatingButtons(),
          // Flip Button
          if (!showAnswerButtons)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.flip_to_back),
                    label: const Text('Lật thẻ để xem đáp án'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _flipCard,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hoặc nhấn vào thẻ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFrontSide(Flashcard card) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Từ vựng
        Text(
          card.question,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Nút phát âm (luôn hiển thị)
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: const Icon(Icons.volume_up, size: 32, color: Colors.blue),
            tooltip: 'Phát âm từ này',
            onPressed: () => _speakWord(card.question),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Nhấn để nghe phát âm',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),

        // Hiển thị image nếu có
        if (card.imagePath?.isNotEmpty == true) ...[
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(card.imagePath!, height: 100, fit: BoxFit.cover),
          ),
        ],
      ],
    );
  }

  Widget _buildBackSide(Flashcard card) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Đáp án
          Text(
            card.answer,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Nút phát âm câu trả lời (nếu là tiếng Anh)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phát âm từ gốc
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.blue),
                  tooltip: 'Phát âm từ gốc',
                  onPressed: () => _speakWord(card.question),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Nghe lại',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          // Ví dụ
          if (card.example?.isNotEmpty == true) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Ví dụ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    card.example!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Nút phát âm ví dụ
                  IconButton(
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.green,
                    ),
                    tooltip: 'Phát âm ví dụ',
                    onPressed: () => _speakWord(card.example!),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Bạn nhớ từ này như thế nào?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: CardDifficulty.values.map((difficulty) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Tooltip(
                    message: _getDifficultyTooltip(difficulty),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getDifficultyColor(difficulty),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _rateCard(difficulty),
                      child: Icon(_getDifficultyIcon(difficulty), size: 20),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Thêm legend để người dùng hiểu các icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(Icons.close, 'Quên', Colors.red),
              _buildLegendItem(Icons.remove, 'Khó', Colors.orange),
              _buildLegendItem(Icons.check, 'OK', Colors.blue),
              _buildLegendItem(Icons.done_all, 'Dễ', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dừng TTS khi rời khỏi màn hình
    TextToSpeechApi.stop();
    super.dispose();
  }
}
