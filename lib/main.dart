import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/web.dart';
import 'package:yanapa/presentation/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final Logger _logger = Logger();
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  if (message.notification != null) {
    // Handle notification message
    final RemoteNotification notification = message.notification!;
    _logger.d(notification.title);
  }
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(' ================= Got a message whilst in the foreground!');
    print(' ================= Message data: ${message.data}');

    if (message.notification != null) {
      print(
          ' =================  Message also contained a notification: ${message.notification}');
    }
  });
  // cn00bpAhQx-DHOhKsHJXXl:APA91bFH5RuUGVN-1LJjYxmLzMvzExzxJQixXGK6R6COxujiCdqmnN2-y_KiQYc80Op3Zc5kUu3XJG2gDyo-fMvOH9xDmsktN7ItnLOfpPEWlXGi1jYVsiS8oYkEatHygDrTN2F62zII

  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  String? tockenData = await FirebaseMessaging.instance.getToken();
  _logger.i(' tockenData = $tockenData');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yanapa',
      home: SplashScreen(),
    );
  }
}


// ca-app-pub-1819839075312743~6148818134

// ca-app-pub-1819839075312743/9558027211