// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/reusables.dart';

class UserPosts extends StatelessWidget {
  UserPosts({super.key});

  TextEditingController commentController = TextEditingController();

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
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      PageName(
                          pageName: "Your Posts",
                          onPressed: () => Navigator.pop(context)),
                      Divider(color: CColors.secondary,thickness: 0.5,),
                      //for posts
                      Expanded(
                        child: ListView.builder(
                          itemCount: value.userPosts.length,
                          itemBuilder: (context, index) {
                            return PostContainer(
                                value: value,
                                index: index,
                                commentController: commentController,
                                isUserPosts: true);
                            //postContainer(context, value, index);
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
      },
    );
  }
}
