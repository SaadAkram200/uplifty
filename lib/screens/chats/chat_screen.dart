// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/reusables.dart';

class ChatScreen extends StatelessWidget {
  String friendID;
  ChatScreen({super.key, required this.friendID});

  TextEditingController messageController = TextEditingController();

  //bottomsheet for attachments
  attachmentsBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: CColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SettingsButton(
                onTap: () {}, buttonName: "Camera", icon: IconlyLight.camera),
            SettingsButton(
                onTap: () {},
                buttonName: "Photo/Video",
                icon: IconlyLight.image),
            SettingsButton(
                onTap: () {},
                buttonName: "Document",
                icon: IconlyLight.document),
            const SizedBox(
              height: 20,
            )
          ]),
        );
      },
    );
  }

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
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          IconlyLight.arrow_left_2,
                          color: CColors.secondary,
                          size: 28,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: CColors.secondary,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            value.getPosterData(friendID)!.image as String),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        value.getPosterData(friendID)!.username,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CColors.primary),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          IconlyLight.video,
                          color: CColors.secondary,
                          size: 28,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          IconlyLight.call,
                          color: CColors.secondary,
                          size: 25,
                        )),
                  ],
                ),
                Divider(color: CColors.primary),
                const Spacer(),

                // messeage textfield
                Divider(color: CColors.primary),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: UpliftyTextfields(
                          controller: messageController,
                          fieldName: "Write a message..",
                          prefixIcon: Icons.add,
                          prefixIconOnpressed: () {
                            attachmentsBottomSheet(context);
                          },
                          suffixIcon: IconlyLight.voice,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
