// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/utils/app_images.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/reusables.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
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
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      //logo with user profile avatar
                      header(value),
                      Divider(color: CColors.secondary, thickness: .5),
                      //for posts
                      Expanded(
                        child: ListView.builder(
                          itemCount: value.allPosts.length,
                          itemBuilder: (context, index) {
                            return PostContainer(
                                value: value,
                                index: index,
                                commentController: commentController,
                                isUserPosts: false);
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

  Row header(DataProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 27,
          backgroundColor: CColors.secondary,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: value.userData != null
                ? NetworkImage(value.userData!.image!) as ImageProvider
                : AssetImage(AppImages.dummyuser),
            child: null,
          ),
        ),
        Image.asset(
          AppImages.logo2,
          width: 80,
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              IconlyLight.notification,
              color: CColors.secondary,
            ))
      ],
    );
  }
}
