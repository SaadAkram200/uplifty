import 'package:flutter/material.dart';
import 'package:uplifty/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: CColors.background,
      body: const Center(
        child: Text(
          "News Feed here",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
