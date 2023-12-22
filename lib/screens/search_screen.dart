import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/screens/user_profile.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FunctionsProvider>(
      builder: (context, value2, child) {
        return Consumer<DataProvider>(
          builder: (context, value, child) {
            return Scaffold(
              backgroundColor: CColors.background,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      //page title
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Find friends",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CColors.primary),
                        ),
                      ),
                      Divider(color: CColors.primary),

                      //textfield for search users
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: UpliftyTextfields(
                          controller: searchController,
                          fieldName: "Seach",
                          prefixIcon: IconlyLight.search,
                          onChanged: (text) {
                            value2.filterSearchResults(text,
                                value.userData as UserModel, value.allUsers);
                            value2.checking(searchController);
                          },
                        ),
                      ),

                      //list of all the users of app
                      Expanded(
                        child: value2.foundUsers.isNotEmpty
                            ? ListView.builder(
                                itemCount: value2.foundUsers.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 5),
                                    //to see user's profile
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfile(
                                                        friendID: value2
                                                            .foundUsers[index]!
                                                            .id)),
                                            (route) => true);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: CColors.bottomAppBarcolor,
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
                                                  value2.foundUsers[index]!
                                                      .image!)),
                                          title: Text(
                                            value2.foundUsers[index]!.username,
                                            style: TextStyle(
                                                color: CColors.secondarydark,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                              value2
                                                  .foundUsers[index]!.country!,
                                              style: TextStyle(
                                                  color:
                                                      CColors.secondarydark)),
                                          trailing:
                                          value.userData!.sentrequest!.contains(value2.foundUsers[index]?.id) 
                                          ? Text("Pending", style: TextStyle(color: CColors.secondary),) 
                                          : IconButton(
                                              onPressed: () {
                                                //sends friend request
                                                Functions.sendFriendRequest(
                                                    value2
                                                        .foundUsers[index]!.id);
                                              },
                                              icon: Icon(
                                                IconlyLight.add_user,
                                                color: CColors.secondary,
                                              )),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Text(
                                value2.isempty
                                    ? "Type to find friends"
                                    : "No user found",
                                style: TextStyle(
                                    color: CColors.secondary, fontSize: 20),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
