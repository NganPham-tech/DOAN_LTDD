import '../models/dictation.dart';

class DictationData {
  static List<DictationLesson> getSampleLessons() {
    return [
      DictationLesson(
        id: 1,
        title: 'Giới thiệu bản thân',
        description: 'Các câu cơ bản để giới thiệu bản thân',
        level: DictationLevel.beginner,
        videoPath: 'assets/videos/lesson_01.mp4',
        thumbnailPath: 'assets/images/lesson_01_thumb.jpg',
        durationSeconds: 60,
        fullTranscript: 'Hello, my name is John. I am 25 years old. I live in Ho Chi Minh City.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'Hello, my name is John.',
            startTimeMs: 0,
            endTimeMs: 3000,
          ),
          DictationSegment(
            index: 1,
            text: 'I am 25 years old.',
            startTimeMs: 3500,
            endTimeMs: 6000,
          ),
          DictationSegment(
            index: 2,
            text: 'I live in Ho Chi Minh City.',
            startTimeMs: 6500,
            endTimeMs: 10000,
          ),
        ],
      ),
      DictationLesson(
        id: 2,
        title: 'Thời tiết hôm nay',
        description: 'Mô tả thời tiết và cảm xúc',
        level: DictationLevel.beginner,
        videoPath: 'assets/videos/lesson_02.mp4',
        thumbnailPath: 'assets/images/lesson_02_thumb.jpg',
        durationSeconds: 45,
        fullTranscript: 'Today is a sunny day. The weather is very nice. I feel happy today.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'Today is a sunny day.',
            startTimeMs: 0,
            endTimeMs: 4000,
          ),
          DictationSegment(
            index: 1,
            text: 'The weather is very nice.',
            startTimeMs: 4500,
            endTimeMs: 8000,
          ),
          DictationSegment(
            index: 2,
            text: 'I feel happy today.',
            startTimeMs: 8500,
            endTimeMs: 12000,
          ),
        ],
      ),
      DictationLesson(
        id: 3,
        title: 'Đi mua sắm',
        description: 'Hội thoại khi đi siêu thị',
        level: DictationLevel.intermediate,
        videoPath: 'assets/videos/lesson_03.mp4',
        thumbnailPath: 'assets/images/lesson_03_thumb.jpg',
        durationSeconds: 70,
        fullTranscript: 'How much does this cost? Can I pay with credit card? Do you have a discount?',
        segments: [
          DictationSegment(
            index: 0,
            text: 'How much does this cost?',
            startTimeMs: 0,
            endTimeMs: 4000,
          ),
          DictationSegment(
            index: 1,
            text: 'Can I pay with credit card?',
            startTimeMs: 4500,
            endTimeMs: 8000,
          ),
          DictationSegment(
            index: 2,
            text: 'Do you have a discount?',
            startTimeMs: 8500,
            endTimeMs: 12000,
          ),
        ],
      ),
      DictationLesson(
        id: 4,
        title: 'Ở nhà hàng',
        description: 'Đặt món và thanh toán',
        level: DictationLevel.intermediate,
        videoPath: 'assets/videos/lesson_04.mp4',
        thumbnailPath: 'assets/images/lesson_04_thumb.jpg',
        durationSeconds: 80,
        fullTranscript: 'Can I see the menu please? I would like to order chicken. The food is delicious.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'Can I see the menu please?',
            startTimeMs: 0,
            endTimeMs: 4000,
          ),
          DictationSegment(
            index: 1,
            text: 'I would like to order chicken.',
            startTimeMs: 4500,
            endTimeMs: 8000,
          ),
          DictationSegment(
            index: 2,
            text: 'The food is delicious.',
            startTimeMs: 8500,
            endTimeMs: 12000,
          ),
        ],
      ),
      DictationLesson(
        id: 5,
        title: 'Công việc hàng ngày',
        description: 'Mô tả các hoạt động trong ngày',
        level: DictationLevel.advanced,
        videoPath: 'assets/videos/lesson_05.mp4',
        thumbnailPath: 'assets/images/lesson_05_thumb.jpg',
        durationSeconds: 90,
        fullTranscript: 'I usually wake up at seven in the morning. After breakfast, I go to work by bus. In the evening, I read books and watch TV.',
        segments: [
          DictationSegment(
            index: 0,
            text: 'I usually wake up at seven in the morning.',
            startTimeMs: 0,
            endTimeMs: 5000,
          ),
          DictationSegment(
            index: 1,
            text: 'After breakfast, I go to work by bus.',
            startTimeMs: 5500,
            endTimeMs: 10000,
          ),
          DictationSegment(
            index: 2,
            text: 'In the evening, I read books and watch TV.',
            startTimeMs: 10500,
            endTimeMs: 15000,
          ),
        ],
      ),
    ];
  }
}
