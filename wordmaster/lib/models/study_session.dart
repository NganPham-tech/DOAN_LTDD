
class StudySession {
  final int sessionID;
  final int userID;
  final int deckID;
  final StudyMode mode;
  final int score;
  final int totalCards;
  final int duration;
  final DateTime startedAt;
  final DateTime? completedAt;

  StudySession({
    required this.sessionID,
    required this.userID,
    required this.deckID,
    required this.mode,
    required this.score,
    required this.totalCards,
    required this.duration,
    required this.startedAt,
    this.completedAt,
  });
}

enum CardStatus { fresh, learning, mastered }
enum StudyMode { learn, review, quiz }
enum CardDifficulty { again, hard, good, easy }