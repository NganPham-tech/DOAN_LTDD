class StudyReminder {
  final int id;
  final String title;
  final String description;
  final DateTime scheduledTime;
  final bool isRepeating;
  final int userId;

  StudyReminder({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.isRepeating,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduled_time': scheduledTime.toIso8601String(),
      'is_repeating': isRepeating ? 1 : 0,
      'user_id': userId,
    };
  }

  factory StudyReminder.fromJson(Map<String, dynamic> json) {
    return StudyReminder(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      isRepeating: (json['is_repeating'] as int) == 1,
      userId: json['user_id'] as int,
    );
  }
}
