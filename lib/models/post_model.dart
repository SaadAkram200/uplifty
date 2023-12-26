import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String posterUid, image, caption, postid, type;
  List<dynamic>? likedby;
  late DateTime timestamp;
  PostModel({
    required this.posterUid,
    required this.image,
    required this.caption,
    required this.postid,
    required this.likedby,
    required this.type,
  });
  PostModel.fromMap(Map<String, dynamic> data) {
    posterUid = data["posterUid"];
    image = data['image'];
    caption = data['caption'];
    postid = data['postid'];
    type = data['type'];
    likedby = data['likedby'] ?? [];
    timestamp = (data['timestamp'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      'posterUid': posterUid,
      'image': image,
      'caption': caption,
      'postid': postid,
      'type': type,
      'likedby': likedby,
      'timestamp': Timestamp.now(),
    };
  }
}
