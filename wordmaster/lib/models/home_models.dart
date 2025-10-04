class UserProgress {
  final int totalLearned;
  final int currentStreak;
  final int bestStreak;
  final int points;

  UserProgress({
    required this.totalLearned,
    required this.currentStreak,
    required this.bestStreak,
    required this.points,
  });
}

class FeaturedDeck {
  final int deckID;
  final String name;
  final String description;
  final String icon;
  final int cardCount;
  final bool isFavorite;

  FeaturedDeck({
    required this.deckID,
    required this.name,
    required this.description,
    required this.icon,
    required this.cardCount,
    this.isFavorite = false,
  });
}

class LearningActivity {
  final String action;
  final String target;
  final DateTime createdAt;

  LearningActivity({
    required this.action,
    required this.target,
    required this.createdAt,
  });
}