// lib/services/fcm_notification_handler.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📬 Background message: ${message.messageId}');
  print('   Data: ${message.data}');

  if (message.data['type'] == 'telemedicine_call') {
    await FCMNotificationHandler.showCallNotification(message);
  }
}

class FCMNotificationHandler {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Function(Map<String, dynamic>)? onCallNotificationTapped;

  // ✅ NEW: Callback for foreground calls
  static Function(Map<String, dynamic>)? onForegroundCallReceived;

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'telemedicine_calls',
      'Telemedicine Calls',
      description: 'Incoming video call notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    // Check if app was opened from a notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }

    print('✅ FCM Notification Handler initialized');
  }

  // ✅ FIXED: Actually handle foreground calls
  static void _handleForegroundMessage(RemoteMessage message) {
    print('📬 Foreground message: ${message.messageId}');
    print('   Data: ${message.data}');

    if (message.data['type'] == 'telemedicine_call') {
      print('📞 Incoming call detected via FCM - showing call screen');

      // ✅ Convert to proper map and trigger callback
      final callData = Map<String, dynamic>.from(message.data);

      // Add signalId if not present
      if (!callData.containsKey('signalId') &&
          callData.containsKey('signalId')) {
        callData['signalId'] = callData['signalId'];
      }

      // ✅ Trigger the foreground call callback
      onForegroundCallReceived?.call(callData);
    }
  }

  static void _handleNotificationOpen(RemoteMessage message) {
    print('📬 Notification opened: ${message.messageId}');
    print('   Data: ${message.data}');

    if (message.data['type'] == 'telemedicine_call') {
      onCallNotificationTapped?.call(Map<String, dynamic>.from(message.data));
    }
  }

  static void _onNotificationTap(NotificationResponse response) {
    print('📬 Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        if (data['type'] == 'telemedicine_call') {
          onCallNotificationTapped?.call(Map<String, dynamic>.from(data));
        }
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  static Future<void> showCallNotification(RemoteMessage message) async {
    final data = message.data;

    final callerName = data['patientName'] ?? data['doctorName'] ?? 'Someone';

    const androidDetails = AndroidNotificationDetails(
      'telemedicine_calls',
      'Telemedicine Calls',
      channelDescription: 'Incoming video call notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.call,
      visibility: NotificationVisibility.public,
      autoCancel: false,
      ongoing: true,
      playSound: true,
      enableVibration: true,
      actions: [
        AndroidNotificationAction(
          'decline',
          'Decline',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'accept',
          'Accept',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      message.hashCode,
      'Incoming Call',
      '$callerName is calling...',
      details,
      payload: jsonEncode(data),
    );
  }

  static Future<void> cancelCallNotification(String signalId) async {
    await _notifications.cancel(signalId.hashCode);
  }
}
