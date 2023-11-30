// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/user_model.dart';

class DataProvider with ChangeNotifier {
  //constructor
  DataProvider() {
    authStream();
  }
  var uid;
  authStream() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        cancelSubscriptions();
      } else {
        uid= FirebaseAuth.instance.currentUser!.uid; 
        callFunctions();
      }
    });
  }

  //to call the functions
  callFunctions() { 
    getUserProfile();
    getUsersData();
  }

  //to dispose all the streams
  cancelSubscriptions() {
    userStream?.cancel();
    usersStream?.cancel();
  }

  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  
  // to get current user data
  UserModel? userData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userStream;
  getUserProfile() {
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

//to get all the users from firestore
    List<UserModel> allUsers = [];
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? usersStream;
    getUsersData(){
      usersStream = users.snapshots().listen((snapshot) { 
        allUsers.clear();
       for (var element in snapshot.docs) {
        if (element.id != uid) {
          allUsers.add(UserModel.fromMap(element.data()) );
        }
         notifyListeners();
       }
      });

    }
  
}
