import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

// ignore: must_be_immutable
class FriendRequest extends StatelessWidget {
  FriendRequest({super.key});

//to get the freindrequests
  late List<UserModel>? listFriendRequests;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        listFriendRequests = value.getFriendRequests();

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
                  pageName: "Friend Requests",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(color: CColors.primary),

                //to show all the friendrequets of current User
                Expanded(
                  child: value.userData!.friendrequest!.isNotEmpty
                      ? ListView.builder(
                          itemCount: value.friendRequestList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
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
                                        backgroundImage: NetworkImage(
                                            listFriendRequests![index].image!)),
                                    title: Text(
                                      listFriendRequests![index].username,
                                      style: TextStyle(
                                          color: CColors.secondarydark,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                        listFriendRequests![index].country!,
                                        style: TextStyle(
                                            color: CColors.secondarydark)),
                                    trailing: Wrap(
                                      spacing: -10,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Functions.acceptFriendRequest(
                                                  listFriendRequests![index]
                                                      .id);
                                            },
                                            icon: Icon(
                                              Icons.person_add_alt_1_outlined,
                                              color: CColors.secondary,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              //reject request
                                              Functions.rejectFriendRequest(
                                                  listFriendRequests![index]
                                                      .id);
                                            },
                                            icon: Icon(
                                              Icons
                                                  .person_remove_alt_1_outlined,
                                              color: CColors.secondary,
                                            )),
                                      ],
                                    )),
                              ),
                            );
                          },
                        )
                      : Text(
                          "No freind request.",
                          style:
                              TextStyle(color: CColors.secondary, fontSize: 20),
                        ),
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
