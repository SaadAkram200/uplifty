import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
 late String id, image, caption; 
 PostModel({
  required this.id,
  required this.image,
  required this.caption,
 });
 PostModel.fromMap(Map<String, dynamic>data){
  id = data["id"];
  image = data['image'];  
  caption = data['caption'];  
 }

 Map<String, dynamic>toMap(){
    return{
      "id": id,
      'image': image, 
      'caption': caption,
      'timestamp': Timestamp.now(),
    };
  }
}