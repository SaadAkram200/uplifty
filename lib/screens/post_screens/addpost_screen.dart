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
import 'package:video_player/video_player.dart';

class AddPost extends StatefulWidget {
  bool isImage;
  AddPost({super.key, required this.isImage});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController captionController = TextEditingController();

  VideoPlayerController? videoController;
  void initializeVideoController(FunctionsProvider value) {
    if (value.selectedVideo != null) {
      videoController =
          VideoPlayerController.file(File(value.selectedVideo!.path))
            ..initialize().then((_) {
              videoController!.play();
              setState(() {
                type = "video";
              });
            });
    }
  }

  Widget imageContainer(FunctionsProvider value) {
    return InkWell(
      onTap: () {
        value.imagePicker(true);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
            : Image(image: FileImage(File(value.selectedImage!.path))),
      ),
    );
  }

  Widget videoContainer(FunctionsProvider value) {
    return InkWell(
      onTap: () async {
        await value.videoPicker();
        initializeVideoController(value);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: value.selectedVideo == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconlyLight.video,
                      color: CColors.secondary,
                      size: 100,
                    ),
                    Text(
                      "Select Video",
                      style: TextStyle(
                          color: CColors.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : videoController != null && videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: CColors.secondary,
                      ),
                    ),
        ),
      ),
    );
  }

  String type = "image";

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FunctionsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: CColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //page name and back button
                    PageName(
                        pageName: "Create new Post",
                        onPressed: () async {
                          value.selectedImage = null;
                          value.selectedVideo = null;
                          // print(value.selectedVideo!.mimeType);
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

                    const SizedBox(
                      height: 30,
                    ),

                    //for image post
                    if (widget.isImage) imageContainer(value),

                    //for video post
                    if (!widget.isImage) videoContainer(value),
                    if (value.selectedVideo != null)
                      IconButton(
                          onPressed: () {
                            videoController!.value.isInitialized &&
                                    videoController!.value.isPlaying
                                ? videoController?.pause()
                                : videoController?.play();
                            setState(() {});
                          },
                          icon: Icon(
                            videoController!.value.isInitialized &&
                                    videoController!.value.isPlaying
                                ? Icons.pause_circle_outline_rounded
                                : IconlyLight.play,
                            color: CColors.secondary,
                            size: 50,
                          )),
                    //post button
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: SignButton(
                        buttonName: "Post",
                        onPressed: () async {
                          if (widget.isImage) {
                            if (value.selectedImage == null) {
                              Functions.showToast("Select image to post");
                            } else {
                              await Functions.postCreation(context,
                                  value.selectedImage, captionController, type);
                              value.selectedImage = null;
                              captionController.clear();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomAppBarClass(),
                                  ),
                                  (route) => false);
                            }
                          } else {
                            if (value.selectedVideo == null) {
                              Functions.showToast("Select video to post");
                            } else {
                              await Functions.postCreation(context,
                                  value.selectedVideo, captionController, type);
                              value.selectedVideo = null;
                              captionController.clear();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomAppBarClass(),
                                  ),
                                  (route) => false);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
