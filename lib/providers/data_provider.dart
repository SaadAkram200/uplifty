import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/user_model.dart';

class DataProvider with ChangeNotifier {
  //constructor
  DataProvider() {
    callFunctions();
  }

  authStream() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        cancelSubscriptions();
      } else {
        callFunctions();
      }
    });
  }

  //to call the functions
  callFunctions() {
    getUserProfile();
  }

  //to dispose all the streams
  cancelSubscriptions() {
    userStream?.cancel();
  }

  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  // to get current user data
  UserModel? userData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userStream;

  getUserProfile() {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    var doc = users.doc(uid);

    userStream = doc.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        userData = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        userData = null;
      }
      notifyListeners();
    });
  }

  
}
