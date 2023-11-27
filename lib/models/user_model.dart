import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{

//late String id;
  late String username, email, id, phone; 
   String? country, address,image;
  
  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.country,
    required this.address,
    required this.image,
  });

  UserModel.fromMap(Map<String, dynamic>data)
  {
    id = data["id"];
    username = data['username'];
    phone = data['phone'];
    email = data['email'];
    country = data['country'];
    address = data['address'];
    image = data['image'];
    

  }

  Map<String, dynamic>toMap(){
    return{
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