class ReminderStrings {
  static final ReminderStrings _instance = ReminderStrings._internal();
  factory ReminderStrings() => _instance;
  ReminderStrings._internal();

  // Tiếng Việt
  String get screenTitle => 'Lịch học';
  String get yourReminders => 'Lịch nhắc nhở của bạn';
  String get addNewReminder => 'Thêm lịch nhắc nhở mới';
  String get titleHint => 'Tiêu đề';
  String get descriptionHint => 'Mô tả';
  String get selectTime => 'Chọn thời gian';
  String get time => 'Thời gian';
  String getTime(String time) => 'Thời gian: $time';
  String get repeatDaily => 'Lặp lại hàng ngày';
  String get addReminder => 'Thêm nhắc nhở';
  String get pleaseEnterTitle => 'Vui lòng nhập tiêu đề';
  String get reminderAddedSuccess => 'Đã thêm lịch nhắc nhở thành công';

  // Notification strings
  String get reminderChannelName => 'Lịch học';
  String get reminderChannelDescription => 'Thông báo nhắc nhở lịch học';
}
