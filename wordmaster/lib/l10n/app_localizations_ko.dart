// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'WordMaster';

  @override
  String get home => '홈';

  @override
  String get decks => '덱';

  @override
  String get quiz => '퀴즈';

  @override
  String get progress => '진행도';

  @override
  String get profile => '프로필';

  @override
  String get welcomeBack => 'WordMaster에 오신 것을 환영합니다!';

  @override
  String get welcomeMessage => '프로필 관리와 성과 추적을 위해 로그인하세요';

  @override
  String get login => '로그인';

  @override
  String get register => '등록';

  @override
  String get createAccount => '새 계정 만들기';

  @override
  String get logout => '로그아웃';

  @override
  String get confirmLogout => '로그아웃 확인';

  @override
  String get confirmLogoutMessage => '로그아웃 하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get settings => '설정';

  @override
  String get notifications => '알림';

  @override
  String get language => '언어';

  @override
  String get darkMode => '다크 모드';

  @override
  String get help => '도움말';

  @override
  String get about => '정보';

  @override
  String level(int level) {
    return '레벨 $level';
  }

  @override
  String get progress_text => '진행도';

  @override
  String get currentPoints => '현재 포인트';

  @override
  String get nextLevel => '다음 레벨';

  @override
  String get totalLearned => '학습한 카드';

  @override
  String get mastered => '마스터함';

  @override
  String get streak => '연속 기록';

  @override
  String get days => '일';

  @override
  String highestStreak(int days) {
    return '최고: $days';
  }

  @override
  String get flashcards => '플래시카드 덱';

  @override
  String get quizCompleted => '퀴즈 완료';

  @override
  String get streakDays => '연속 일수';

  @override
  String get achievements => '주요 성과';

  @override
  String get viewAll => '모두 보기';

  @override
  String get noAchievements => '아직 성과가 없습니다';

  @override
  String get loading => '로딩 중...';

  @override
  String get loadingData => '데이터를 로딩 중...';

  @override
  String get unlocked => '잠금 해제됨';

  @override
  String get locked => '잠금';

  @override
  String get recentActivities => '최근 활동';

  @override
  String get noActivities => '아직 활동이 없습니다';

  @override
  String get quickSettings => '빠른 설정';

  @override
  String get security => '보안';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get helpAndFAQ => '도움말 및 FAQ';

  @override
  String get notificationTypes => '알림 유형';

  @override
  String get studyReminders => '학습 알림';

  @override
  String get studyRemindersDesc => '매일 학습 알림 받기';

  @override
  String get achievementNotifications => '성과';

  @override
  String get achievementNotificationsDesc => '새 성과를 달성할 때 알림';

  @override
  String get weeklyProgress => '진행 보고서';

  @override
  String get weeklyProgressDesc => '주간 학습 진행 요약';

  @override
  String get notificationBehavior => '알림 동작';

  @override
  String get sound => '소리';

  @override
  String get soundDesc => '알림 소리 재생';

  @override
  String get vibration => '진동';

  @override
  String get vibrationDesc => '알림 시 진동';

  @override
  String get reminderTime => '알림 시간';

  @override
  String get studyReminderTime => '학습 알림 시간';

  @override
  String get dailyAt => '매일 오후 8:00';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get changeLanguageDesc => '앱 표시 언어 변경';

  @override
  String get currentLanguage => '현재 언어';

  @override
  String get availableLanguages => '사용 가능한 언어';

  @override
  String get vietnamese => '베트남어';

  @override
  String get english => '영어';

  @override
  String get chinese => '중국어';

  @override
  String get japanese => '일본어';

  @override
  String get korean => '한국어';

  @override
  String get changeLanguageConfirm => '변경 확인';

  @override
  String changeLanguageMessage(String language) {
    return '$language(으)로 전환하시겠습니까?';
  }

  @override
  String languageChanged(String language) {
    return '$language(으)로 전환되었습니다';
  }

  @override
  String get infoNote => '참고';

  @override
  String get languageChangeNote =>
      '언어 변경은 앱 전체에 적용됩니다. 일부 어휘는 업데이트에 시간이 걸릴 수 있습니다.';

  @override
  String get notificationNote => '알림은 꾸준한 학습 습관을 유지하고 목표를 달성하는 데 도움이 됩니다.';

  @override
  String joinedSince(String date) {
    return '$date부터 회원';
  }

  @override
  String get error => '오류';

  @override
  String get success => '성공';

  @override
  String get failed => '실패';

  @override
  String get retry => '다시 시도';

  @override
  String get close => '닫기';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get add => '추가';

  @override
  String get search => '검색';

  @override
  String get filter => '필터';

  @override
  String get sort => '정렬';
}
