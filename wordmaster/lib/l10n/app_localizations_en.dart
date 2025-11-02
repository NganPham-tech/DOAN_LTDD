// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WordMaster';

  @override
  String get home => 'Home';

  @override
  String get decks => 'Decks';

  @override
  String get quiz => 'Quiz';

  @override
  String get progress => 'Progress';

  @override
  String get profile => 'Profile';

  @override
  String get welcomeBack => 'Welcome to WordMaster!';

  @override
  String get welcomeMessage =>
      'Sign in to manage your profile and track your achievements';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create New Account';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String get progress_text => 'Progress';

  @override
  String get currentPoints => 'Current Points';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get totalLearned => 'Cards Learned';

  @override
  String get mastered => 'Mastered';

  @override
  String get streak => 'Streak';

  @override
  String get days => 'days';

  @override
  String highestStreak(int days) {
    return 'Highest: $days';
  }

  @override
  String get flashcards => 'Flashcard Decks';

  @override
  String get quizCompleted => 'Quizzes Completed';

  @override
  String get streakDays => 'Streak Days';

  @override
  String get achievements => 'Notable Achievements';

  @override
  String get viewAll => 'View All';

  @override
  String get noAchievements => 'No achievements yet';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get locked => 'Locked';

  @override
  String get recentActivities => 'Recent Activities';

  @override
  String get noActivities => 'No activities yet';

  @override
  String get quickSettings => 'Quick Settings';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change Password';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get helpAndFAQ => 'Help & FAQ';

  @override
  String get notificationTypes => 'Notification Types';

  @override
  String get studyReminders => 'Study Reminders';

  @override
  String get studyRemindersDesc => 'Receive daily study reminders';

  @override
  String get achievementNotifications => 'Achievements';

  @override
  String get achievementNotificationsDesc =>
      'Notify when you unlock new achievements';

  @override
  String get weeklyProgress => 'Progress Report';

  @override
  String get weeklyProgressDesc => 'Weekly learning progress summary';

  @override
  String get notificationBehavior => 'Notification Behavior';

  @override
  String get sound => 'Sound';

  @override
  String get soundDesc => 'Play sound for notifications';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationDesc => 'Vibrate device for notifications';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get studyReminderTime => 'Study Reminder Time';

  @override
  String get dailyAt => 'Daily at 8:00 PM';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get changeLanguageDesc => 'Change app display language';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get availableLanguages => 'Available Languages';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get changeLanguageConfirm => 'Confirm Change';

  @override
  String changeLanguageMessage(String language) {
    return 'Do you want to switch to $language?';
  }

  @override
  String languageChanged(String language) {
    return 'Switched to $language';
  }

  @override
  String get infoNote => 'Note';

  @override
  String get languageChangeNote =>
      'Language changes will apply to the entire app. Some vocabulary may take time to update.';

  @override
  String get notificationNote =>
      'Notifications help you maintain consistent study habits and achieve your goals.';

  @override
  String joinedSince(String date) {
    return 'Member since $date';
  }

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get study_reminder => 'Lịch học';

  @override
  String get study_reminder_title => 'Lịch nhắc nhở của bạn';

  @override
  String get add_reminder => 'Thêm lịch nhắc nhở mới';

  @override
  String get reminder_title => 'Tiêu đề';

  @override
  String get reminder_description => 'Mô tả';

  @override
  String get select_time => 'Chọn thời gian';

  @override
  String time(String time) {
    return 'Thời gian: $time';
  }

  @override
  String get repeat_daily => 'Lặp lại hàng ngày';

  @override
  String get add_reminder_button => 'Thêm nhắc nhở';

  @override
  String get reminder_added => 'Đã thêm lịch nhắc nhở thành công';

  @override
  String get please_enter_title => 'Vui lòng nhập tiêu đề';
}
