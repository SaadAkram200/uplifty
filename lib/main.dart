import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/firebase_options.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(create: (_)=> DataProvider(),),
        ChangeNotifierProvider<FunctionsProvider>(create: (_)=> FunctionsProvider(),)
        ],
      child: const MainApp()));
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
