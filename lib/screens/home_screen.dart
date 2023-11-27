import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uplifty/utils/colors.dart';


import 'login_screen.dart';

class HomeScreen extends StatelessWidget {

   //signout method
  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      body: SafeArea(
          child: Center(
              child: ElevatedButton(
        child: Text("LOG OUT"),
        onPressed: () {
          signOut(context);
        },
      ))),
    );
  }
}
