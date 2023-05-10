import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';



import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lovebug/firebase_options.dart';
import 'package:lovebug/presentation/screens/auth_screen.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async   {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(), htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(), htmlFormatContent: true
  );
  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'dbfood', 'dbfood', importance: Importance.high,
      styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true
  );
  NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, notificationDetails, payload: message.data['title']);
}

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: SafeArea(child: const AuthPage()),
  ));
}

