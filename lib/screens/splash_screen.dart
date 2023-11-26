import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uplifty/screens/login_screen.dart';
import 'package:uplifty/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splashTimer();
    super.initState();
  }
  void splashTimer() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:CColors.background,
      body: Center(
        child: Image.asset("assets/images/logo.png")),);
  }
}