import 'package:flutter/material.dart';
class ProgressAPI {
  static Future<UserProgress> getUserProgress() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return UserProgress(
      totalLearned: 156,
      totalMastered: 89,
      currentStreak: 7,
      bestStreak: 12,
      totalPoints: 1250,
      level: 3,
      perfectQuizCount: 5,
      memoryRate: 72.5,
      totalQuizzes: 15,
    );
  }

  static Future<List<DailyProgress>> getWeeklyProgress() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DailyProgress(
        date: date,
        cardsLearned: [8, 12, 5, 15, 10, 7, 14][index],
        quizzesCompleted: [1, 0, 1, 2, 0, 1, 1][index],
        pointsEarned: [80, 120, 50, 150, 100, 70, 140][index],
      );
    });
  }

  static Future<List<Activity>> getRecentActivities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return [
      Activity(
        type: ActivityType.quiz,
        title: 'Hoàn thành bài Quiz: Phrasal Verbs',
        description: 'Đạt 8/10 điểm',
        icon: Icons.quiz,
        color: Colors.blue,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Activity(
        type: ActivityType.learning,
        title: 'Học 10 thẻ trong bộ Vocabulary: Animals',
        description: 'Tỷ lệ nhớ: 80%',
        icon: Icons.flash_on,
        color: Colors.green,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Activity(
        type: ActivityType.review,
        title: 'Ôn tập 12 flashcard hôm nay',
        description: 'Thành thạo: 8 thẻ',
        icon: Icons.repeat,
        color: Colors.orange,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Activity(
        type: ActivityType.achievement,
        title: 'Đạt streak 7 ngày liên tiếp',
        description: 'Phần thưởng: 50 điểm',
        icon: Icons.local_fire_department,
        color: Colors.red,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Activity(
        type: ActivityType.quiz,
        title: 'Hoàn thành bài Quiz: Business English',
        description: 'Đạt 9/10 điểm',
        icon: Icons.quiz,
        color: Colors.blue,
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ),
    ];
  }

  static Future<List<Achievement>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      Achievement(
        id: 1,
        name: 'Học 100 từ đầu tiên',
        description: 'Hoàn thành 100 thẻ từ vựng đầu tiên',
        icon: Icons.star,
        color: Colors.amber,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        points: 100,
      ),
      Achievement(
        id: 2,
        name: 'Duy trì streak 7 ngày',
        description: 'Học liên tiếp trong 7 ngày',
        icon: Icons.local_fire_department,
        color: Colors.red,
        isUnlocked: true,
        unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
        points: 50,
      ),
      Achievement(
        id: 3,
        name: 'Master 50 từ vựng',
        description: 'Thành thạo 50 thẻ từ vựng',
        icon: Icons.verified,
        color: Colors.green,
        isUnlocked: false,
        unlockedAt: null,
        points: 75,
      ),
      Achievement(
        id: 4,
        name: 'Perfect Quiz x5',
        description: 'Đạt điểm tuyệt đối 5 bài quiz',
        icon: Icons.emoji_events,
        color: Colors.purple,
        isUnlocked: false,
        unlockedAt: null,
        points: 150,
      ),
    ];
  }
}

class UserProgress {
  final int totalLearned;
  final int totalMastered;
  final int currentStreak;
  final int bestStreak;
  final int totalPoints;
  final int level;
  final int perfectQuizCount;
  final double memoryRate;
  final int totalQuizzes;

  UserProgress({
    required this.totalLearned,
    required this.totalMastered,
    required this.currentStreak,
    required this.bestStreak,
    required this.totalPoints,
    required this.level,
    required this.perfectQuizCount,
    required this.memoryRate,
    required this.totalQuizzes,
  });
}

class DailyProgress {
  final DateTime date;
  final int cardsLearned;
  final int quizzesCompleted;
  final int pointsEarned;

  DailyProgress({
    required this.date,
    required this.cardsLearned,
    required this.quizzesCompleted,
    required this.pointsEarned,
  });
}

class Activity {
  final ActivityType type;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime timestamp;

  Activity({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.timestamp,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Vừa xong';
    if (difference.inMinutes < 60) return '${difference.inMinutes} phút trước';
    if (difference.inHours < 24) return '${difference.inHours} giờ trước';
    return '${difference.inDays} ngày trước';
  }
}

enum ActivityType {
  learning,
  review,
  quiz,
  achievement,
}

class Achievement {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int points;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.unlockedAt,
    required this.points,
  });
}