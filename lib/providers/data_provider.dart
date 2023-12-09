// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/post_model.dart';
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
        uid = FirebaseAuth.instance.currentUser!.uid;
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
    postsStream?.cancel();
  }

  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  final CollectionReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection('posts');

  final CollectionReference<Map<String, dynamic >> postcomments = 
      FirebaseFirestore.instance.collection("posts").doc(  ).collection("comments");
  
  // to get current user data
  UserModel? userData;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userStream;
  getUserProfile() {
    var doc = users.doc(uid);
    userStream = doc.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        userData = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

        getPosts(); // to get user's friends posts
      } else {
        userData = null;
      }
      notifyListeners();
    });
  }

//to get all the users from firestore
//execpt the current user
  List<UserModel> allUsers = [];
  List<UserModel> everyUsers = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? usersStream;
  getUsersData() {
    usersStream = users.snapshots().listen((snapshot) {
      allUsers.clear();
      everyUsers.clear();
      friendRequestList.clear();
      for (var element in snapshot.docs) {
        everyUsers.add(UserModel.fromMap(element.data()));
        if (element.id != uid) {
          allUsers.add(UserModel.fromMap(element.data()));
        }
        notifyListeners();
      }
    });
  }

  //to get poster's data
  UserModel? getPosterData(String posterUid) {
    return everyUsers.where((user) => user.id == posterUid).toList().first;
  }

//to get all the posts of the user's friends only
  List<PostModel> allPosts = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? postsStream;
  getPosts() {
    postsStream?.cancel();
    postsStream = posts
        .where('posterUid', whereIn: userData?.myfriends)
        .snapshots()
        .listen((snapshot) {
      allPosts.clear();
      for (var element in snapshot.docs) {
        allPosts.add(PostModel.fromMap(element.data()));

        notifyListeners();
      }
    });
  }

//stores all the users of user's friendrequest in list
  List<UserModel> friendRequestList = [];
  getFriendRequests() {
    friendRequestList.clear();
    friendRequestList = allUsers
        .where((user) =>
            userData!.friendrequest != null &&
            userData!.friendrequest!.contains(user.id))
        .map((user) => user)
        .toList();
    return friendRequestList;
  }

  //stores all the users of user's myfriend in list
  List<UserModel> myFrinedsList = [];
  getMyFriends() {
    myFrinedsList.clear();
    myFrinedsList = allUsers
        .where((user) =>
            userData!.myfriends != null &&
            userData!.myfriends!.contains(user.id))
        .map((user) => user)
        .toList();
    return myFrinedsList;
  }
}
