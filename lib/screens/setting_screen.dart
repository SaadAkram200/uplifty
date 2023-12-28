// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/create_profile.dart';
import 'package:uplifty/screens/friends/friend_request.dart';
import 'package:uplifty/screens/friends/myfriends_screen.dart';
import 'package:uplifty/screens/user_posts.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/utils/dialogs.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CColors.background,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<DataProvider>(builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //page name
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: CColors.primary),
                      ),
                    ),
                    Divider(color: CColors.primary),
                    
                    //profile details
                    Expanded(
                      child: Column(
                       // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialogs.profileViewer(
                                      value.userData!.image as String);
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 72,
                              backgroundColor: CColors.secondary,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                backgroundImage: value.userData != null
                                    ? NetworkImage(value.userData!.image!)
                                        as ImageProvider
                                    : const AssetImage(
                                        'assets/images/dummyuser.jpg'),
                                child: null,
                              ),
                            ),
                          ),
                          Text(
                            value.userData != null
                                ? value.userData!.username
                                : 'loading',
                            style: TextStyle(
                                color: CColors.secondary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            value.userData != null
                                ? value.userData!.email
                                : 'loading',
                            style: TextStyle(
                                color: CColors.secondary, fontSize: 16),
                          ),
                          Text(
                            value.userData != null
                                ? value.userData!.phone
                                : 'loading',
                            style: TextStyle(
                                color: CColors.secondary, fontSize: 16),
                          ),
                          //edit profile button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateProfile(
                                              userData: value.userData,
                                              isEditing: true),
                                        ),
                                        (route) => true);
                                  },
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        color: CColors.primary, fontSize: 18),
                                  )),
                              Text(
                                "|",
                                style: TextStyle(color: CColors.secondary),
                              ),
                              //view post button
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserPosts(),
                                        ),
                                        (route) => true);
                                  },
                                  child: Text(
                                    "Your Posts",
                                    style: TextStyle(
                                        color: CColors.primary, fontSize: 18),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //buttons
                    SettingsButton(
                      icon: IconlyLight.user,
                      buttonName: "My Friends",
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyFriends(),
                            ),
                            (route) => true);
                      },
                    ),
                    SettingsButton(
                      icon: IconlyLight.add_user,
                      buttonName: "Friend Requests",
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FriendRequest(),
                            ),
                            (route) => true);
                      },
                    ),
                    SettingsButton(
                      icon: IconlyLight.password,
                      buttonName: "Reset Password",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialogs.resetPasswordDialog(
                                context,
                                currentPassController,
                                newPassController);
                          },
                        );
                      },
                    ),
                    SettingsButton(
                      icon: IconlyLight.delete,
                      buttonName: "Delete Account",
                      onTap: () {
                        Functions.showToast("No functionality yet");
                      },
                    ),
                    SettingsButton(
                      icon: IconlyLight.logout,
                      buttonName: "Log Out",
                      onTap: () {
                        Functions.signOut(context);
                      },
                    ),
                  ],
                );
              })),
        ));
  }
}
