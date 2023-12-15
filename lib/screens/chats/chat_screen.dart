// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/chat_provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class ChatScreen extends StatelessWidget {
  String friendID;
  ChatScreen({super.key, required this.friendID});

  TextEditingController messageController = TextEditingController();

  //bottomsheet for attachments- used in message textfield
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
                onTap: () {}, buttonName: "Audio", icon: IconlyLight.voice),
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

//builds chat for users
  chatBuilder(DataProvider value) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (context) => ChatProvider(value.userData!.id, friendID),
      child: Consumer<ChatProvider>(
        builder: (context, value1, child) {
          return value1.chatList!.isEmpty
              ? Text(
                  "Say Hi to ${value.getPosterData(friendID)!.username}",
                  style: TextStyle(color: CColors.secondary, fontSize: 20),
                )
              : ListView.builder(
                  reverse: true,
                  itemCount: value1.chatList?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Align(
                        alignment: value1.chatList?[index].senderID ==
                                value.userData!.id
                            ? Alignment.topRight // Sender's message alignment
                            : Alignment.topLeft, // Receiver's message alignment
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: value1.chatList?[index].senderID ==
                                    value.userData!.id
                                ? CColors.secondary
                                : CColors.bottomAppBarcolor,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 8.0, right: 8, bottom: 2),
                                child: Text(
                                  value1.chatList![index].messageText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: value1.chatList?[index].senderID ==
                                            value.userData!.id
                                        ? Colors.white
                                        : CColors.secondarydark,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 8.0, right: 8),
                                child: Text(
                                  DateFormat('hh:mm a').format(
                                      value1.chatList![index].timestamp),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: value1.chatList?[index].senderID ==
                                              value.userData!.id
                                          ? Colors.white70
                                          : CColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
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
              mainAxisSize: MainAxisSize.min,
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

                //user's chat
                Expanded(child: chatBuilder(value)),

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
                          suffixIcon: IconlyLight.send,
                          suffixIconOnpressed: () {
                            Functions.startChatting(value.userData!.id,
                                    friendID, messageController)
                                .then((value) {
                              messageController.clear();
                            });
                          },
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
