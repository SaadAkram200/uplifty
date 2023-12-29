// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/chat_provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/utils/app_images.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/dialogs.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  String friendID;
  ChatScreen({super.key, required this.friendID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  

  VideoPlayerController? videoController;
  void initializeVideoController(FunctionsProvider value) {
    if (value.selectedVideo != null) {
      videoController =
          VideoPlayerController.file(File(value.selectedVideo!.path))
            ..initialize().then((_) {
              videoController!.play();
              setState(() {});
            });
    }
  }
  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }
//to display the selected video in bottomsheet
selectedVideoBottomSheet(context, FunctionsProvider value, DataProvider value1){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: CColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
         topLeft: Radius.circular(30), 
         topRight: Radius.circular(30))),
    builder: (context) {
      return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: (){
                  value.selectedVideo = null;
                  Navigator.pop(context);
                  }, 
                icon: Icon(Icons.cancel_outlined, color: CColors.secondary,)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CColors.primary)
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.width * 0.9,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,),
                child: videoController != null // && videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: CColors.secondary,
                      ),
                    ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  child: SignButton(
                    buttonName: "Share",
                    onPressed: (){
                      if (value.selectedVideo != null) {
                        Functions.sendVideo(value1.uid, widget.friendID, value.selectedVideo)
                          .then((v) {
                            value.selectedVideo=null;
                            Navigator.pop(context);
                          });
                      }
                  }),
                ),
            ],
          );
    },);
}

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
         return value.selectedImage != null
          || value.selectedFile != null // for selecting photo/documents
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: (){
                  value.selectedImage = null;
                  value.selectedFile = null;
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
                child: value.selectedFile ==null
                ? Image(image: FileImage(File(value.selectedImage!.path)))
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(IconlyLight.document, size: 200,color: CColors.secondary,),
                    Text(
                      value.selectedFile!.name,
                      style: TextStyle(color: CColors.secondary,fontSize: 20),)
                  ],
                )),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  child: SignButton(
                    buttonName: "Share",
                    onPressed: (){
                      if (value.selectedImage != null) {
                        Navigator.pop(context);
                        Functions.sendImage(value1.uid, widget.friendID, value.selectedImage)
                          .then((v) =>
                            value.selectedImage=null);
                      }else if(value.selectedFile!=null){
                        Navigator.pop(context);
                        Functions.sendFile(value1.uid, widget.friendID, value.selectedFile)
                        .then((v) => value.selectedFile = null);
                      }
                    
                  }),
                ),
            ],
          )
          : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SettingsButton(
                onTap: () {
                  value.imagePicker(false);
                  }, buttonName: "Camera", icon: IconlyLight.camera),
            SettingsButton(
                onTap: () {
                  value.imagePicker(true);
                },
                buttonName: "Photo",
                icon: IconlyLight.image),
            SettingsButton(
                onTap: () async {
                await  value.videoPicker();
                  if (value.selectedVideo !=null) {
                  //  Navigator.pop(context);
                    initializeVideoController(value);
                    selectedVideoBottomSheet(context, value, value1);
                    
                  }
                },
                buttonName: "Video",
                icon: IconlyLight.video),
            SettingsButton(
                onTap: () {
                  value.filePicker();
                },
                buttonName: "Document",
                icon: IconlyLight.document),
            const SizedBox(
              height: 20,
            ),
          ]),
        );  
        },);
      },
    );
  }

//builds chat for users
Widget chatBuilder(DataProvider value) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (context) => ChatProvider(value.uid, widget.friendID),
      child: Consumer<ChatProvider>(
        builder: (context, value1, child) {
          return value1.chatList!.isEmpty
              ? Text(
                  "Say Hi to ${value.getPosterData(widget.friendID)!.username}",
                  style: TextStyle(color: CColors.secondary, fontSize: 20),
                )
              : ListView.builder(
                  reverse: true,
                  itemCount: value1.chatList?.length,
                  itemBuilder: (context, index) {
                      return Align(
                      alignment: value1.chatList?[index].senderID ==
                              value.uid
                          ? Alignment.topRight // Sender's message alignment
                          : Alignment.topLeft, // Receiver's message alignment
                      child: Container(
                        padding: value1.chatList?[index].type == "image" 
                        ? const EdgeInsets.all(4)
                        : const EdgeInsets.only(top: 10,right: 10,left: 10,bottom: 4),
                        margin: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                          maxWidth: 300,
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


                            if(value1.chatList![index].type == "voice note")
                            AudioMessageBox( link: value1.chatList![index].link,),
                            
                            if(value1.chatList![index].type == "video")
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.width * 0.8,
                                maxWidth: MediaQuery.of(context).size.width * 0.5,),
                                child: VideoPlayerWidget(videoUrl: value1.chatList![index].link))),

                            if(value1.chatList?[index].type == "document")
                            InkWell(
                              onTap: () async {
                                final Uri url = Uri.parse(value1.chatList![index].link);
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch ');
                                  }
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.width * 0.8,
                                  maxWidth: MediaQuery.of(context).size.width * 0.5,),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(IconlyLight.document, size: 200,color: CColors.primary,),
                                    Text(value1.chatList![index].type,
                                      style: TextStyle(color: CColors.primary,fontSize: 20),)
                                ]),
                              ),
                            ),

                            if(value1.chatList?[index].type == "image")
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.width * 0.8,
                                maxWidth: MediaQuery.of(context).size.width * 0.5,),
                              child: InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (context) {
                                    return Dialogs.profileViewer(value1.chatList![index].link);
                                  },);
                                  
                                },
                                child: Image.network(value1.chatList![index].link,fit: BoxFit.fill, )),),
                            ),

                          //for message time and seen/unseen
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
                                 ? Image.asset(AppImages.seen, scale: 3.2,)
                                 : Image.asset(AppImages.unseen, scale: 3.2,),
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
                            value.getPosterData(widget.friendID)!.image as String),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        value.getPosterData(widget.friendID)!.username,
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
                Consumer<FunctionsProvider>(builder: (context, value1, child) {
                  return SizedBox(
                  height: 58,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                           Expanded(
                            child: value1.isRecording
                              ? Text(
                                "recording...",
                                 style: TextStyle(
                                  color: CColors.secondary,
                                  fontSize: 18),
                                textAlign: TextAlign.center ,) 
                              : UpliftyTextfields(
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
                                        value.uid, widget.friendID, messageController)
                                    .then((value) {
                                  messageController.clear();
                                });
                                }
                              },
                            ),
                          ),

                          //voice note button
                             GestureDetector(
                            onLongPressStart: (details) {                             
                              value1.startRecording();
                            },
                            onLongPressEnd: (details) async {
                              await value1.stopRecording();
                              Functions.sendAudio(value.uid, widget.friendID, value1.audioPath!);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(0, 4), // Shadow position
                                  ),]),
                              child: Icon(IconlyLight.voice, color: CColors.secondary,),),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                },)
                
              ],
            ),
          )),
        );
      },
    );
  }
}
