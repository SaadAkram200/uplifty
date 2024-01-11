import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/firebase_options.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/screens/splash_screen.dart';
import 'package:provider/provider.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


Future<void> myBackgroundMessageHandler(RemoteMessage message) async {

  String type = message.data['type'];
  
  if (type == 'call') {
    // String receiverID = message.data['receiverID'];
  // String callerID = message.data['callerID'];
  String callerName = message.data['callerName'];
  // bool isVideoCall = message.data['isVideoCall'];

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'call_channel',
        title: "incomming call",
        body: callerName,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
          color: Colors.green,
          autoDismissible: false,
          actionType: ActionType.Default,
          //   // Navigate to the call screen
          //   // Navigator.push(context, MaterialPageRoute(builder: (context) => AudioVideoCall(...)));
          // },
        ),
        NotificationActionButton(
          key: 'reject',
          label: 'Reject',
          autoDismissible: false,
          color: Colors.red,
          actionType: ActionType.Default,
     
        ),
      ],
    
    );
  } else if (type == 'message') {
     AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'call_channel',
      title: message.notification!.title,
      body: message.data['body'],
    ),
  );

  
  }

  // Add your custom logic here to handle the background message.


}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: "call_channel",
      channelName: "call channel",
      channelDescription: "channel for calling",
      defaultColor: Colors.redAccent,
      defaultRingtoneType: DefaultRingtoneType.Ringtone,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      channelShowBadge: true,
      locked: true,
    )
  ]);

  await firebaseMessaging.requestPermission();

  //configureFCM();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<DataProvider>(
      create: (_) => DataProvider(),
    ),
    ChangeNotifierProvider<FunctionsProvider>(
      create: (_) => FunctionsProvider(),
    )
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
