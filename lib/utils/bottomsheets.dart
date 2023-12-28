import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/models/comment_model.dart';
import 'package:uplifty/models/post_model.dart';
import 'package:uplifty/providers/comment_provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/addpost_screen.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class BottomSheets {
  //bottomsheet to select post type - video or image
  // used in bottom appbar class
  static selectPostType(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
              color: CColors.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: Icon(
                    IconlyLight.image,
                    color: CColors.secondary,
                  ),
                  title: Text(
                    'Image',
                    style: TextStyle(color: CColors.secondary),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(isImage: true),
                        ),
                        (route) => true).then(
                      (value) => Navigator.pop(context),
                    );
                  }),
              ListTile(
                leading: Icon(
                  IconlyLight.video,
                  color: CColors.secondary,
                ),
                title: Text(
                  'Video',
                  style: TextStyle(color: CColors.secondary),
                ),
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPost(isImage: false),
                    ),
                    (route) => true).then(
                  (value) => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //to show comments of post
  //used in user posts and home screen
  static commentsBottomSheet(context, index, DataProvider value,
      TextEditingController commentController, bool isUserPosts) {
    late List<PostModel> post;
    if (isUserPosts) {
      post = value.userPosts;
    } else {
      post = value.allPosts;
    }
    return showModalBottomSheet(
      context: context,
      backgroundColor: CColors.background,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return ChangeNotifierProvider<CommentProvider>(
            create: (context) => CommentProvider(post[index].postid),
            child: Consumer<CommentProvider>(
              builder: (context, value1, child) {
                return Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8),
                  child: Scaffold(
                    backgroundColor: CColors.background,
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Expanded(
                              child: value1.postCommentsList!.isEmpty
                                  ? Text(
                                      "No comments yet..",
                                      style: TextStyle(
                                          color: CColors.secondary,
                                          fontSize: 18),
                                    )
                                  : ListView.builder(
                                      reverse: true,
                                      itemCount:
                                          value1.postCommentsList?.length,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    CColors.bottomAppBarcolor,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black45,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4),
                                                  )
                                                ]),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      value
                                                          .getPosterData(value1
                                                              .postCommentsList![
                                                                  i]
                                                              .commenterId)
                                                          ?.image as String)),
                                              title: Text(
                                                value
                                                    .getPosterData(value1
                                                        .postCommentsList![i]
                                                        .commenterId)!
                                                    .username,
                                                style: TextStyle(
                                                    color: CColors.secondary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle: Text(
                                                value1.postCommentsList![i]
                                                    .commentText,
                                                style: TextStyle(
                                                    color:
                                                        CColors.secondarydark),
                                              ),
                                              trailing: Text(
                                                DateFormat('hh:mm a').format(
                                                  value1.postCommentsList![i]
                                                      .timestamp,
                                                ),
                                                style: TextStyle(
                                                    color: CColors.secondary),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                          //comment textfield
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: UpliftyTextfields(
                                controller: commentController,
                                fieldName: "Write a comment...",
                                prefixIcon: Icons.comment_outlined,
                                suffixIcon: Icons.send,
                                suffixIconOnpressed: () async {
                                  if (commentController.text == "") {
                                    Functions.showToast("Write a comment...");
                                  } else {
                                    try {
                                      //to add comment in post's sub collection
                                      final newComment = CommentModel(
                                        commentText: commentController.text,
                                        commenterId: value.userData!.id,
                                      );
                                      await Functions.addCommentToPost(
                                          post[index].postid, newComment);
                                      commentController.clear();
                                    } catch (e) {
                                      Functions.showToast(
                                          "An error ocours, please try later");
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }
}
