import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:manage_life_app/models/notification_model.dart';
import 'package:manage_life_app/providers/helpers/database_helper.dart';
import 'package:manage_life_app/providers/network/local/cache_helper.dart';
import 'package:manage_life_app/providers/task_bloc/task_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationAPI {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'Channel id',
        'Channel name',
        channelDescription: 'Channel description',
        importance: Importance.max,
        playSound: false,
        // sound: AndroidNotificationSound('slow_spring_board'),
      ),
      iOS: IOSNotificationDetails(),
    
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final ios = IOSInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      }
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async => 
    _notification.show(
      id,
      title, 
      body, 
      await _notificationDetails(),
      payload: payload,
      );

  static Future showScheduleNotification(context, {
    int id = 0,
    String? title,
    String? body,
    String? tag_notification,
    DateTime? startScheduleDate,
    DateTime? endScheduleDate,
    String? start_time,
    String? end_time,
    String? payload,
    bool remindeForDeadline = false,
  }) async => 
    _notification.zonedSchedule(
      id,
      title, 
      body, 
      tz.TZDateTime.from(remindeForDeadline ? endScheduleDate! : startScheduleDate!, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      // matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime // Weekly
  ).then((value) {
    
    var isLoginWith = CacheHelper.getData(key: "isLoginWith");
    var username = "Guest";

    if(isLoginWith == "Google") {
      username = FirebaseAuth.instance.currentUser!.displayName!;
    } else if (isLoginWith == "fb") {
      username = CacheHelper.getData(key: "userFBName");
    } else if (isLoginWith == "Twitter") {
      username = CacheHelper.getData(key: "userTwitterName");
    } else if (isLoginWith == "Native_email") {
      username = "username";
    }
    if(remindeForDeadline) {
      // Timer(endScheduleDate!.difference(DateTime.now().subtract(Duration(minutes: 30))), () => TaskCubit().speak(context, "هناك مهمة يجب عليك الإنتهاء منها بعد الأن بنصف ساعة"));
      Timer(endScheduleDate!.difference(DateTime.now()), () => TaskCubit().speak(context, "هناك مهمة يجب عليك الإنتهاء منها بعد الأن بنصف ساعة"));
    } else {
      Timer(startScheduleDate!.difference(DateTime.now()), () => TaskCubit().speak(context, "My ${username != "Guest" ? "Friend" : ""} ${username} You must start this task now."));
    }
  });


  // static tz.TZDateTime _scheduleWeekly(Time time, {required List<int> days}) {
  //   tz.TZDateTime scheduledDate = _scheduleDaily(time);

  //   while(!days.contains(scheduledDate.weekday)) {
  //     scheduledDate = scheduledDate.add(Duration(days: 1)); 
  //   }

  //   return scheduledDate;
  // }


}