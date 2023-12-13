import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String commentText, commenterId;
  late DateTime timestamp;

  CommentModel({
    required this.commentText,
    required this.commenterId,
    //this.timestamp =  Timestamp.now(),
  });

  CommentModel.fromMap(Map<String, dynamic> data) {
    commenterId = data['commenterId'];
    commentText = data["commentText"];
    timestamp = (data['timestamp'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'commenterId': commenterId,
      'commentText': commentText,
      'timestamp': Timestamp.now(),
    };
  }
}
