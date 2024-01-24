import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uplifty/models/post_model.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class Dialogs {
  //To view Profile of users - opens image in alert dialog
  static profileViewer(String image) {
    return AlertDialog(
      shape: Border.all(style: BorderStyle.solid,color: CColors.secondarydark),
      backgroundColor: CColors.secondarydark,
      contentPadding: const EdgeInsets.all(2),
      content: CachedNetworkImage(imageUrl: image)
    );
  }

  //forget password dialog - used in login screen
  static forgetPasswordDialog(
      context, TextEditingController forgetPassController) {
    return AlertDialog(
      backgroundColor: CColors.background,
      title: const Text("Forget Password?"),
      titleTextStyle: TextStyle(
          color: CColors.secondary, fontWeight: FontWeight.bold, fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: UpliftyTextfields(
              controller: forgetPassController,
              fieldName: "Email",
              prefixIcon: IconlyLight.message,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SignButton(
                buttonName: "Send Reset Email",
                onPressed: () {
                  Functions.forgetPassword(forgetPassController).then((value) {
                    forgetPassController.clear();
                    Navigator.pop(context);
                  });
                }),
          )
        ],
      ),
    );
  }

  //for reset password - used in settings screen
  static resetPasswordDialog(
      context,
      TextEditingController currentPassController,
      TextEditingController newPassController) {
    return AlertDialog(
      backgroundColor: CColors.background,
      title: const Text("Reset Password"),
      titleTextStyle: TextStyle(
          color: CColors.secondary, fontWeight: FontWeight.bold, fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UpliftyTextfields(
            controller: currentPassController,
            fieldName: "Current Password",
            prefixIcon: IconlyLight.password,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10,
          ),
          UpliftyTextfields(
            controller: newPassController,
            fieldName: "New Password",
            prefixIcon: IconlyLight.password,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Functions.resetPassword(currentPassController, newPassController)
                  .then((value) {
                currentPassController.clear();
                newPassController.clear();
              });
            },
            child: Text(
              "Reset",
              style: TextStyle(color: CColors.secondary),
            )),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: CColors.secondary),
            )),
      ],
    );
  }

  //to delete the post - used in user posts screen
  static deletePostDialog(context, String postid) {
    return AlertDialog(
      backgroundColor: CColors.background,
      content: InkWell(
        onTap: () {
          Functions.deletePost(postid).then((value) => Navigator.pop(context));
        },
        child: Row(
          children: [
            Icon(
              IconlyLight.delete,
              color: CColors.secondary,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              "Delete Post",
              style: TextStyle(color: CColors.secondary),
            ),
          ],
        ),
      ),
    );
  }

  //to show list of users who liked the post
  // used in user post and home screen
  static likedByDialog(index, DataProvider value, bool isUserPosts) {
    late List<PostModel> post;
    if (isUserPosts) {
      post = value.userPosts;
    }else{
      post= value.allPosts;
    }
    return AlertDialog(
      backgroundColor: CColors.background,
      title: const Text(
        "Liked By:",
      ),
      titleTextStyle: TextStyle(color: CColors.secondarydark),
      content: Container(
        constraints: const BoxConstraints(
          maxHeight: 340,
        ),
        width: double.maxFinite,
        child: post[index].likedby!.isEmpty
            ? Text(
                "No likes yet...",
                style: TextStyle(color: CColors.secondary, fontSize: 14),
              )
            : ListView.builder(
                itemCount: post[index].likedby?.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: CColors.bottomAppBarcolor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            )
                          ]),
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(value
                                .getPosterData(
                                  post[index].likedby?[i],
                                )
                                ?.image as String)),
                        title: Text(
                          value
                              .getPosterData(
                                 post[index].likedby?[i])!
                              .username,
                          style: TextStyle(
                              color: CColors.secondarydark,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          value
                              .getPosterData(
                                  post[index].likedby?[i])!
                              .country as String,
                          style: TextStyle(
                              color: CColors.secondary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

 
}
