import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uplifty/utils/check_user.dart';
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
      CheckUser.isLoggedin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      body: Center(child: Image.asset("assets/images/logo.png")),
    );
  }
}
