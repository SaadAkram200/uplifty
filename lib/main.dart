import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/firebase_options.dart';
import 'package:uplifty/screens/signup_screen2.dart';
import 'package:uplifty/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen2(),
    );
  }
}
