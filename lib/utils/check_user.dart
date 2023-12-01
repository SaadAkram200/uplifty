import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/screens/create_profile.dart';
import 'package:uplifty/screens/bottom_appbar.dart';
import 'package:uplifty/screens/login_screen.dart';
import 'package:uplifty/utils/functions.dart';

class CheckUser {
  static final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  static var currentUser = FirebaseAuth.instance.currentUser;
  static var uid = FirebaseAuth.instance.currentUser?.uid;
  static var userEmail = FirebaseAuth.instance.currentUser!.email;
  static var doc = users.doc(uid);

  //checking form splash screen
  static isLoggedin(context) async {
    Functions.showLoading(context);

    if (currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      CheckUser.isCreatedProfile(context);
    }
  }

  //checking from login screen
  static isCreatedProfile(context) async {
    Functions.showLoading(context);
    var userData = await doc.get();

    if (userData.exists) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomAppBarClass(),
          ),
          (route) => false);
      
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfile(),
          ),
          (route) => false);
    }
  }
}
