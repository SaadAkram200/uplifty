import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uplifty/models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  CommentProvider(postId) {
    getComments(postId);
  }

  List<CommentModel>? postCommentsList = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? commentsStream;
  getComments(postId) {
    final Query<Map<String, dynamic>> postcomments =
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments").orderBy("timestamp", descending: true);
    commentsStream = postcomments.snapshots().listen((comments) {
      postCommentsList?.clear();
      for (var element in comments.docs) {
        if (element.exists) {
          postCommentsList?.add(CommentModel.fromMap(element.data()));
        }
        
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    commentsStream?.cancel();
    super.dispose();
  }
}
