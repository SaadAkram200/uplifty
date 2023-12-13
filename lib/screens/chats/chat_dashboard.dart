import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uplifty/screens/friends/myfriends_screen.dart';
import 'package:uplifty/utils/colors.dart';

class ChatDashboard extends StatelessWidget {
  const ChatDashboard({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //page title 
                Opacity(
                  opacity: 0,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconlyLight.plus,
                        color: CColors.secondary,
                        size: 28,
                      )),
                ),
                Text(
                  "Chats",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CColors.primary),
                ),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (context) {
                          return MyFriends();
                        },
                      );
                    },
                    icon: Icon(
                      IconlyLight.plus,
                      color: CColors.secondary,
                      size: 28,
                    )),
              ],
            ),
            Divider(color: CColors.primary),
          ],
        ),
      )),
    );
  }
}
