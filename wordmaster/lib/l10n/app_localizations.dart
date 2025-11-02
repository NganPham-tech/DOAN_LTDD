import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Tên ứng dụng
  ///
  /// In vi, this message translates to:
  /// **'WordMaster'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @decks.
  ///
  /// In vi, this message translates to:
  /// **'Bộ thẻ'**
  String get decks;

  /// No description provided for @quiz.
  ///
  /// In vi, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @progress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get progress;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @welcomeBack.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại!'**
  String get welcomeBack;

  /// No description provided for @welcomeMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để quản lý thông tin cá nhân và theo dõi thành tích của bạn'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get createAccount;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đăng xuất'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn đăng xuất?'**
  String get confirmLogoutMessage;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @editProfile.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get editProfile;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get darkMode;

  /// No description provided for @help.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp'**
  String get help;

  /// No description provided for @about.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get about;

  /// Cấp độ người dùng
  ///
  /// In vi, this message translates to:
  /// **'Level {level}'**
  String level(int level);

  /// No description provided for @progress_text.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ'**
  String get progress_text;

  /// No description provided for @currentPoints.
  ///
  /// In vi, this message translates to:
  /// **'Điểm hiện tại'**
  String get currentPoints;

  /// No description provided for @nextLevel.
  ///
  /// In vi, this message translates to:
  /// **'Cấp tiếp theo'**
  String get nextLevel;

  /// No description provided for @totalLearned.
  ///
  /// In vi, this message translates to:
  /// **'Từ đã học'**
  String get totalLearned;

  /// No description provided for @mastered.
  ///
  /// In vi, this message translates to:
  /// **'Đã thuộc'**
  String get mastered;

  /// No description provided for @streak.
  ///
  /// In vi, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @days.
  ///
  /// In vi, this message translates to:
  /// **'ngày'**
  String get days;

  /// No description provided for @highestStreak.
  ///
  /// In vi, this message translates to:
  /// **'Cao nhất: {days}'**
  String highestStreak(int days);

  /// No description provided for @flashcards.
  ///
  /// In vi, this message translates to:
  /// **'Bộ flashcard'**
  String get flashcards;

  /// No description provided for @quizCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Quiz hoàn thành'**
  String get quizCompleted;

  /// No description provided for @streakDays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày streak'**
  String get streakDays;

  /// No description provided for @achievements.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích nổi bật'**
  String get achievements;

  /// No description provided for @viewAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get viewAll;

  /// No description provided for @noAchievements.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thành tích nào'**
  String get noAchievements;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading;

  /// No description provided for @loadingData.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải dữ liệu...'**
  String get loadingData;

  /// No description provided for @unlocked.
  ///
  /// In vi, this message translates to:
  /// **'Đã mở khóa'**
  String get unlocked;

  /// No description provided for @locked.
  ///
  /// In vi, this message translates to:
  /// **'Chưa mở khóa'**
  String get locked;

  /// No description provided for @recentActivities.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động gần đây'**
  String get recentActivities;

  /// No description provided for @noActivities.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có hoạt động nào'**
  String get noActivities;

  /// No description provided for @quickSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt nhanh'**
  String get quickSettings;

  /// No description provided for @security.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @notificationSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt thông báo'**
  String get notificationSettings;

  /// No description provided for @helpAndFAQ.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ và FAQ'**
  String get helpAndFAQ;

  /// No description provided for @notificationTypes.
  ///
  /// In vi, this message translates to:
  /// **'Loại thông báo'**
  String get notificationTypes;

  /// No description provided for @studyReminders.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở học tập'**
  String get studyReminders;

  /// No description provided for @studyRemindersDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhận thông báo nhắc nhở học từ vựng hàng ngày'**
  String get studyRemindersDesc;

  /// No description provided for @achievementNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thành tích'**
  String get achievementNotifications;

  /// No description provided for @achievementNotificationsDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo khi đạt được thành tích mới'**
  String get achievementNotificationsDesc;

  /// No description provided for @weeklyProgress.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo tiến độ'**
  String get weeklyProgress;

  /// No description provided for @weeklyProgressDesc.
  ///
  /// In vi, this message translates to:
  /// **'Tóm tắt tiến độ học tập hàng tuần'**
  String get weeklyProgressDesc;

  /// No description provided for @notificationBehavior.
  ///
  /// In vi, this message translates to:
  /// **'Hành vi thông báo'**
  String get notificationBehavior;

  /// No description provided for @sound.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh'**
  String get sound;

  /// No description provided for @soundDesc.
  ///
  /// In vi, this message translates to:
  /// **'Phát âm thanh khi có thông báo'**
  String get soundDesc;

  /// No description provided for @vibration.
  ///
  /// In vi, this message translates to:
  /// **'Rung'**
  String get vibration;

  /// No description provided for @vibrationDesc.
  ///
  /// In vi, this message translates to:
  /// **'Rung thiết bị khi có thông báo'**
  String get vibrationDesc;

  /// No description provided for @reminderTime.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian nhắc nhở'**
  String get reminderTime;

  /// No description provided for @studyReminderTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc nhở học tập'**
  String get studyReminderTime;

  /// No description provided for @dailyAt.
  ///
  /// In vi, this message translates to:
  /// **'20:00 hàng ngày'**
  String get dailyAt;

  /// No description provided for @languageSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt ngôn ngữ'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get selectLanguage;

  /// No description provided for @changeLanguageDesc.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi ngôn ngữ hiển thị của ứng dụng'**
  String get changeLanguageDesc;

  /// No description provided for @currentLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ hiện tại'**
  String get currentLanguage;

  /// No description provided for @availableLanguages.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ có sẵn'**
  String get availableLanguages;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In vi, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @japanese.
  ///
  /// In vi, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @korean.
  ///
  /// In vi, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @changeLanguageConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận thay đổi'**
  String get changeLanguageConfirm;

  /// No description provided for @changeLanguageMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn chuyển sang {language}?'**
  String changeLanguageMessage(String language);

  /// No description provided for @languageChanged.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển sang {language}'**
  String languageChanged(String language);

  /// No description provided for @infoNote.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý'**
  String get infoNote;

  /// No description provided for @languageChangeNote.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi ngôn ngữ sẽ áp dụng cho toàn bộ ứng dụng. Một số từ vựng có thể cần thời gian để cập nhật.'**
  String get languageChangeNote;

  /// No description provided for @notificationNote.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo giúp bạn duy trì thói quen học tập đều đặn và đạt được mục tiêu.'**
  String get notificationNote;

  /// No description provided for @joinedSince.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia từ {date}'**
  String joinedSince(String date);

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get error;

  /// No description provided for @success.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In vi, this message translates to:
  /// **'Thất bại'**
  String get failed;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In vi, this message translates to:
  /// **'Lọc'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp'**
  String get sort;

  /// No description provided for @study_reminder.
  ///
  /// In vi, this message translates to:
  /// **'Lịch học'**
  String get study_reminder;

  /// No description provided for @study_reminder_title.
  ///
  /// In vi, this message translates to:
  /// **'Lịch nhắc nhở của bạn'**
  String get study_reminder_title;

  /// No description provided for @add_reminder.
  ///
  /// In vi, this message translates to:
  /// **'Thêm lịch nhắc nhở mới'**
  String get add_reminder;

  /// No description provided for @reminder_title.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get reminder_title;

  /// No description provided for @reminder_description.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get reminder_description;

  /// No description provided for @select_time.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thời gian'**
  String get select_time;

  /// No description provided for @time.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian: {time}'**
  String time(String time);

  /// No description provided for @repeat_daily.
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại hàng ngày'**
  String get repeat_daily;

  /// No description provided for @add_reminder_button.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhắc nhở'**
  String get add_reminder_button;

  /// No description provided for @reminder_added.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm lịch nhắc nhở thành công'**
  String get reminder_added;

  /// No description provided for @please_enter_title.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tiêu đề'**
  String get please_enter_title;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
