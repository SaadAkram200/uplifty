// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/screens/bottom_appbar.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class AddPost extends StatelessWidget {
  AddPost({super.key});

  TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<FunctionsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: CColors.background,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //page name and back button
                PageName(
                    pageName: "Create new Post",
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Divider(
                  color: CColors.primary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: UpliftyTextfields(
                    controller: captionController,
                    fieldName: "Add caption",
                    prefixIcon: Icons.chat_bubble_outline_rounded,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    value.imagePicker(true);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: CColors.bottomAppBarcolor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          )
                        ]),
                    constraints: const BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 350,
                      minHeight: 400,
                      minWidth: 350,
                    ),
                    child: value.selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconlyLight.image,
                                color: CColors.secondary,
                                size: 100,
                              ),
                              Text(
                                "Select Image",
                                style: TextStyle(
                                    color: CColors.secondary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        : Image(
                            image: FileImage(File(value.selectedImage!.path))),
                  ),
                ),

                const Spacer(),
                //post button
                SignButton(
                  buttonName: "Post",
                  onPressed: () async {
                    await Functions.postCreation(
                        context, value.selectedImage, captionController);
                    value.selectedImage = null;
                    captionController.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomAppBarClass(),
                        ),
                        (route) => false);
                  },
                ),
                const Spacer(),
              ],
            ),
          )),
        );
      },
    );
  }
}
