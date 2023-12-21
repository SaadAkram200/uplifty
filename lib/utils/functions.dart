// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';
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
import 'package:uplifty/screens/create_profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:uplifty/screens/bottom_appbar.dart';
import 'package:uplifty/screens/login_screen.dart';
import 'package:uplifty/utils/check_user.dart';
import 'package:uplifty/utils/loading_widget.dart';
import 'colors.dart';

class Functions {
  //constructor
  Functions() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // User is signed out
        uid = null;
      } else {
        // User is signed in
        uid = user.uid;
        userEmail = user.email;
        doc = users.doc(uid);
      }
    });
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

  static Future<void> startChatting(String userID, String friendID,
      TextEditingController messageController) async {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    //to get the message doc id
    var messageDoc = chats.doc(chatID).collection("messages").doc();
    String messageID = messageDoc.id;

    final messageforchatdoc = ChatModel(
        messageText: messageController.text,
        messageID: messageID,
        senderID: userID,
        chatID: chatID,
        friendID: friendID,
        userID: userID,
        type: "text",
        link: "");
    // to set data in chat's collection
    await chats.doc(chatID).set(messageforchatdoc.chatdoctoMap());

    final message = ChatModel(
        messageText: messageController.text,
        messageID: messageID,
        senderID: userID,
        link: "",
        type: "text");
    // to send message- setting data in subcollection
    messageDoc.set(message.toMap());

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

  //for sending image in chat
  static Future<void> sendImage(
    String userID,
    String friendID,
    XFile? selectedImage,
  ) async {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    String imageUrl = await uploadImage(selectedImage!);
    //to get the message doc id
    var messageDoc = chats.doc(chatID).collection("messages").doc();
    String messageID = messageDoc.id;

    final messageforchatdoc = ChatModel(
        messageText: "📷Photo",
        messageID: messageID,
        senderID: userID,
        chatID: chatID,
        friendID: friendID,
        userID: userID,
        type: "image",
        link: imageUrl);
    // to set data in chat's collection
    await chats.doc(chatID).set(messageforchatdoc.chatdoctoMap());

    final message = ChatModel(
        messageText: "📷Photo",
        messageID: messageID,
        senderID: userID,
        link: imageUrl,
        type: "image");
    // to send message- setting data in subcollection
    messageDoc.set(message.toMap());
  }


  
  //for sending documents in chat
  static Future<void> sendFile(
    String userID,
    String friendID,
    XFile? selectedFile,
  ) async {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    String fileUrl = await uploadFile(selectedFile!);
    //to get the message doc id
    var messageDoc = chats.doc(chatID).collection("messages").doc();
    String messageID = messageDoc.id;

    final messageforchatdoc = ChatModel(
        messageText: "📄Document",
        messageID: messageID,
        senderID: userID,
        chatID: chatID,
        friendID: friendID,
        userID: userID,
        type: "document",
        link: fileUrl);
    // to set data in chat's collection
    await chats.doc(chatID).set(messageforchatdoc.chatdoctoMap());

    final message = ChatModel(
        messageText: "📄Document",
        messageID: messageID,
        senderID: userID,
        link: fileUrl,
        type: "document");
    // to send message- setting data in subcollection
    messageDoc.set(message.toMap());
  }


  //for sending voice note in chat
  static Future<void> sendAudio(
    String userID,
    String friendID,
    String audioPath,
  ) async {
    List<String> list = [userID, friendID];
    list.sort();
    String chatID = list.join("_");

    String fileUrl = await uploadAudio(audioPath);
    //to get the message doc id
    var messageDoc = chats.doc(chatID).collection("messages").doc();
    String messageID = messageDoc.id;

    final messageforchatdoc = ChatModel(
        messageText: "🎤Voice note",
        messageID: messageID,
        senderID: userID,
        chatID: chatID,
        friendID: friendID,
        userID: userID,
        type: "voice note",
        link: fileUrl);
    // to set data in chat's collection
    await chats.doc(chatID).set(messageforchatdoc.chatdoctoMap());

    final message = ChatModel(
        messageText: "🎤Voice note",
        messageID: messageID,
        senderID: userID,
        link: fileUrl,
        type: "voice note");
    // to send message- setting data in subcollection
    messageDoc.set(message.toMap()).then((value) => showToast("audio sent"));
  }

  //firebase work for posts
  static final CollectionReference<Map<String, dynamic>> posts =
      FirebaseFirestore.instance.collection("posts");
  //create new post
  static Future<void> createNewPost(
      String imageUrl, TextEditingController captionController) {
    var postdoc = posts.doc();
    String postid = postdoc.id;
    final newPost = PostModel(
      posterUid: uid,
      image: imageUrl,
      caption: captionController.text,
      postid: postid,
      likedby: [],
    );
    return postdoc.set(newPost.toMap());
  }

  //to create post
  static Future postCreation(context, XFile? selectedImage,
      TextEditingController captionController) async {
    if (selectedImage == null) {
      showToast("Select image to post");
    } else {
      try {
        showLoading(context);
        String imageUrl = await uploadImage(selectedImage);
        await createNewPost(imageUrl, captionController);
        showToast("Posted Sucessfully!");
        Navigator.pop(context);
      } catch (e) {
        showToast("An error ocours, please try again");
      }
    }
  }

//for like button// adds current uid in  post's likedby
  static Future<void> addLike(String postid, String uid) async {
    List<String> likedby = [uid];
    await posts.doc(postid).update({
      'likedby': FieldValue.arrayUnion(likedby),
    });
  }

  //for like button// removes current uid in  post's likedby
  static Future<void> removeLike(String postid, String uid) async {
    List<String> unlikedby = [uid];
    await posts.doc(postid).update({
      'likedby': FieldValue.arrayRemove(unlikedby),
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
    List<String> sentRequest = [friendID];
    await users.doc(uid).update({
      "sentrequest": FieldValue.arrayUnion(sentRequest),
    });

    //adds current UserID into friend's freind request
    List<String> friendRequest = [uid];
    await users.doc(friendID).update({
      "friendrequest": FieldValue.arrayUnion(friendRequest),
    });
    Functions.showToast("Friend request sent!");
  }

  //to reomve ids from both users requests
  static Future<void> rejectFriendRequest(String friendID) async {
    //saves frindID in current user's sent request
    List<String> sentRequest = [uid];
    await users.doc(friendID).update({
      "sentrequest": FieldValue.arrayRemove(sentRequest),
    });

    //adds current UserID into friend's freind request
    List<String> friendRequest = [friendID];
    await users.doc(uid).update({
      "friendrequest": FieldValue.arrayRemove(friendRequest),
    });
    // Functions.showToast("Frined request rejected!");
  }

  //accept friend request
  static Future<void> acceptFriendRequest(friendID) async {
    //adds friend id in user's myfriends
    List<String> myFrineds = [friendID];
    await users
        .doc(uid)
        .update({"myfriends": FieldValue.arrayUnion(myFrineds)});

    //adds userid in frined's myfriends
    List<String> friendsMyFrineds = [uid];
    await users
        .doc(friendID)
        .update({"myfriends": FieldValue.arrayUnion(friendsMyFrineds)});

    //to remove ids from friendrequests and sent requests
    rejectFriendRequest(friendID);
    showToast("Say Hi to new friend");
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
  static Future<String> uploadImage(XFile file) async {
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

  //upload file
  static Future<String> uploadFile(XFile file) async {
    try {
      final mimeType = lookupMimeType(file.path);
      String path = "files/${DateTime.now().millisecondsSinceEpoch}";
      final firebasestorage.FirebaseStorage storage =
          firebasestorage.FirebaseStorage.instance;
      var reference = storage.ref().child(path);
      var r = await reference.putData(
          await file.readAsBytes(), SettableMetadata(contentType: mimeType));

      if (r.state == firebasestorage.TaskState.success) {
        String fileUrl = await reference.getDownloadURL();

        return fileUrl;
      } else {
        throw PlatformException(code: "404", message: "no download link found");
      }
    } catch (e) {
      rethrow;
    }
  }


 //upload audio
  static Future<String> uploadAudio(String audioPath) async {
    try {
      final mimeType = lookupMimeType(audioPath);
      String path = "audios/${DateTime.now().millisecondsSinceEpoch}";
      final firebasestorage.FirebaseStorage storage =
          firebasestorage.FirebaseStorage.instance;

       File audioFile = File(audioPath);

      var reference = storage.ref().child(path);
      var r = await reference.putData(
          await audioFile.readAsBytes(), SettableMetadata(contentType: mimeType));

      if (r.state == firebasestorage.TaskState.success) {
        String audioUrl = await reference.getDownloadURL();

        return audioUrl;
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
      showToast("Please fill all the fields");

      //checking from where the user is coming? from sign up or from edit profile
    } else if (selectedImage == null && uploadedimageUrl == null) {
      showToast("Please select the profile picture");
    } else {
      try {
        showLoading(context);
        if (uploadedimageUrl == null || selectedImage != null) {
          imageUrl = await uploadImage(selectedImage!);
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
