import 'package:flutter/material.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  
  @override
  void initState() {
   userData =  Functions.getCurrentUserData();
   setState(() {
    // print("DATA from settings :  " + userData!.email);
       });
    super.initState();
  }
  var selectedImage;
  UserModel? userData;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 const SizedBox(width: double.infinity,),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ProfileAvatar(onTap: () {}, selectedImage: selectedImage)),
                  Text(
                    userData != null
                    ? userData!.username
                    : 'loading',
                    style: TextStyle(color: CColors.secondary, fontSize: 16),
                  ),
                  Text("saad3@gmail.com"),
                  Text("03048830737"),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Edit Profile",
                        style:
                            TextStyle(color: CColors.primary, fontSize: 18),
                      )),
                
                ],
              ),
            ),
          ),
        ));
  }
}
