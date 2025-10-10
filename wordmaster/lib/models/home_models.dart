class User {
  final String id;
  final String email;
  final String fullName;
  final String username;
  final String phone;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    this.phone = '',
    this.avatar = '',
  });

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? username,
    String? phone,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }
}

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
