import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String messageText, messageID, senderID;
  late String? chatID, userID, friendID;
  late DateTime timestamp;
  bool isReaded = false;

  ChatModel({
    required this.messageText,
    required this.messageID,
    required this.senderID,
    this.chatID,
    this.friendID,
    this.userID,
  });

  ChatModel.fromMap(Map<String, dynamic> data) {
    messageText = data['messageText'];
    messageID = data['messageID'];
    senderID = data['senderID'];
    isReaded = data['isReaded'];
    timestamp = (data['timestamp'] as Timestamp).toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      'messageText': messageText,
      'messageID': messageID,
      'senderID': senderID,
      'isReaded': isReaded,
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
      'timestamp': Timestamp.now(),
    };
  }
}
