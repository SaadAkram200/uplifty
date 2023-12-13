import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  late String message, senderID;
  late DateTime timestamp;

  ChatModel({
    required this.message,
    required this.senderID,
  });

  ChatModel.fromMapfromMap(Map<String, dynamic> data) {
    message = data['message'];
    senderID = data['senderID'];
    timestamp = (data['timestamp'] as Timestamp).toDate();
  }
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderID': senderID,
      'timestamp': Timestamp.now(),
    };
  }
}
