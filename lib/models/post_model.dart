import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String posterUid, image, caption, postid;
  List<dynamic>? likedby;
  PostModel({
    required this.posterUid,
    required this.image,
    required this.caption,
    required this.postid,
    required this.likedby,
  });
  PostModel.fromMap(Map<String, dynamic> data) {
    posterUid = data["posterUid"];
    image = data['image'];
    caption = data['caption'];
    postid = data['postid'];
    likedby = data['likedby'] ?? [];
  }

  Map<String, dynamic> toMap() {
    return {
      'posterUid': posterUid,
      'image': image,
      'caption': caption,
      'postid': postid,
      'likedby': likedby,
      'timestamp': Timestamp.now(),
    };
  }
}
