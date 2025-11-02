import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {},
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
            // Handle notification taps here
          },
    );
  }

  Future<void> scheduleStudyReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required bool isRepeating,
    String? payload,
  }) async {
    var androidDetails = const AndroidNotificationDetails(
      'study_reminder_channel',
      'Lịch học',
      channelDescription: 'Thông báo nhắc nhở lịch học',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    var iOSDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    if (isRepeating) {
      // Schedule daily notification at the same time
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(scheduledDate),
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    } else {
      // One-time notification
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime scheduledDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduledTZDate.isBefore(now)) {
      scheduledTZDate = scheduledTZDate.add(const Duration(days: 1));
    }
    return scheduledTZDate;
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
