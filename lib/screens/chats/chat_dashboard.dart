import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/friends/myfriends_screen.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/reusables.dart';

class ChatDashboard extends StatelessWidget {
  const ChatDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
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
                   // page title
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
                              return MyFriends(
                                isComingfromChatD: true,
                              );
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
                Expanded(
                    child: value.userData!.chatwith!.isEmpty
                     ? Text(
                        "No chats yet...", 
                        style: TextStyle(color: CColors.secondary, fontSize: 20))
                     : ListView.builder(
                  itemCount: value.userData?.chatwith?.length,
                  itemBuilder: (context, index) {
                    return ChatDashboardTile(value: value, index: index);
                  },
                ),
               ),
              ],
            ),
          )),
        );
      },
    );
  }
}
