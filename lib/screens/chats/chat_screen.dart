// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/chat_provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class ChatScreen extends StatelessWidget {
  String friendID;
  ChatScreen({super.key, required this.friendID});

  TextEditingController messageController = TextEditingController();

  //bottomsheet for attachments- used in message textfield
  attachmentsBottomSheet(context, DataProvider value1) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: CColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return Consumer<FunctionsProvider>(builder: (context, value, child) {
         return value.selectedImage != null // for selecting photo/video
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: (){
                  value.selectedImage= null;
                  }, 
                icon: Icon(Icons.cancel_outlined, color: CColors.secondary,)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CColors.primary)
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.width * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,),
                child:Image(image: FileImage(File(value.selectedImage!.path))),),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  child: SignButton(buttonName: "Share", onPressed: (){
                    Functions.sendImage(value1.uid, friendID, value.selectedImage)
                    .then((v) {
                      value.selectedImage=null;
                      Navigator.pop(context);
                     });
                  }),
                ),
            ],
          )
          : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SettingsButton(
                onTap: () {}, buttonName: "Audio", icon: IconlyLight.voice),
            SettingsButton(
                onTap: () {
                  value.imagePicker(false);
                  }, buttonName: "Camera", icon: IconlyLight.camera),
            SettingsButton(
                onTap: () {
                  value.imagePicker(true);
                },
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
        },);
      },
    );
  }

//builds chat for users
  chatBuilder(DataProvider value) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (context) => ChatProvider(value.uid, friendID),
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
                    // if (value1.chatList?[index].type == "image") {
                    //   return Column(

                    //     children: [
                    //       Container(
                    //         decoration: BoxDecoration(
                    //           border: Border.all(color: CColors.primary)
                    //         ),
                    //         constraints: BoxConstraints(
                    //           maxHeight: MediaQuery.of(context).size.width * 0.8,
                    //           maxWidth: MediaQuery.of(context).size.width * 0.4,),
                    //         child: Image.asset("assets/images/DSC00575.jpg"),),
                    //     ],
                    //   );
                    // }
                    
                      return Align(
                      alignment: value1.chatList?[index].senderID ==
                              value.uid
                          ? Alignment.topRight // Sender's message alignment
                          : Alignment.topLeft, // Receiver's message alignment
                      child: Container(
                        padding: const EdgeInsets.only(top: 12,right: 12,left: 12,bottom: 4),
                        margin: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                          maxWidth: 250,
                          minWidth: 0
                          ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: value1.chatList?[index].senderID ==
                                  value.uid
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
                          mainAxisSize: MainAxisSize.min,
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        
                            if(value1.chatList?[index].type == "text")
                            Text(
                              value1.chatList![index].messageText,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: value1.chatList?[index].senderID ==
                                        value.uid
                                    ? Colors.white
                                    : CColors.secondarydark,
                              ),
                            ),

                            if(value1.chatList?[index].type == "image")
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.width * 0.8,
                                maxWidth: MediaQuery.of(context).size.width * 0.4,),
                              child: Image.network(value1.chatList![index].link,fit: BoxFit.fill, ),),
                            ),
                        
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Text(
                                   DateFormat('hh:mm a').format(
                                       value1.chatList![index].timestamp),
                                   style: TextStyle(
                                       fontSize: 12,
                                       color: value1.chatList?[index].senderID ==
                                               value.uid
                                           ? CColors.background
                                           : CColors.primary),
                                 ),
                                 if(value1.chatList?[index].senderID ==value.uid)
                                   value1.chatList![index].isReaded
                                 ? Image.asset("assets/images/seen5.png", scale: 3.2,)
                                 : Image.asset("assets/images/unseen5.png", scale: 3.2,),
                               ],
                             ),
                          ],
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
                const SizedBox(
                  height: 5,
                ),
                Divider(
                  color: CColors.primary,
                  height: 1,
                ),

                //user's chat
                Expanded(child: chatBuilder(value)),

                // messeage textfield
                Divider(
                  color: CColors.primary,
                ),
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
                            attachmentsBottomSheet(context, value);
                          },
                          suffixIcon: IconlyLight.send,
                          suffixIconOnpressed: () {
                            if (messageController.text.isNotEmpty) {
                               Functions.startChatting(
                                    value.uid, friendID, messageController)
                                .then((value) {
                              messageController.clear();
                            });
                            }
                           
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
