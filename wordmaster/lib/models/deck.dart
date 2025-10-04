class DeckCategory {
  final int categoryID;
  final String name;
  final String description;
  final String icon;

  DeckCategory({
    required this.categoryID,
    required this.name,
    required this.description,
    required this.icon,
  });
}

class Deck {
  final int deckID;
  final int userID;
  final int categoryID;
  final String name;
  final String description;
  final bool isPublic;
  final DateTime createdAt;
  final int cardCount;
  final int learnedCount;
  final bool isFavorite;
  final bool isUserCreated;
  final String authorName;

  Deck({
    required this.deckID,
    required this.userID,
    required this.categoryID,
    required this.name,
    required this.description,
    required this.isPublic,
    required this.createdAt,
    required this.cardCount,
    required this.learnedCount,
    this.isFavorite = false,
    this.isUserCreated = false,
    this.authorName = 'Hệ thống',
  });

  double get progress => cardCount > 0 ? learnedCount / cardCount : 0;
  String get progressText => '${learnedCount}/$cardCount thẻ';
}