import 'study_session.dart';

class Flashcard {
  final int flashcardID;
  final int deckID;
  final String question;
  final String answer;
  final String example;
  final String audioPath;
  final String imagePath;
  final CardStatus status;
  final DateTime? nextReviewDate;

  Flashcard({
    required this.flashcardID,
    required this.deckID,
    required this.question,
    required this.answer,
    required this.example,
    required this.audioPath,
    required this.imagePath,
    this.status = CardStatus.fresh,
    this.nextReviewDate,
  });
}