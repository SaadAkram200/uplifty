// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  TextEditingController commentController = TextEditingController();
  
  commentDialog(index) {
    return AlertDialog(
      backgroundColor: CColors.background,
      title: const Text("Comments"),
      titleTextStyle: TextStyle(color: CColors.secondary),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
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
                leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/dummyuser.jpg")),
                title: Text(
                  " commenter's name",
                  style: TextStyle(color: CColors.secondary, fontSize: 12),
                ),
                subtitle: Text(
                  "very nice picture bro <3",
                  style: TextStyle(color: CColors.secondarydark),
                ),
              ),
            ),
            UpliftyTextfields(
              controller: commentController,
              fieldName: "Write a comment",
              prefixIcon: Icons.comment_outlined,
              suffixIcon: Icons.send,
              suffixIconOnpressed: () {
                print(index);
              },
            )
          ],
        ),
      ),
    );
  }

//to show list of users who liked the post
  likedByDialog(index, DataProvider value) {
    return AlertDialog(
      backgroundColor: CColors.background,
      title: const Text(
        "Liked By:",
      ),
      titleTextStyle: TextStyle(color: CColors.secondary),
      content: Container(
        constraints: const BoxConstraints(
          maxHeight: 340,
        ),
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: value.allPosts[index].likedby?.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                            value.allPosts[index].likedby?[i],
                          )
                          ?.image as String)),
                  title: Text(
                    value
                        .getPosterData(value.allPosts[index].likedby?[i])!
                        .username,
                    style: TextStyle(
                        color: CColors.secondarydark,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    value
                        .getPosterData(value.allPosts[index].likedby?[i])!
                        .country as String,
                    style: TextStyle(
                        color: CColors.secondary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// main container of post
  postContainer(context, DataProvider value, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        //main container for post
        decoration: BoxDecoration(
            color: CColors.bottomAppBarcolor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ]),
        child: Column(
            //main column of post container
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // for poster avatar, name and more button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: CColors.secondarydark,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage: value.userData != null
                            ? NetworkImage(value
                                .getPosterData(
                                  value.allPosts[index].posterUid,
                                )
                                ?.image as String) as ImageProvider
                            : const AssetImage('assets/images/dummyuser.jpg'),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        value
                            .getPosterData(
                              value.allPosts[index].posterUid,
                            )!
                            .username,
                        style: TextStyle(
                            color: CColors.secondarydark, fontSize: 16),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          IconlyLight.more_square,
                          color: CColors.secondary,
                        )),
                  ],
                ),
              ),

              //for post caption
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  value.allPosts[index].caption,
                  style: TextStyle(color: CColors.secondary),
                ),
              ),

              //for post image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 350,
                      minHeight: 400,
                      minWidth: 350,
                    ),
                    child: Image.network(
                      value.allPosts[index].image,
                    ),
                  ),
                ),
              ),
              //like, comment and share buttons
              Row(
                children: [
                  //like button
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return likedByDialog(index, value);
                            },
                          );
                        },
                        onTap: () {
                          if (value.allPosts[index].likedby!
                              .contains(value.uid)) {
                            Functions.removeLike(value.allPosts[index].postid,
                                value.userData!.id);
                          } else {
                            Functions.addLike(value.allPosts[index].postid,
                                value.userData!.id);
                          }
                          print(value.allPosts[index].postid);
                        },
                        child: Icon(
                          value.allPosts[index].likedby!.contains(value.uid)
                              ? IconlyBold.heart
                              : IconlyLight.heart,
                          color: CColors.secondary,
                        )),
                  ),
                  Text(
                    value.allPosts[index].likedby!.length.toString(),
                    style: TextStyle(color: CColors.secondary),
                  ),
                  //comment button
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return commentDialog(index);
                          },
                        );
                      },
                      icon: Icon(
                        IconlyLight.chat,
                        color: CColors.secondary,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconlyLight.send,
                        color: CColors.secondary,
                      )),
                ],
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Consumer<FunctionsProvider>(
          builder: (context, value1, child) {
            return Scaffold(
                backgroundColor: CColors.background,
                body: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      children: [
                        //logo with user profile avatar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundColor: CColors.secondary,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                backgroundImage: value.userData != null
                                    ? NetworkImage(value.userData!.image!)
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/dummyuser.jpg'),
                                child: null,
                              ),
                            ),
                            Image.asset(
                              "assets/images/logo2.png",
                              width: 80,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  IconlyLight.notification,
                                  color: CColors.secondary,
                                ))
                          ],
                        ),
                        Divider(
                          color: CColors.primary,
                        ),
                        //for posts
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.allPosts.length,
                            itemBuilder: (context, index) {
                              return postContainer(context, value, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
}
