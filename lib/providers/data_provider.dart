import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/user_model.dart';

class DataProvider with ChangeNotifier {
  
  
  static final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  static var uid = FirebaseAuth.instance.currentUser?.uid;
  static var doc = users.doc(uid);
  
  // to get current user data
  UserModel? userData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userStream;

  getUserProfile() {

    userStream = users.doc(uid).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        userData = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        
        //print("DATA from functions :  " + userData!.email);
        
        } else { 
          userData = null;
        }
        notifyListeners();
     });
  }
}
