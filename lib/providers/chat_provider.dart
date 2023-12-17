import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider(String userID, String friendID) {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    getChat(chatID);
  }

  Future<void> markChatAsRead(String chatID) async {
    final CollectionReference<Map<String, dynamic>> userChats =
        FirebaseFirestore.instance.collection("uplifty_chats");

    final DocumentReference<Map<String, dynamic>> chatDoc =
        userChats.doc(chatID);
    //updates the chatdoc's isreaded
    await chatDoc.update({'isReaded': true});



    final CollectionReference<Map<String, dynamic>> messagesCollection =
        chatDoc.collection("messages");

    final QuerySnapshot<Map<String, dynamic>> messagesSnapshot =
        await messagesCollection.get();

    final WriteBatch batch = FirebaseFirestore.instance.batch();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> messageDoc
        in messagesSnapshot.docs) {
      batch.update(messageDoc.reference, {'isReaded': true});
    }

    // Commit the batch update
    await batch.commit();
  }

  List<ChatModel>? chatList = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  getChat(String chatID) {
    // final CollectionReference<Map<String, dynamic>> userChats =
    //     FirebaseFirestore.instance
    //         .collection("uplifty_chats")
    //         .doc(chatID)
    //         .collection("messages").orderBy("timestamp", descending: true);

    final CollectionReference<Map<String, dynamic>> userChats =
        FirebaseFirestore.instance.collection("uplifty_chats");

    final Query<Map<String, dynamic>> chatMessagesQuery = userChats
        .doc(chatID)
        .collection("messages")
        .orderBy("timestamp", descending: true);

    chatStream = chatMessagesQuery.snapshots().listen((snapshot) async {
      chatList?.clear();
      for (var element in snapshot.docs) {
        if (element.exists) {
          chatList?.add(ChatModel.fromMap(element.data()));
        }
      }
      // Mark the chat as read when the receiver opens the chat
      if (chatList!.isNotEmpty &&
          chatList!.first.senderID != FirebaseAuth.instance.currentUser!.uid &&
          !chatList!.first.isReaded) {
        print("works?");
        await markChatAsRead(chatID);
      }
      print(chatList?.first.messageText);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    chatStream?.cancel();
    super.dispose();
  }
}
