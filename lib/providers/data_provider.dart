// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/models/chat_model.dart';
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
    updateFcmToken();
  }

  //to dispose all the streams
  cancelSubscriptions() {
    removeFcmToken();
    userStream?.cancel();
    usersStream?.cancel();
    postsStream?.cancel();
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
        getUserPosts();
      } else {
        userData = null;
      }
      if (userData!.myfriends!.isNotEmpty) {
        getPosts(); // to get user's friends posts
      }
      if (userData!.userchats!.isNotEmpty) {
        getUserChats(); // to get user's chats
      }
      notifyListeners();
    });
  }

  //to save the fcm token of the current device against the current user
  late String fcmtoken;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  updateFcmToken() async {
    await firebaseMessaging.getToken().then(
      (token) {
        fcmtoken = token!;
        users.doc(uid).update({
          "fcmtoken": FieldValue.arrayUnion([token])
        });
      },
    );
  }

  //to remove the current device fcm token from firebase
  removeFcmToken() async {
    await users.doc(uid).update({
      "fcmtoken": FieldValue.arrayRemove([fcmtoken])
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
      }
      notifyListeners();
    });
  }

  //to get poster's data. takes any uid and returns its data
  UserModel? getPosterData(String posterUid) {
    return everyUsers.where((user) => user.id == posterUid).toList().first;
  }

  final CollectionReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection('posts');

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
        if (element.exists) {
          PostModel post = PostModel.fromMap(element.data());

          allPosts.add(post);
        }
      }
      notifyListeners();
    });
  }

  List<PostModel> userPosts = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? userpostsStream;
  getUserPosts() {
// to get user's own posts
    userpostsStream?.cancel();
    userpostsStream =
        posts.where('posterUid', isEqualTo: uid).snapshots().listen((snapshot) {
      userPosts.clear();
      for (var element in snapshot.docs) {
        if (element.exists) {
          PostModel userPost = PostModel.fromMap(element.data());
          userPosts.add(userPost);
        }
      }
      notifyListeners();
    });
  }

  final CollectionReference<Map<String, dynamic>> userChats =
      FirebaseFirestore.instance.collection("uplifty_chats");
//to get the current user's all chats
  List<ChatModel> allChats = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatsStream;
  getUserChats() {
    chatsStream?.cancel();
    chatsStream = userChats
        .where('chatID', whereIn: userData?.userchats)
        .snapshots()
        .listen((snapshot) {
      allChats.clear();
      for (var element in snapshot.docs) {
        if (element.exists) {
          allChats.add(ChatModel.fromMap(element.data()));
        }
      }
      notifyListeners();
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
