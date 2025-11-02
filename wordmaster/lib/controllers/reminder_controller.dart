import 'package:flutter/material.dart';
import '../models/study_reminder.dart';
import '../services/notification_service.dart';

class ReminderController extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<StudyReminder> _reminders = [];

  List<StudyReminder> get reminders => _reminders;

  Future<void> addReminder(StudyReminder reminder) async {
    // Schedule the notification
    await _notificationService.scheduleStudyReminder(
      id: reminder.id,
      title: reminder.title,
      body: reminder.description,
      scheduledDate: reminder.scheduledTime,
      isRepeating: reminder.isRepeating,
      payload: reminder.id.toString(),
    );

    _reminders.add(reminder);
    notifyListeners();

    // TODO: Sync with backend
  }

  Future<void> removeReminder(int reminderId) async {
    await _notificationService.cancelNotification(reminderId);
    _reminders.removeWhere((reminder) => reminder.id == reminderId);
    notifyListeners();

    // TODO: Sync with backend
  }

  Future<void> updateReminder(StudyReminder updatedReminder) async {
    // Cancel existing notification
    await _notificationService.cancelNotification(updatedReminder.id);

    // Schedule new notification
    await _notificationService.scheduleStudyReminder(
      id: updatedReminder.id,
      title: updatedReminder.title,
      body: updatedReminder.description,
      scheduledDate: updatedReminder.scheduledTime,
      isRepeating: updatedReminder.isRepeating,
      payload: updatedReminder.id.toString(),
    );

    // Update in local list
    final index = _reminders.indexWhere(
      (reminder) => reminder.id == updatedReminder.id,
    );
    if (index != -1) {
      _reminders[index] = updatedReminder;
      notifyListeners();
    }

    // TODO: Sync with backend
  }

  Future<void> loadReminders(int userId) async {
    // TODO: Load from backend
    notifyListeners();
  }
}
