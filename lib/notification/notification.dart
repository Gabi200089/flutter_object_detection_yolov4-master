import 'package:object_detection/global.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/notification/notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  int hour = 0;
  int minute = 0;
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  // String hour=getText({this.hours});
  // String minute = '';

  Future getTime() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('dailyNotification');
    await documentReference.get().then((DocumentSnapshot doc) async{
      hour = int.parse(doc['hour']);
      minute = int.parse(doc['minute']);
    });
    print(user_email);
    print('hour:'+hour.toString()+'minute:'+minute.toString());
  }
  static Future _notificationDetails() async{
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    // final largeIconPath = await Utils.downloadFile(),

    // final StyleInformation = BigPictureStyleInformation(    //add icon
    //   FilePathAndroidBitmap("healthylogo"),
    //   largeIcon: FilePathAndroidBitmap('healthylogo'),
    // );
    final sound = 'notification.wav';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        'channelDescription',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: false,
        // icon: "smile_icon",
        largeIcon: DrawableResourceAndroidBitmap('healthylogo'),
        // styleInformation: StyleInformation,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
  static Future init({bool initScheduled = false}) async{
    final android = AndroidInitializationSettings('@mipmap/healthylogo');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    //when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
    if(initScheduled){
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async {
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload:payload,
    );
  }   //1.32 &&6.30

  Future showScheduledNotification({ //daily notifications
    int id = 0,
    String title,
    String body,
    String payload,
    DateTime scheduledDate,

  }) async {
    // getTime();

    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('dailyNotification');
    await documentReference.get().then((DocumentSnapshot doc) async{
      hour = int.parse(doc['hour']);
      minute = int.parse(doc['minute']);
    });
    print(user_email);
    print('hour:'+hour.toString()+'minute:'+minute.toString());


    _notifications.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.from(scheduledDate, tz.local),

      _scheduleDaily(Time(hour,minute)),//,00
      await _notificationDetails(),
      payload:payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future showScheduledNotification1({ //daily notifications
    int id = 1,
    String title,
    String body,
    String payload,
    DateTime scheduledDate,

  }) async {
    // getTime();

    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('dailyNotification');
    await documentReference.get().then((DocumentSnapshot doc) async{
      hour = int.parse(doc['hour']);
      minute = int.parse(doc['minute']);
    });
    print(user_email);
    print('hour:'+hour.toString()+'minute:'+minute.toString());


    _notifications.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.from(scheduledDate, tz.local),

      _scheduleDaily(Time(hour,minute)),//,00
      await _notificationDetails(),
      payload:payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }


  static tz.TZDateTime _scheduleDaily(Time time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);//, time.second
    print("now:"+scheduledDate.toString());
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;

  }
  Future cancelNotification()
  {
    _notifications.cancel(0);
    _notifications.cancel(1);
  }
}