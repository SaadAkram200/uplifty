import 'package:flutter/material.dart';
import 'package:uplifty/utils/colors.dart';

class ChatScrreen extends StatelessWidget {
  const ChatScrreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            //page title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Chats",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: CColors.primary),
              ),
            ),
            Divider(color: CColors.primary),
          ],
        ),
      )),
    );
  }
}
