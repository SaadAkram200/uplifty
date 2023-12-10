import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String commentText, commenterId;// commentId;

  CommentModel({
    required this.commentText,
    required this.commenterId,
    //required this.commentId,
  });

  CommentModel.fromMap(Map<String, dynamic> data) {
    commenterId = data['commenterId'];
   // commentId = data['commentId'];
    commentText = data["commentText"];
  }

  Map<String, dynamic> toMap() {
    return {
      'commenterId': commenterId,
     // 'commentId': commentId,
      'commentText': commentText,
      'timestamp': Timestamp.now(),
    };
  }
}
