// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'WordMaster';

  @override
  String get home => 'ホーム';

  @override
  String get decks => 'デッキ';

  @override
  String get quiz => 'クイズ';

  @override
  String get progress => '進捗';

  @override
  String get profile => 'プロフィール';

  @override
  String get welcomeBack => 'WordMasterへようこそ！';

  @override
  String get welcomeMessage => 'プロフィール管理と達成状況の追跡にはサインインしてください';

  @override
  String get login => 'ログイン';

  @override
  String get register => '登録';

  @override
  String get createAccount => '新規アカウント作成';

  @override
  String get logout => 'ログアウト';

  @override
  String get confirmLogout => 'ログアウトの確認';

  @override
  String get confirmLogoutMessage => 'ログアウトしますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get settings => '設定';

  @override
  String get notifications => '通知';

  @override
  String get language => '言語';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get help => 'ヘルプ';

  @override
  String get about => 'About';

  @override
  String level(int level) {
    return 'レベル $level';
  }

  @override
  String get progress_text => '進捗';

  @override
  String get currentPoints => '現在のポイント';

  @override
  String get nextLevel => '次のレベル';

  @override
  String get totalLearned => '学習済みカード';

  @override
  String get mastered => 'マスター済み';

  @override
  String get streak => '連続記録';

  @override
  String get days => '日';

  @override
  String highestStreak(int days) {
    return '最高: $days';
  }

  @override
  String get flashcards => '単語カードデッキ';

  @override
  String get quizCompleted => 'クイズ完了';

  @override
  String get streakDays => '連続日数';

  @override
  String get achievements => '主な実績';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get noAchievements => '実績はまだありません';

  @override
  String get loading => '読み込み中...';

  @override
  String get loadingData => 'データを読み込み中...';

  @override
  String get unlocked => 'ロック解除済み';

  @override
  String get locked => 'ロック中';

  @override
  String get recentActivities => '最近の活動';

  @override
  String get noActivities => '活動はまだありません';

  @override
  String get quickSettings => 'クイック設定';

  @override
  String get security => 'セキュリティ';

  @override
  String get changePassword => 'パスワード変更';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get helpAndFAQ => 'ヘルプとFAQ';

  @override
  String get notificationTypes => '通知タイプ';

  @override
  String get studyReminders => '学習リマインダー';

  @override
  String get studyRemindersDesc => '毎日の学習リマインダーを受け取る';

  @override
  String get achievementNotifications => '実績';

  @override
  String get achievementNotificationsDesc => '新しい実績を解除したときに通知';

  @override
  String get weeklyProgress => '進捗レポート';

  @override
  String get weeklyProgressDesc => '週間学習進捗の概要';

  @override
  String get notificationBehavior => '通知動作';

  @override
  String get sound => '音声';

  @override
  String get soundDesc => '通知音を鳴らす';

  @override
  String get vibration => '振動';

  @override
  String get vibrationDesc => '通知でデバイスを振動させる';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String get studyReminderTime => '学習リマインダー時間';

  @override
  String get dailyAt => '毎日20:00';

  @override
  String get languageSettings => '言語設定';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get changeLanguageDesc => 'アプリの表示言語を変更';

  @override
  String get currentLanguage => '現在の言語';

  @override
  String get availableLanguages => '利用可能な言語';

  @override
  String get vietnamese => 'ベトナム語';

  @override
  String get english => '英語';

  @override
  String get chinese => '中国語';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '韓国語';

  @override
  String get changeLanguageConfirm => '変更の確認';

  @override
  String changeLanguageMessage(String language) {
    return '$languageに切り替えますか？';
  }

  @override
  String languageChanged(String language) {
    return '$languageに切り替えました';
  }

  @override
  String get infoNote => '注記';

  @override
  String get languageChangeNote => '言語の変更はアプリ全体に適用されます。一部の語彙は更新に時間がかかる場合があります。';

  @override
  String get notificationNote => '通知は学習習慣を維持し、目標を達成するのに役立ちます。';

  @override
  String joinedSince(String date) {
    return '$dateからメンバー';
  }

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get failed => '失敗';

  @override
  String get retry => '再試行';

  @override
  String get close => '閉じる';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get add => '追加';

  @override
  String get search => '検索';

  @override
  String get filter => 'フィルター';

  @override
  String get sort => '並べ替え';
}
