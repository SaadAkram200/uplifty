import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/chat_model.dart';


class ChatProvider  with ChangeNotifier{
  
  ChatProvider(String userID, String friendID){

    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    getChat(chatID);
  }

  List<ChatModel>? chatList = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  getChat(String chatID){
    

    // final CollectionReference<Map<String, dynamic>> userChats =
    //     FirebaseFirestore.instance
    //         .collection("uplifty_chats")
    //         .doc(chatID)
    //         .collection("messages").orderBy("timestamp", descending: true);

    final CollectionReference<Map<String, dynamic>> userChats =
    FirebaseFirestore.instance.collection("uplifty_chats");

final Query<Map<String, dynamic>> chatMessagesQuery =
    userChats.doc(chatID).collection("messages").orderBy("timestamp", descending: true);

     chatStream = chatMessagesQuery.snapshots().listen((snapshot) {
        chatList?.clear();
        for (var element in snapshot.docs) {
          chatList?.add(ChatModel.fromMap(element.data()));
        }
        notifyListeners();
      });
  }

  @override
  void dispose() {
    chatStream?.cancel();
    super.dispose();
  }
}