enum CardType { vocabulary, grammar }

enum CardStatus { newCard, learning, review, mastered }

enum Difficulty { easy, medium, hard }

class Flashcard {
  final int? flashcardID;
  final int deckID;
  final CardType cardType;
  final String question;
  final String answer;
  final String? example;
  final String? phonetic;
  final String? imagePath;
  final Difficulty difficulty;
  final String? wordType;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Learning progress properties
  final CardStatus status;
  final DateTime? nextReviewDate;

  Flashcard({
    this.flashcardID,
    required this.deckID,
    this.cardType = CardType.vocabulary,
    required this.question,
    required this.answer,
    this.example,
    this.phonetic,
    this.imagePath,
    this.difficulty = Difficulty.medium,
    this.wordType,
    required this.createdAt,
    required this.updatedAt,
    this.status = CardStatus.newCard,
    this.nextReviewDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'FlashcardID': flashcardID,
      'DeckID': deckID,
      'CardType': cardType.toString().split('.').last,
      'Question': question,
      'Answer': answer,
      'Example': example,
      'Phonetic': phonetic,
      'ImagePath': imagePath,
      'Difficulty': difficulty.toString().split('.').last,
      'WordType': wordType,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'Status': status.toString().split('.').last,
      'NextReviewDate': nextReviewDate?.toIso8601String(),
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      flashcardID: map['FlashcardID'],
      deckID: map['DeckID'],
      cardType: CardType.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            (map['CardType']?.toString().toLowerCase() ?? 'vocabulary'),
        orElse: () => CardType.vocabulary,
      ),
      question: map['Question'],
      answer: map['Answer'],
      example: map['Example'],
      phonetic: map['Phonetic'],
      imagePath: map['ImagePath'],
      difficulty: Difficulty.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            (map['Difficulty']?.toString().toLowerCase() ?? 'medium'),
        orElse: () => Difficulty.medium,
      ),
      wordType: map['WordType'],
      createdAt: DateTime.parse(map['CreatedAt']),
      updatedAt: DateTime.parse(map['UpdatedAt']),
      status: CardStatus.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            (map['Status']?.toString().toLowerCase() ?? 'new_card'),
        orElse: () => CardStatus.newCard,
      ),
      nextReviewDate: map['NextReviewDate'] != null
          ? DateTime.parse(map['NextReviewDate'])
          : null,
    );
  }

  Flashcard copyWith({
    int? flashcardID,
    int? deckID,
    CardType? cardType,
    String? question,
    String? answer,
    String? example,
    String? phonetic,
    String? imagePath,
    Difficulty? difficulty,
    String? wordType,
    DateTime? createdAt,
    DateTime? updatedAt,
    CardStatus? status,
    DateTime? nextReviewDate,
  }) {
    return Flashcard(
      flashcardID: flashcardID ?? this.flashcardID,
      deckID: deckID ?? this.deckID,
      cardType: cardType ?? this.cardType,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      example: example ?? this.example,
      phonetic: phonetic ?? this.phonetic,
      imagePath: imagePath ?? this.imagePath,
      difficulty: difficulty ?? this.difficulty,
      wordType: wordType ?? this.wordType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    );
  }
}
