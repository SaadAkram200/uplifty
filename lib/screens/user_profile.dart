// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/chats/chat_screen.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class UserProfile extends StatelessWidget {
  String friendID;
  UserProfile({
    super.key,
    required this.friendID,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: CColors.background,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                PageName(
                  pageName: value.getPosterData(friendID)!.username,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(color: CColors.primary),
                //profile details
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatar(
                    radius: 72,
                    backgroundColor: CColors.secondary,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          value.getPosterData(friendID)!.image as String),
                      child: null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Email: ${value.getPosterData(friendID)!.email}',
                    style: TextStyle(color: CColors.secondary, fontSize: 16),
                  ),
                ),
                Text(
                  'Contact: ${value.getPosterData(friendID)!.phone}',
                  style: TextStyle(color: CColors.secondary, fontSize: 16),
                ),
                //start a chat button
                TextButton(
                    onPressed: () {
                      Functions.initiateChat(value.userData!.id, friendID);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatScreen(friendID: friendID),
                          ),
                          (route) => true);
                    },
                    child: Text(
                      "Start a Chat",
                      style: TextStyle(color: CColors.primary, fontSize: 18),
                    )),
                Divider(color: CColors.primary),
              ],
            ),
          )),
        );
      },
    );
  }
}
