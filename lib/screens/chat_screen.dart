import 'package:flutter/material.dart';
import 'package:uplifty/utils/colors.dart';

class ChatScrreen extends StatelessWidget {
  const ChatScrreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: CColors.background,
      body: const Center(
        child: Text(
          "chat screen",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
