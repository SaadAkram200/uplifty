import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String messageText, messageID, senderID;
  late DateTime timestamp;

  ChatModel({
    required this.messageText,
    required this.messageID,
    required this.senderID,
  });

  ChatModel.fromMap(Map<String, dynamic> data) {
    messageText = data['messageText'];
    messageID = data['messageID'];
    senderID = data['senderID'];
    timestamp = (data['timestamp'] as Timestamp).toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      'messageText': messageText,
      'messageID': messageID,
      'senderID': senderID,
      'timestamp': Timestamp.now(),
    };
  }
}
