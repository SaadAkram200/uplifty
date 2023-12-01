import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/screens/create_profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:uplifty/screens/bottom_appbar.dart';
import 'package:uplifty/screens/login_screen.dart';
import 'package:uplifty/utils/check_user.dart';
import 'package:uplifty/utils/loading_widget.dart';
import 'colors.dart';

class Functions {
  //firebase work
  static final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  static var uid = FirebaseAuth.instance.currentUser?.uid;
  static var userEmail = FirebaseAuth.instance.currentUser!.email;
  static var doc = users.doc(uid);

  //Create user
  static Future<void> createNewUser(UserModel user) {
    user.id = uid!;
    return doc.set(user.toMap());
  }

// update user
  static Future<void> updateUser(UserModel updateUser) {
    updateUser.id = uid!;
    return doc.update(updateUser.toMap());
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

  //shows loading
  static showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(kDebugMode);
          },
          child: const AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: LoadingWidget(),
          ),
        );
      },
      barrierDismissible: false,
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

        CheckUser.isCreatedProfile(context);
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CreateProfile(),
          ),
          (route) => false);
      } catch (error) {
        var e = error as FirebaseAuthException;
        Functions.showToast(e.message!);
      }
    }
  }

  //country picker - used in create profile
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

  //image picker
  static Future<XFile?> imagePicker() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    return file;
  }

  //upload image
  static Future<String> uploadFile(XFile file) async {
    try {
      final mimeType = lookupMimeType(file.path);
      String path = "images/${DateTime.now().millisecondsSinceEpoch}";
      final firebasestorage.FirebaseStorage storage =
          firebasestorage.FirebaseStorage.instance;
      var reference = storage.ref().child(path);
      var r = await reference.putData(
          await file.readAsBytes(), SettableMetadata(contentType: mimeType));

      if (r.state == firebasestorage.TaskState.success) {
        String imageUrl = await reference.getDownloadURL();

        return imageUrl;
      } else {
        throw PlatformException(code: "404", message: "no download link found");
      }
    } catch (e) {
      rethrow;
    }
  }

// create new profile and editing existing profile
  static Future profileCreation(
      context,
      selectedImage,
      String? uploadedimageUrl,
      TextEditingController usernameController,
      TextEditingController phoneController,
      TextEditingController countryController,
      TextEditingController addressController,
      bool isEditing) async {

    String? imageUrl = "";
    if (usernameController.text == "" ||
        phoneController.text == "" ||
        countryController.text == "" ||
        addressController.text == "") {
      Functions.showToast("Please fill all the fields");
     
      //checking from where the user is coming? from sign up or from edit profile
    } else if (selectedImage == null && uploadedimageUrl == null) {
      Functions.showToast("Please select the profile picture");
    } else {
      try {
        Functions.showLoading(context);
        if(uploadedimageUrl == null || selectedImage!=null){
          imageUrl = await Functions.uploadFile(selectedImage!);
        }else{
          imageUrl = uploadedimageUrl;
        }

        final user = UserModel(
            username: usernameController.text,
            email: Functions.userEmail as String,
            phone: phoneController.text,
            country: countryController.text,
            address: addressController.text,
            image: imageUrl);

        if (isEditing) {
          Functions.updateUser(user).then(
              (value) {
                Functions.showToast("Profile Edited sucessfully");
                Navigator.pop(context);

              } );
              
        } else {
          Functions.createNewUser(user).then((value) {
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomAppBarClass(),
          ),
          (route) => false);

        });
        }
        
      } catch (e) {
        Functions.showToast("An error occors, please try again");
        Navigator.pop(context);
      }
    }
  }


  //signout method
  static Future signOut(context) async {
   // Functions.showLoading(context);
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
  }
}
