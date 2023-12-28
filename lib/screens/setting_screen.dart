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
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  //for reset password
  resetPasswordDialog(context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CColors.background,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<DataProvider>(builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const Spacer(),

                    //profile details
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Functions.profileViewer(
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
                              : const AssetImage('assets/images/dummyuser.jpg'),
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
                      style: TextStyle(color: CColors.secondary, fontSize: 16),
                    ),
                    Text(
                      value.userData != null
                          ? value.userData!.phone
                          : 'loading',
                      style: TextStyle(color: CColors.secondary, fontSize: 16),
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
                    const Spacer(),

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
                            return resetPasswordDialog(context);
                          },
                        );
                      },
                    ),
                    SettingsButton(
                      icon: IconlyLight.delete,
                      buttonName: "Delete Account",
                      onTap: () {},
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
