import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String messageText, messageID, senderID, type, link;
  late String? chatID, userID, friendID;
  late DateTime timestamp;
  bool isReaded = false;

  ChatModel({
    required this.messageText,
    required this.messageID,
    required this.senderID,
    required this.type,
    required this.link,

    this.chatID,
    this.friendID,
    this.userID,
  });

  ChatModel.fromMap(Map<String, dynamic> data) {
    messageText = data['messageText'];
    messageID = data['messageID'];
    senderID = data['senderID'];
    isReaded = data['isReaded'];
    type = data['type'];
    link = data['link'];
    timestamp = (data['timestamp'] as Timestamp).toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      'messageText': messageText,
      'messageID': messageID,
      'senderID': senderID,
      'isReaded': isReaded,
      'type' : type,
      'link' : link,
      'timestamp': Timestamp.now(),
    };
  }

  Map<String, dynamic> chatdoctoMap() {
    return {
      'messageText': messageText,
      'messageID': messageID,
      'senderID': senderID,
      'isReaded': isReaded,
      'chatID': chatID,
      'userID': userID,
      'friendID': friendID,
      'type' : type,
      'link' : link,
      'timestamp': Timestamp.now(),
    };
  }
}
