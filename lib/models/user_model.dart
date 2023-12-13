import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
//late String id;
  late String username, email, id, phone;
  String? country, address, image;
  List<dynamic>? sentrequest, friendrequest, myfriends, chatwith;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.country,
    required this.address,
    required this.image,
    this.sentrequest,
    this.friendrequest,
    this.myfriends,
    this.chatwith,
  });

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data['username'];
    phone = data['phone'];
    email = data['email'];
    country = data['country'];
    address = data['address'];
    image = data['image'];
    sentrequest = data['sentrequest'];
    friendrequest = data['friendrequest'];
    myfriends = data['myfriends'];
    chatwith = data['chatwith'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'username': username,
      'phone': phone,
      'email': email,
      'country': country,
      'address': address,
      'image': image,
      'sentrequest': sentrequest,
      'friendrequest': friendrequest,
      'myfriends': myfriends,
      'chatwith':chatwith,
      'timestamp': Timestamp.now(),
    };
  }
}
