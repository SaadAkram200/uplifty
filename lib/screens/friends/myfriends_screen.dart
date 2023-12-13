import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/user_profile.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/reusables.dart';

// ignore: must_be_immutable
class MyFriends extends StatelessWidget {
  MyFriends({super.key});

//to get the freindrequests
  late List<UserModel>? listMyFriends;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        listMyFriends = value.getMyFriends();

        return Scaffold(
          backgroundColor: CColors.background,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //page name and back button
                PageName(
                  pageName: "My Friends",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(color: CColors.primary),

                //to show all the friendrequets of current User
                Expanded(
                    child: ListView.builder(
                  itemCount: value.myFrinedsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfile( friendID: listMyFriends![index].id,),
                              ),
                              (route) => true);
                        },
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
                                backgroundImage:
                                    NetworkImage(listMyFriends![index].image!)),
                            title: Text(
                              listMyFriends![index].username,
                              style: TextStyle(
                                  color: CColors.secondarydark,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(listMyFriends![index].country!,
                                style: TextStyle(color: CColors.secondarydark)),
                          ),
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          )),
        );
      },
    );
  }
}
