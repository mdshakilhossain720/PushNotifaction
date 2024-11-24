import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pushnotifaction/message_screen.dart';

class NotifactionServices{
  FirebaseMessaging  messaging =FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  Future<void> InitLocalNotifaction(BuildContext contetx, RemoteMessage message) async {
    var androidInitializationSettings=AndroidInitializationSettings('@mipmap/ic_launcher.png');
    var iosInitializationSettings=DarwinInitializationSettings();
    var initializationSettings=InitializationSettings(
      android:androidInitializationSettings,
      iOS: iosInitializationSettings,

    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload){
        handleMessage(contetx,message);

      }
    );

  }



  void firbaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message){

      // if(kDebugMode){
      //   print(message)
      // }
      if(Platform.isAndroid){
        InitLocalNotifaction(context,message);
        showNotifaction(message);
      }else{
        showNotifaction(message);
      }






    });
  }

  void showNotifaction(RemoteMessage message){

    AndroidNotificationChannel channel= AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        'High Importance Notifaction',
      importance: Importance.max,
    );


    AndroidNotificationDetails androidNotifactionDetails=AndroidNotificationDetails(
      channel.id.toString(),
        channel.name.toString(),
      channelDescription: 'Notifaction describtion',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',



    );

    DarwinNotificationDetails darwinNotificationDetails=DarwinNotificationDetails(
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails=NotificationDetails(
      android: androidNotifactionDetails,
      iOS: darwinNotificationDetails,
    );





   Future.delayed(Duration.zero,(){
    _flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title.toString(),
   message.notification!.body.toString(),
    notificationDetails);

   }


   );

  }




  void requestMessageingPermission() async {
    NotificationSettings settings =await messaging.requestPermission(
      alert: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true

    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');

    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User Ungranted permission');

    }else{
      print('User not granted permission');

    }






  }




  Future<void> getDeviceToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission for notifications (iOS only).
      NotificationSettings settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      }

      // Get the device token.
      String? token = await messaging.getToken();
      if (token != null) {
        print("FCM Token: $token"); // Print the device token
      } else {
        print("Failed to get FCM token");
      }
    } catch (e) {
      print("Error fetching FCM token: $e");
    }
  }


  void  handleMessage(BuildContext context,RemoteMessage message){
    if(message.data['type'] == 'msg'){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>MessageScreen()));

    }
  }

  Future<void> setupInterMessage(BuildContext context) async {
    RemoteMessage? initzationMessage=await FirebaseMessaging.instance.getInitialMessage();
    if(initzationMessage !=null){
      handleMessage(context, initzationMessage);

    }

    // backgroun messaging

    FirebaseMessaging.onMessageOpenedApp.listen((events){
      handleMessage(context, events);

    });
  }




}