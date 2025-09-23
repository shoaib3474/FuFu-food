// ignore_for_file: empty_catches, unnecessary_new, prefer_const_constructors, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages, unnecessary_null_comparison, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../app/data/model/body/notification_body.dart';
import '../app/data/model/body/payload_model.dart';
import '../app/modules/order/controllers/order_controller.dart';
import '../app/modules/order/views/order_view.dart';

class NotificationHelper {
  void notificationPermission() async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("✅ User granted permission");
    } else {
      debugPrint("❌ User denied permission");
    }
  }

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (payload) async {
      try {
        if (payload.payload != null && payload.payload!.isNotEmpty) {
          PayLoadBody payLoadBody =
              PayLoadBody.fromJson(jsonDecode(payload.payload!));
          if (payLoadBody.topicName == 'Order Notification') {
            Get.to(() => OrderView());
          }
        }
      } catch (e) {}
      return;
    });

    /// Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_isValidNotification(message)) {
        NotificationHelper.showNotification(
            message, flutterLocalNotificationsPlugin, false);

        var orderController = Get.put(OrderController());
        orderController.orderNotificationId.value =
            message.data["order_id"].toString();
        orderController.orderNotfyLoader.value =
            message.data["order_id"].toString().isNotEmpty;

        try {
          NotificationBody _notificationBody =
              convertNotification(message.data);
          if (_notificationBody.topic == 'Order Notification') {
            Get.to(() => OrderView());
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });

    /// When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null &&
          message.data.isNotEmpty &&
          _isValidNotification(message)) {
        try {
          NotificationBody _notificationBody =
              convertNotification(message.data);
          if (_notificationBody.topic == 'Order Notification') {
            Get.to(() => OrderView());
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  /// 🔒 Only show notification if it contains order_id
  static bool _isValidNotification(RemoteMessage message) {
    return message.data.containsKey("order_id") &&
        message.data["order_id"].toString().isNotEmpty;
  }

  static Future<void> showNotification(RemoteMessage message,
      FlutterLocalNotificationsPlugin fln, bool data) async {
    if (!GetPlatform.isIOS) {
      String? _title;
      String? _body;
      String? _image;
      String playLoad = jsonEncode(message.data);

      if (data) {
        _title = message.data['title'];
        _body = message.data['body'];
        _image = message.data['image'];
      } else {
        _title = message.notification?.title ?? message.data['title'];
        _body = message.notification?.body ?? message.data['body'];
        _image = message.data['image'];
      }

      if (_image != null && _image.isNotEmpty) {
        try {
          await showBigPictureNotificationHiddenLargeIcon(
              _title!, _body!, playLoad, _image, fln);
        } catch (e) {
          await showBigTextNotification(_title!, _body!, playLoad, '', fln);
        }
      } else {
        await showBigTextNotification(_title!, _body!, playLoad, '', fln);
      }
    }
  }

  static Future<void> showBigTextNotification(String title, String body,
      String payload, String image, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Random.secure().nextInt(10000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.max,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(1, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      String title,
      String body,
      String payload,
      String image,
      FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath =
        await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Random.secure().nextInt(10000).toString(),
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.max,
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(1, title, body, platformChannelSpecifics, payload: payload);
  }

  static NotificationBody convertNotification(Map<String, dynamic> data) {
    return NotificationBody.fromJson(data);
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

/// Background FCM handler
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  if (message.data.containsKey("order_id") &&
      message.data["order_id"].toString().isNotEmpty) {
    var androidInitialize = AndroidInitializationSettings('notification_icon');
    var iOSInitialize = DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    await NotificationHelper.showNotification(
        message, flutterLocalNotificationsPlugin, true);
  }
}
