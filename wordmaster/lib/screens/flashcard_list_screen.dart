import 'package:flutter/material.dart';
import 'flashcard_study_screen.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../models/study_session.dart';
// Đảm bảo FlashcardListScreen có thể nhận Deck object

class FlashcardListScreen extends StatefulWidget {
  final Deck deck;

  const FlashcardListScreen({super.key, required this.deck});

  @override
  _FlashcardListScreenState createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  List<Flashcard> flashcards = [];
  CardStatus _currentFilter = CardStatus.fresh;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  void _loadFlashcards() {
    // Mock data - trong thực tế sẽ lấy từ database
    setState(() {
      flashcards = [
        Flashcard(
          flashcardID: 1,
          deckID: widget.deck.deckID,
          question: 'Apple',
          answer: 'Quả táo',
          example: 'I eat an apple every day.',
          audioPath: '',
          imagePath: '',
          status: CardStatus.learning,
        ),
        Flashcard(
          flashcardID: 2,
          deckID: widget.deck.deckID,
          question: 'Book',
          answer: 'Quyển sách',
          example: 'This is an interesting book.',
          audioPath: '',
          imagePath: '',
          status: CardStatus.fresh,
        ),
        Flashcard(
          flashcardID: 3,
          deckID: widget.deck.deckID,
          question: 'Computer',
          answer: 'Máy tính',
          example: 'I use computer for work.',
          audioPath: '',
          imagePath: '',
          status: CardStatus.mastered,
        ),
      ];
    });
  }

  List<Flashcard> get _filteredFlashcards {
    if (_currentFilter == CardStatus.fresh) {
      return flashcards;
    }
    return flashcards.where((card) => card.status == _currentFilter).toList();
  }

  void _startStudySession() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardStudyScreen(
          deck: widget.deck,
          flashcards: _filteredFlashcards,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentFilter = CardStatus.fresh),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _currentFilter == CardStatus.fresh 
                          ? Colors.blue.withOpacity(0.1) 
                          : null,
                    ),
                    child: const Text('Tất cả'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentFilter = CardStatus.learning),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _currentFilter == CardStatus.learning 
                          ? Colors.orange.withOpacity(0.1) 
                          : null,
                    ),
                    child: const Text('Đang học'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentFilter = CardStatus.mastered),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _currentFilter == CardStatus.mastered 
                          ? Colors.green.withOpacity(0.1) 
                          : null,
                    ),
                    child: const Text('Đã thuộc'),
                  ),
                ),
              ],
            ),
          ),
          // Study Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.school),
              label: const Text('Học Ngay'),
              onPressed: _startStudySession,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Flashcard List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFlashcards.length,
              itemBuilder: (context, index) {
                final flashcard = _filteredFlashcards[index];
                return _buildFlashcardItem(flashcard);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardItem(Flashcard flashcard) {
    Color statusColor = Colors.grey;
    String statusText = 'Mới';
    
    switch (flashcard.status) {
      case CardStatus.learning:
        statusColor = Colors.orange;
        statusText = 'Đang học';
        break;
      case CardStatus.mastered:
        statusColor = Colors.green;
        statusText = 'Đã thuộc';
        break;
      case CardStatus.fresh:
        statusColor = Colors.blue;
        statusText = 'Mới';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(flashcard.question),
        subtitle: Text(flashcard.answer),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            statusText,
            style: TextStyle(color: statusColor, fontSize: 12),
          ),
        ),
      ),
    );
  }
}