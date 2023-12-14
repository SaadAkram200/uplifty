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
    final CollectionReference<Map<String, dynamic>> postcomments =
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments");
    commentsStream = postcomments.snapshots().listen((comments) {
      postCommentsList?.clear();
      for (var element in comments.docs) {
        postCommentsList?.add(CommentModel.fromMap(element.data()));
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
