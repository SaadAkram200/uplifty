// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/create_profile.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CColors.background,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: Consumer<DataProvider>(builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //page name
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CColors.primary),
                    ),
                    const Spacer(),
                   
                   //profile details
                    CircleAvatar(
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
                    TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateProfile(userData: value.userData, isEditing: true),
                              ),
                              (route) => true);
                        },
                        child: Text(
                          "Edit Profile",
                          style:
                              TextStyle(color: CColors.primary, fontSize: 18),
                        )),
                    const Spacer(),
                    
                    //buttons
                    SettingsButton(
                      icon: IconlyLight.user,
                      buttonName: "My Friends",
                      onTap: () {},
                    ),
                    SettingsButton(
                      icon: IconlyLight.add_user,
                      buttonName: "Friend Request",
                      onTap: () {},
                    ),
                    SettingsButton(
                      icon: IconlyLight.password,
                      buttonName: "Reset Password",
                      onTap: () {},
                    ),
                    SettingsButton(
                      icon: IconlyLight.delete,
                      buttonName: "Delete Account",
                      onTap: () {
                        for (var i = 0; i < value.allUsers.length; i++) {
                          print(value.allUsers[i].username);
                        }
                        
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
