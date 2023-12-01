import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/reusables.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
 final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "Find friends",
                    style: TextStyle(
                        color: CColors.secondary,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                  UpliftyTextfields(
                      controller: searchController,
                      fieldName: "Seach",
                      icon: IconlyLight.search),
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.allUsers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                                      value.allUsers[index].image!)),
                              title: Text(value.allUsers[index].username),
                              subtitle: Text(value.allUsers[index].email),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    IconlyLight.add_user,
                                    color: CColors.secondary,
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
