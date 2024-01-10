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

Future<void> backgroundHandler(RemoteMessage message)async{
  
}

 void configureFCM() {
  
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("onMessage: $message");
  handleMessage(message.data);
});



FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print("onResume: $message");
  handleMessage(message.data);
});

  }

   void handleMessage(Map<String, dynamic> message) {
    String messageType = message['data']['type'];

    if (messageType == 'message') {
      showSimpleNotification(message['notification']['title'], message['notification']['body']);
    } else if (messageType == 'call') {
      showCallNotification(
        message['notification']['title'],
        message['notification']['body'],
        message['data']['callerID'],
        message['data']['callerName'],
        message['data']['isVideoCall'] == 'true',
      );
    }
  }

   void showSimpleNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }

   void showCallNotification(String title, String body, String callerID, String callerName, bool isVideoCall) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'call_channel',
        title: title,
        body: body,
        displayOnForeground: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
          color: Colors.green,
          autoDismissible: true,
          actionType: ActionType.Default,
          // callback: (notification) {
          //   // Handle accept call action
          //   print('Accepted call from $callerName');
          //   // Navigate to the call screen
          //   // Navigator.push(context, MaterialPageRoute(builder: (context) => AudioVideoCall(...)));
          // },
        ),
        NotificationActionButton(
          key: 'reject',
          label: 'Reject',
          autoDismissible: true,
          actionType: ActionType.Default,
          
          // callback: (notification) {
          //   // Handle reject call action
          //   print('Rejected call from $callerName');
          //   // Dismiss the notification
          //   AwesomeNotifications().dismiss(2);
          // },
        ),
      ],
    );
  }

  Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("Handling background message: ${message.data}");

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'call_channel',
        title: "incomming call",
        body: message.from,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
          color: Colors.green,
          autoDismissible: false,
          actionType: ActionType.Default,
          // callback: (notification) {
          //   // Handle accept call action
          //   print('Accepted call from $callerName');
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
          // callback: (notification) {
          //   // Handle reject call action
          //   print('Rejected call from $callerName');
          //   // Dismiss the notification
          //   AwesomeNotifications().dismiss(2);
          // },
        ),],
    );
  
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
        locked: true,)
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
