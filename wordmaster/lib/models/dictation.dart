// lib/models/dictation.dart

class DictationLesson {
  final int id;
  final String title;
  final String description;
  final DictationLevel level;
  final String videoPath;        // assets/videos/lesson_01.mp4
  final String thumbnailPath;    // assets/images/lesson_01_thumb.jpg
  final int durationSeconds;
  final String fullTranscript;   // Full text để chấm điểm
  final List<DictationSegment> segments;  // Chia theo câu
  
  DictationLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.videoPath,
    required this.thumbnailPath,
    required this.durationSeconds,
    required this.fullTranscript,
    required this.segments,
  });
  
  int get totalWords => fullTranscript.split(' ').length;
  String get levelText => level == DictationLevel.beginner 
      ? 'Cơ bản' 
      : level == DictationLevel.intermediate 
          ? 'Trung cấp' 
          : 'Nâng cao';
}

class DictationSegment {
  final int index;
  final String text;
  final int startTimeMs;  // Thời điểm bắt đầu (milliseconds)
  final int endTimeMs;    // Thời điểm kết thúc
  
  DictationSegment({
    required this.index,
    required this.text,
    required this.startTimeMs,
    required this.endTimeMs,
  });
  
  int get wordCount => text.split(' ').length;
}

enum DictationLevel {
  beginner,
  intermediate,
  advanced,
}

class DictationResult {
  final int lessonId;
  final String userInput;
  final String correctText;
  final int totalWords;
  final int correctWords;
  final int totalCharacters;
  final int correctCharacters;
  final List<WordComparison> wordComparisons;
  final DateTime completedAt;
  final int timeSpentSeconds;
  
  DictationResult({
    required this.lessonId,
    required this.userInput,
    required this.correctText,
    required this.totalWords,
    required this.correctWords,
    required this.totalCharacters,
    required this.correctCharacters,
    required this.wordComparisons,
    required this.completedAt,
    required this.timeSpentSeconds,
  });
  
  double get wordAccuracy => totalWords > 0 ? (correctWords / totalWords) * 100 : 0;
  double get charAccuracy => totalCharacters > 0 ? (correctCharacters / totalCharacters) * 100 : 0;
  
  String get grade {
    if (wordAccuracy >= 90) return 'Xuất sắc';
    if (wordAccuracy >= 75) return 'Tốt';
    if (wordAccuracy >= 60) return 'Khá';
    return 'Cần cải thiện';
  }
}

class WordComparison {
  final String userWord;
  final String correctWord;
  final bool isCorrect;
  final int position;
  
  WordComparison({
    required this.userWord,
    required this.correctWord,
    required this.isCorrect,
    required this.position,
  });
}