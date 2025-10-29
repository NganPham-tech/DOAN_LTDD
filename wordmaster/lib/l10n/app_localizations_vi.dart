// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'WordMaster';

  @override
  String get home => 'Trang chủ';

  @override
  String get decks => 'Bộ thẻ';

  @override
  String get quiz => 'Quiz';

  @override
  String get progress => 'Tiến độ';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get welcomeBack => 'Chào mừng trở lại!';

  @override
  String get welcomeMessage =>
      'Đăng nhập để quản lý thông tin cá nhân và theo dõi thành tích của bạn';

  @override
  String get login => 'Đăng nhập';

  @override
  String get register => 'Đăng ký';

  @override
  String get createAccount => 'Tạo tài khoản mới';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get confirmLogout => 'Xác nhận đăng xuất';

  @override
  String get confirmLogoutMessage => 'Bạn có chắc chắn muốn đăng xuất?';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get notifications => 'Thông báo';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get help => 'Trợ giúp';

  @override
  String get about => 'Về ứng dụng';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String get progress_text => 'Tiến độ';

  @override
  String get currentPoints => 'Điểm hiện tại';

  @override
  String get nextLevel => 'Cấp tiếp theo';

  @override
  String get totalLearned => 'Từ đã học';

  @override
  String get mastered => 'Đã thuộc';

  @override
  String get streak => 'Streak';

  @override
  String get days => 'ngày';

  @override
  String highestStreak(int days) {
    return 'Cao nhất: $days';
  }

  @override
  String get flashcards => 'Bộ flashcard';

  @override
  String get quizCompleted => 'Quiz hoàn thành';

  @override
  String get streakDays => 'Ngày streak';

  @override
  String get achievements => 'Thành tích nổi bật';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get noAchievements => 'Chưa có thành tích nào';

  @override
  String get loading => 'Đang tải...';

  @override
  String get loadingData => 'Đang tải dữ liệu...';

  @override
  String get unlocked => 'Đã mở khóa';

  @override
  String get locked => 'Chưa mở khóa';

  @override
  String get recentActivities => 'Hoạt động gần đây';

  @override
  String get noActivities => 'Chưa có hoạt động nào';

  @override
  String get quickSettings => 'Cài đặt nhanh';

  @override
  String get security => 'Bảo mật';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get notificationSettings => 'Cài đặt thông báo';

  @override
  String get helpAndFAQ => 'Hỗ trợ và FAQ';

  @override
  String get notificationTypes => 'Loại thông báo';

  @override
  String get studyReminders => 'Nhắc nhở học tập';

  @override
  String get studyRemindersDesc =>
      'Nhận thông báo nhắc nhở học từ vựng hàng ngày';

  @override
  String get achievementNotifications => 'Thành tích';

  @override
  String get achievementNotificationsDesc =>
      'Thông báo khi đạt được thành tích mới';

  @override
  String get weeklyProgress => 'Báo cáo tiến độ';

  @override
  String get weeklyProgressDesc => 'Tóm tắt tiến độ học tập hàng tuần';

  @override
  String get notificationBehavior => 'Hành vi thông báo';

  @override
  String get sound => 'Âm thanh';

  @override
  String get soundDesc => 'Phát âm thanh khi có thông báo';

  @override
  String get vibration => 'Rung';

  @override
  String get vibrationDesc => 'Rung thiết bị khi có thông báo';

  @override
  String get reminderTime => 'Thời gian nhắc nhở';

  @override
  String get studyReminderTime => 'Giờ nhắc nhở học tập';

  @override
  String get dailyAt => '20:00 hàng ngày';

  @override
  String get languageSettings => 'Cài đặt ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get changeLanguageDesc => 'Thay đổi ngôn ngữ hiển thị của ứng dụng';

  @override
  String get currentLanguage => 'Ngôn ngữ hiện tại';

  @override
  String get availableLanguages => 'Ngôn ngữ có sẵn';

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
  String get changeLanguageConfirm => 'Xác nhận thay đổi';

  @override
  String changeLanguageMessage(String language) {
    return 'Bạn có muốn chuyển sang $language?';
  }

  @override
  String languageChanged(String language) {
    return 'Đã chuyển sang $language';
  }

  @override
  String get infoNote => 'Lưu ý';

  @override
  String get languageChangeNote =>
      'Thay đổi ngôn ngữ sẽ áp dụng cho toàn bộ ứng dụng. Một số từ vựng có thể cần thời gian để cập nhật.';

  @override
  String get notificationNote =>
      'Thông báo giúp bạn duy trì thói quen học tập đều đặn và đạt được mục tiêu.';

  @override
  String joinedSince(String date) {
    return 'Tham gia từ $date';
  }

  @override
  String get error => 'Lỗi';

  @override
  String get success => 'Thành công';

  @override
  String get failed => 'Thất bại';

  @override
  String get retry => 'Thử lại';

  @override
  String get close => 'Đóng';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get add => 'Thêm';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get filter => 'Lọc';

  @override
  String get sort => 'Sắp xếp';
}
