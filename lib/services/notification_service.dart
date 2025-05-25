import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
  }
  
  static Future<void> showBudgetAlert(String category, double spent, double budget) async {
    const androidDetails = AndroidNotificationDetails(
      'budget_alerts',
      'Budget Alerts',
      channelDescription: 'Notifications for budget overspending',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    
    await _notifications.show(
      0,
      'Budget Alert!',
      'You\'ve spent \$${spent.toStringAsFixed(2)} of \$${budget.toStringAsFixed(2)} in $category',
      details,
    );
  }
  
  static Future<void> scheduleBillReminder(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'bill_reminders',
      'Bill Reminders',
      channelDescription: 'Reminders for upcoming bills',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  
  static Future<void> showSavingsGoalAchieved(String goalName, double amount) async {
    const androidDetails = AndroidNotificationDetails(
      'savings_goals',
      'Savings Goals',
      channelDescription: 'Notifications for savings goal achievements',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    
    await _notifications.show(
      1,
      'Goal Achieved! 🎉',
      'Congratulations! You\'ve reached your $goalName goal of \$${amount.toStringAsFixed(2)}',
      details,
    );
  }
}
