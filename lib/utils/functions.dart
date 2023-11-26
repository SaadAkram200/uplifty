import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/screens/home_screen.dart';
import 'package:uplifty/screens/signup_screen2.dart';

import 'colors.dart';

class Functions {


  //firebase work
  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  //Create user
  Future<void> createNewUser(UserModel user) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var doc = users.doc(uid);
    user.id = uid;
    return doc.set(user.toMap());
  }

//toast function
  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: CColors.secondary,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      fontSize: 15,
    );
  }

  // login function
  static Future logIn(context, TextEditingController emailController,
      TextEditingController passwordController) async {
    // checking if Textfields are empty
    if (emailController.text == "" || passwordController.text == "") {
      emailController.text == ""
          ? Functions.showToast("Required Email Address")
          : Functions.showToast("Required Password");
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        Functions.showToast("Incorrect Email or password");
      }
    }
  }

  //sign up function
  static Future signUp(
    context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPassController,
  ) async {
    // checking if Textfields are empty
    if (emailController.text == "" || passwordController.text == "") {
      emailController.text == ""
          ? Functions.showToast("Required Email Address")
          : Functions.showToast("Required Password");
    } else if (confirmPassController.text != passwordController.text) {
      Functions.showToast("Confirm password doesn't match!");
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Functions.showToast("Ready to Inspire your world? ");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignUpScreen2()));
      } catch (error) {
        var e = error as FirebaseAuthException;
        Functions.showToast(e.message!);
      }
    }
  }

  static countryPicker(context, Function(Country) onSelect) {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: CColors.background,
          textStyle: TextStyle(fontSize: 16, color: CColors.secondarydark),
          bottomSheetHeight: 500, // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              focusColor: CColors.secondary,
              hintText: "Start typing to search",
              hintStyle: TextStyle(color: CColors.secondary),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: CColors.secondary)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: CColors.secondary)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: CColors.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(30)))),
        ),
        onSelect: (Country country) {
          onSelect(country);
        });
  }
}
