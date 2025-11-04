// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'WordMaster';

  @override
  String get home => '首页';

  @override
  String get decks => '卡片组';

  @override
  String get quiz => '测验';

  @override
  String get progress => '进度';

  @override
  String get profile => '个人资料';

  @override
  String get welcomeBack => '欢迎使用 WordMaster！';

  @override
  String get welcomeMessage => '登录以管理您的个人资料并跟踪您的成就';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get createAccount => '创建新账户';

  @override
  String get logout => '退出登录';

  @override
  String get confirmLogout => '确认退出';

  @override
  String get confirmLogoutMessage => '确定要退出登录吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get language => '语言';

  @override
  String get darkMode => '深色模式';

  @override
  String get help => '帮助';

  @override
  String get about => '关于';

  @override
  String level(int level) {
    return '等级 $level';
  }

  @override
  String get progress_text => '进度';

  @override
  String get currentPoints => '当前积分';

  @override
  String get nextLevel => '下一等级';

  @override
  String get totalLearned => '已学习卡片';

  @override
  String get mastered => '已掌握';

  @override
  String get streak => '连续记录';

  @override
  String get days => '天';

  @override
  String highestStreak(int days) {
    return '最高: $days';
  }

  @override
  String get flashcards => '单词卡组';

  @override
  String get quizCompleted => '已完成测验';

  @override
  String get streakDays => '连续天数';

  @override
  String get achievements => '主要成就';

  @override
  String get viewAll => '查看全部';

  @override
  String get noAchievements => '尚无成就';

  @override
  String get loading => '加载中...';

  @override
  String get loadingData => '正在加载数据...';

  @override
  String get unlocked => '已解锁';

  @override
  String get locked => '未解锁';

  @override
  String get recentActivities => '最近活动';

  @override
  String get noActivities => '尚无活动';

  @override
  String get quickSettings => '快速设置';

  @override
  String get security => '安全';

  @override
  String get changePassword => '修改密码';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get helpAndFAQ => '帮助与常见问题';

  @override
  String get notificationTypes => '通知类型';

  @override
  String get studyReminders => '学习提醒';

  @override
  String get studyRemindersDesc => '接收每日学习提醒';

  @override
  String get achievementNotifications => '成就';

  @override
  String get achievementNotificationsDesc => '解锁新成就时通知';

  @override
  String get weeklyProgress => '进度报告';

  @override
  String get weeklyProgressDesc => '每周学习进度摘要';

  @override
  String get notificationBehavior => '通知行为';

  @override
  String get sound => '声音';

  @override
  String get soundDesc => '通知时播放声音';

  @override
  String get vibration => '振动';

  @override
  String get vibrationDesc => '通知时振动设备';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get studyReminderTime => '学习提醒时间';

  @override
  String get dailyAt => '每日晚上8点';

  @override
  String get languageSettings => '语言设置';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get changeLanguageDesc => '更改应用显示语言';

  @override
  String get currentLanguage => '当前语言';

  @override
  String get availableLanguages => '可用语言';

  @override
  String get vietnamese => '越南语';

  @override
  String get english => '英语';

  @override
  String get chinese => '中文';

  @override
  String get japanese => '日语';

  @override
  String get korean => '韩语';

  @override
  String get changeLanguageConfirm => '确认更改';

  @override
  String changeLanguageMessage(String language) {
    return '是否切换至$language？';
  }

  @override
  String languageChanged(String language) {
    return '已切换至$language';
  }

  @override
  String get infoNote => '注意';

  @override
  String get languageChangeNote => '语言更改将应用于整个应用。部分词汇可能需要时间更新。';

  @override
  String get notificationNote => '通知有助于保持学习习惯并实现目标。';

  @override
  String joinedSince(String date) {
    return '自$date成为会员';
  }

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get failed => '失败';

  @override
  String get retry => '重试';

  @override
  String get close => '关闭';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get add => '添加';

  @override
  String get search => '搜索';

  @override
  String get filter => '筛选';

  @override
  String get sort => '排序';

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
