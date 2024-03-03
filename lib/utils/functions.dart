// ignore_for_file: prefer_typing_uninitialized_variables

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
import 'package:uplifty/models/chat_model.dart';
import 'package:uplifty/models/comment_model.dart';
import 'package:uplifty/models/post_model.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/auth_screens/create_profile.dart';
import 'package:uplifty/screens/auth_screens/login_screen.dart';
import 'package:uplifty/screens/bottom_appbar.dart';
import 'package:uplifty/utils/check_user.dart';
import 'package:uplifty/utils/loading_widget.dart';
import 'colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Functions {
  //constructor
  Functions() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // User signed out
        uid = null;
      } else {
        // User signed in
        uid = user.uid;
        userEmail = user.email;
        doc = users.doc(uid);
      }
    });
  }

  //firebase work for posts
  static final CollectionReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection("posts");
  //create new post
  static Future<void> createNewPost(
      String imageUrl, TextEditingController captionController, String type) {
    var postdoc = posts.doc();
    String postid = postdoc.id;
    final newPost = PostModel(
      posterUid: uid,
      image: imageUrl,
      caption: captionController.text,
      postid: postid,
      type: type,
      likedby: [],
    );
    return postdoc.set(newPost.toMap());
  }

  //to delete the post
  static Future<void> deletePost(String postId) async {
    posts.doc(postId).delete();
  }

  //to create post
  static Future postCreation(context, XFile? selectedMedia,
      TextEditingController captionController, String type) async {
    try {
      showLoading(context);
      String mediaUrl = await uploadFile(selectedMedia!,
          path: "images/${DateTime.now().millisecondsSinceEpoch}");
      await createNewPost(mediaUrl, captionController, type);
      showToast("Posted Sucessfully!");
      Navigator.pop(context);
    } catch (e) {
      showToast("An error ocours, please try again");
    }
  }

//for like button// adds current uid in  post's likedby
  static Future<void> addLike(String postid, String uid) async {
    await posts.doc(postid).update({
      'likedby': FieldValue.arrayUnion([uid]),
    });
  }

  //for like button// removes current uid in  post's likedby
  static Future<void> removeLike(String postid, String uid) async {
    await posts.doc(postid).update({
      'likedby': FieldValue.arrayRemove([uid]),
    });
  }

  //to add new comment it the post's sub colllection
  static Future<void> addCommentToPost(String postId, CommentModel newComment) {
    final CollectionReference<Map<String, dynamic>> postcomments =
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments");

    return postcomments.add(newComment.toMap());
  }

  //firebase work for users
  static final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('uplifty_users');

  static var uid;
  static var userEmail;
  static var doc;

  //Create user
  static Future<void> createNewUser(UserModel user) {
    user.id = uid!;
    return doc.set(user.toMap());
  }

// update user
  static Future<void> updateUser(UserModel updateUser) {
    updateUser.id = uid!;
    return doc.update(updateUser.updatetoMap());
  }

//sends friend request
  static Future<void> sendFriendRequest(String friendID) async {
    //saves frindID in current user's sent request
    await users.doc(uid).update({
      "sentrequest": FieldValue.arrayUnion([friendID]),
    });

    //adds current UserID into friend's freind request
    await users.doc(friendID).update({
      "friendrequest": FieldValue.arrayUnion([uid]),
    });
    Functions.showToast("Friend request sent!");
  }

  //to reomve ids from both users requests
  static Future<void> rejectFriendRequest(String friendID) async {
    //saves frindID in current user's sent request
    await users.doc(friendID).update({
      "sentrequest": FieldValue.arrayRemove([uid]),
    });

    //adds current UserID into friend's freind request
    await users.doc(uid).update({
      "friendrequest": FieldValue.arrayRemove([friendID]),
    });
    // Functions.showToast("Frined request rejected!");
  }

  //accept friend request
  static Future<void> acceptFriendRequest(friendID) async {
    //adds friend id in user's myfriends
    await users.doc(uid).update({
      "myfriends": FieldValue.arrayUnion([friendID])
    });

    //adds userid in frined's myfriends
    await users.doc(friendID).update({
      "myfriends": FieldValue.arrayUnion([uid])
    });

    //to remove ids from friendrequests and sent requests
    rejectFriendRequest(friendID);
    showToast("Say Hi to new friend");
  }

  //firebase work for chats
  static final CollectionReference<Map<String, dynamic>> chats =
      FirebaseFirestore.instance.collection("uplifty_chats");

  static Future<void> initiateChat(String userID, String friendID) async {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    chats.doc(chatID)
      ..set({})
      ..collection("messages").doc();
  }

  static Future<void> sendMessage(
    String userID,
    String friendID,
    String messageText,
    DataProvider value,
    String type, {
    XFile? selectedItem,
    String? audioPath,
  }) async {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    List<dynamic>? fcmTokens = value.getPosterData(friendID)!.fcmtoken;

    String url = "";
    if (type == "image" || type == "video") {
      url = await uploadFile(selectedItem!,
          path: "images/${DateTime.now().millisecondsSinceEpoch}");
    } else if (type == "audio") {
      XFile audioFile = XFile(audioPath!);
      url = await uploadFile(audioFile,
          path: "audios/${DateTime.now().millisecondsSinceEpoch}");
    } else if (type == "document") {
      url = await uploadFile(selectedItem!,
          path: "files/${DateTime.now().millisecondsSinceEpoch}");
    }
    //to get the message doc id
    var messageDoc = chats.doc(chatID).collection("messages").doc();
    String messageID = messageDoc.id;

    final messageforchatdoc = ChatModel(
        messageText: messageText,
        messageID: messageID,
        senderID: userID,
        chatID: chatID,
        friendID: friendID,
        userID: userID,
        type: type,
        link: url);
    // to set data in chat's collection
    await chats.doc(chatID).set(messageforchatdoc.chatdoctoMap());

    final message = ChatModel(
        messageText: messageText,
        messageID: messageID,
        senderID: userID,
        link: url,
        type: type);
    // to send message- setting data in subcollection
    messageDoc.set(message.toMap()).then((v) => sendPushNotification(
        fcmTokens!, value.userData!.username, message.messageText, "message"));

    //adds friend id in user's myfriends
    users.doc(uid).update({
      "chatwith": FieldValue.arrayUnion([friendID]),
      "userchats": FieldValue.arrayUnion([chatID])
    });

    //adds userid in frined's myfriends
    users.doc(friendID).update({
      "chatwith": FieldValue.arrayUnion([userID]),
      "userchats": FieldValue.arrayUnion([chatID])
    });
  }

  //for sending push notificationa
  static Future<void> sendPushNotification(
    List<dynamic> fcmTokens,
    String title,
    String message,
    String type, {
    String? receiverID,
    String? callerID,
    String? callerName,
    bool? isVideoCall,
  }) async {
    const String serverKey =
        'AAAAO8fQJ1g:APA91bFdhr4YKc2FF1oQgl3YvT1dTMiWJebCsX1-faY5Z8tAM9Es68XLlco4SlFzss4klwIZsXBnIBcgVxpI8EvH_Q3lwClVevkFQe_JAX0fJ8ls21CUKWkSPQOMZHC0AvlwGAc973HX';
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    try {
      final Map<String, dynamic> notification = {
        'title': title,
        'body': message,
        'sound': 'default',
        'priority': 'high',
      };

      final Map<String, dynamic> data = {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'type': type,
        'receiverID': receiverID,
        'callerID': callerID,
        'callerName': callerName,
        'isVideoCall': isVideoCall,
        'status': 'done',
      };

      final Map<String, dynamic> payload = {
        'notification': notification,
        'data': data,
        'registration_ids': fcmTokens,
      };
      await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(payload),
      );
    } catch (e) {
      //print(e.toString());
    }
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
        return PopScope(
          onPopInvoked: (didPop) {
            Future.value(kDebugMode);
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
          ? showToast("Required Email Address")
          : showToast("Required Password");
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        CheckUser.isCreatedProfile(context);
      } catch (e) {
        showToast("Incorrect Email or password");
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
          ? showToast("Required Email Address")
          : showToast("Required Password");
    } else if (passwordController.text.length < 6) {
      showToast("Password should be at least of 6 characters");
    } else if (confirmPassController.text != passwordController.text) {
      showToast("Confirm password doesn't match!");
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        showToast("Ready to Inspire your world? ");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CreateProfile(),
            ),
            (route) => false);
      } catch (error) {
        var e = error as FirebaseAuthException;
        showToast(e.message!);
      }
    }
  }

  //forget Password function
  static Future<void> forgetPassword(
      TextEditingController forgetPassController) async {
    if (forgetPassController.text.isEmpty) {
      showToast("Enter your email address");
    } else {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: forgetPassController.text);
        showToast('Password reset email sent.');
      } catch (error) {
        var e = error as FirebaseAuthException;
        showToast(e.message!);
      }
    }
  }

  //reset password function
  static Future<void> resetPassword(
    TextEditingController currentPassController,
    TextEditingController newPassController,
  ) async {
    if (currentPassController.text.isEmpty || newPassController.text.isEmpty) {
      currentPassController.text.isEmpty
          ? showToast("Enter Current Password")
          : showToast("Enter New Password");
    } else if (newPassController.text.length < 6) {
      showToast("Password should be at least of 6 characters");
    } else {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassController.text,
          );

          await user.reauthenticateWithCredential(credential);

          await user.updatePassword(newPassController.text);
          showToast('Password updated successfully!');
        } else {
          showToast('User not found!');
        }
      } on FirebaseAuthException catch (e) {
        showToast('Incorrect current password!');

        if (e.code == 'wrong-password') {
          showToast('Incorrect current password!');
        }
      } catch (e) {
        showToast('Error: $e');
        // Handle other exceptions
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
  static Future<String> uploadFile(XFile file, {required path}) async {
    try {
      final mimeType = lookupMimeType(file.path);
      // String path = "images/${DateTime.now().millisecondsSinceEpoch}";
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
    if (usernameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        countryController.text.isEmpty ||
        addressController.text.isEmpty) {
      showToast("Please fill all the fields");

      //checking from where the user is coming? from sign up or from edit profile
    } else if (selectedImage == null && uploadedimageUrl == null) {
      showToast("Please select the profile picture");
    } else {
      try {
        showLoading(context);
        if (uploadedimageUrl == null || selectedImage != null) {
          imageUrl = await uploadFile(selectedImage!,
              path: "images/${DateTime.now().millisecondsSinceEpoch}");
        } else {
          imageUrl = uploadedimageUrl;
        }

        // for new user
        final user = UserModel(
          username: usernameController.text,
          email: Functions.userEmail as String,
          phone: phoneController.text,
          country: countryController.text,
          address: addressController.text,
          image: imageUrl,
          fcmtoken: [],
          friendrequest: [],
          myfriends: [],
          sentrequest: [],
          chatwith: [],
          userchats: [],
        );
        //for updating user data
        final updatedUser = UserModel(
            username: usernameController.text,
            email: userEmail,
            phone: phoneController.text,
            country: countryController.text,
            address: addressController.text,
            image: imageUrl);

        if (isEditing) {
          await updateUser(updatedUser);
          showToast("Profile Edited sucessfully");
          Navigator.pop(context);
        } else {
          await createNewUser(user);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomAppBarClass(),
              ),
              (route) => false);
        }
      } catch (error) {
        showToast("An error occors, please try again");
        Navigator.pop(context);
      }
    }
  }

  //signout method
  static Future signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  }
}
