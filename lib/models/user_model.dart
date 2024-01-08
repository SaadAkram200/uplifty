import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
//late String id;
  late String username, email, id, phone;
  String? country, address, image;
  List<dynamic>? sentrequest = [],
      chatwith = [],
      friendrequest = [],
      myfriends = [],
      userchats = [],
      fcmtoken = [];

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.country,
    required this.address,
    required this.image,
    this.fcmtoken,
    this.sentrequest,
    this.friendrequest,
    this.myfriends,
    this.chatwith,
    this.userchats,
  });

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data['username'];
    phone = data['phone'];
    email = data['email'];
    country = data['country'];
    address = data['address'];
    image = data['image'];
    fcmtoken = data['fcmtoken'] ?? [];
    sentrequest = data['sentrequest'] ?? [];
    friendrequest = data['friendrequest'] ?? [];
    myfriends = data['myfriends'] ?? [];
    chatwith = data['chatwith'] ?? [];
    userchats = data['userchats'] ?? [];
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
      'fcmtoken': fcmtoken,
      'sentrequest': sentrequest,
      'friendrequest': friendrequest,
      'myfriends': myfriends,
      'chatwith': chatwith,
      'userchats': userchats,
      'timestamp': Timestamp.now(),
    };
  }

  //for update userdata
  Map<String, dynamic> updatetoMap() {
    return {
      "id": id,
      'username': username,
      'phone': phone,
      'email': email,
      'country': country,
      'address': address,
      'image': image,
      'timestamp': Timestamp.now(),
    };
  }
}
