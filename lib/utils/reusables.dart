// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uplifty/models/post_model.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/chats/chat_screen.dart';
import 'package:uplifty/utils/app_images.dart';
import 'package:uplifty/utils/bottomsheets.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/dialogs.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:video_player/video_player.dart';

// sign button
class SignButton extends StatelessWidget {
  final String buttonName;
  void Function()? onPressed;
  SignButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [CColors.secondary, CColors.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: ElevatedButton(
          style: const ButtonStyle(
              shadowColor: MaterialStatePropertyAll(Colors.transparent),
              backgroundColor: MaterialStatePropertyAll(Colors.transparent),
              minimumSize: MaterialStatePropertyAll(Size(double.infinity, 45))),
          onPressed: onPressed,
          child: Text(
            buttonName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )),
    );
  }
}

//textfield
class UpliftyTextfields extends StatefulWidget {
  final TextEditingController controller;
  final String fieldName;
  final bool obscureText, readOnly;
  final int maxLines;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  void Function()? onTap;
  void Function(String)? onChanged;
  void Function()? suffixIconOnpressed;
  void Function()? prefixIconOnpressed;

  UpliftyTextfields({
    super.key,
    required this.controller,
    required this.fieldName,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.onChanged,
    this.suffixIconOnpressed,
    this.prefixIconOnpressed,
  });

  @override
  State<UpliftyTextfields> createState() => _UpliftyTextfieldsState();
}

class _UpliftyTextfieldsState extends State<UpliftyTextfields> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(0, 4), // Shadow position
              ),
            ]),
        child: TextField(
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          minLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          obscureText: showPassword, //widget.obscureText,
          controller: widget.controller,
          inputFormatters: widget.keyboardType == TextInputType.phone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [],
          cursorColor: CColors.secondary,
          style: TextStyle(
            color: CColors.secondary,
          ),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              prefixIcon: IconButton(
                onPressed: widget.prefixIconOnpressed,
                icon: Icon(
                  widget.prefixIcon,
                  color: CColors.secondary,
                ),
                color: CColors.secondary,
              ),
              suffixIcon: widget.suffixIcon == IconlyLight.show
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword ? IconlyLight.show : IconlyLight.hide,
                        color: CColors.secondary,
                      ))
                  : IconButton(
                      onPressed: widget.suffixIconOnpressed,
                      icon: Icon(
                        widget.suffixIcon,
                        color: CColors.secondary,
                      ),
                      color: CColors.secondary,
                    ),
              filled: true,
              fillColor: Colors.white,
              hintText: widget.fieldName,
              hintStyle: TextStyle(color: CColors.secondary),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(30)))),
        ),
      ),
    );
  }
}

// Profile avatar
class ProfileAvatar extends StatelessWidget {
  void Function()? onTap;
  XFile? selectedImage;
  String? imageUrl;
  ProfileAvatar({
    super.key,
    required this.onTap,
    this.selectedImage,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 82,
      backgroundColor: CColors.secondary,
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.white,
        backgroundImage: (imageUrl == null || selectedImage != null)
            ? (selectedImage == null
                ? AssetImage(AppImages.dummyuser)
                : FileImage(File(selectedImage!.path)) as ImageProvider)
            : NetworkImage(imageUrl!),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: onTap,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: CColors.background,
                child: Icon(
                  IconlyLight.camera,
                  color: CColors.secondary,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

//for audio message container
class AudioMessageBox extends StatefulWidget {
  AudioMessageBox({super.key, required this.link});

  String link;
  @override
  State<AudioMessageBox> createState() => _AudioMessageBoxState();
}

class _AudioMessageBoxState extends State<AudioMessageBox> {
  bool isPlaying = false;
  late AudioPlayer audioPlayer;
  double currentPosition = 0;
  double audioDuration = 0;

  String getFormattedDuration(double milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds.toInt());
    String minutes = (duration.inMinutes).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        currentPosition = duration.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = !isPlaying;
        currentPosition = 0;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      var audiolink = UrlSource(widget.link);
      await audioPlayer.play(audiolink);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            playPause();
          },
          child: Icon(
            isPlaying == true
                ? Icons.pause_circle_outline_rounded
                : Icons.play_circle_outline_rounded,
            color: CColors.primary,
            size: 35,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slider(
              thumbColor: CColors.primary,
              inactiveColor: CColors.background,
              activeColor: CColors.primary,
              value: currentPosition,
              min: 0,
              max: audioDuration,
              onChanged: (v) {
                audioPlayer.seek(Duration(milliseconds: v.toInt()));
              },
            ),
            //Text(getFormattedDuration(currentPosition)),
          ],
        ),
      ],
    );
  }
}

//for settings
class SettingsButton extends StatelessWidget {
  void Function()? onTap;
  final String buttonName;
  final IconData icon;
  SettingsButton({
    super.key,
    required this.onTap,
    required this.buttonName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: CColors.secondary,thickness: 0.5),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: CColors.secondary,
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                    child: Text(
                  buttonName,
                  style: TextStyle(color: CColors.secondary, fontSize: 18),
                )),
                Icon(
                  IconlyLight.arrow_right_2,
                  color: CColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//page name and back button
class PageName extends StatelessWidget {
  void Function()? onPressed;
  final String pageName;
  PageName({super.key, required this.pageName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //backbutton
        IconButton(
            onPressed: onPressed,
            icon: Icon(
              IconlyLight.arrow_left_2,
              color: CColors.secondary,
              size: 30,
            )),

        //page name
        Expanded(
          child: Text(
            pageName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CColors.primary),
          ),
        ),
        Opacity(
          opacity: 0,
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                IconlyLight.arrow_left_2,
                size: 30,
              )),
        ),
      ],
    );
  }
}

//for video player
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoController;
  @override
  void initState() {
    videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) {
            setState(() {
              videoController.play();
            });
          });
    super.initState();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (videoController.value.isCompleted) {
            videoController.play();
          }
        },
        child: VideoPlayer(videoController));
  }
}

//container of post
//used in home screen and user posts
class PostContainer extends StatefulWidget {
  DataProvider value;
  int index;
  bool isUserPosts;
  TextEditingController commentController;
  PostContainer({
    super.key,
    required this.value,
    required this.index,
    required this.commentController,
    required this.isUserPosts,
  });

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  late List<PostModel> post;
  checkScreen() {
    if (widget.isUserPosts) {
      post = widget.value.userPosts;
    } else {
      post = widget.value.allPosts;
    }
    setState(() {});
  }

  @override
  void initState() {
    checkScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        //main container for post
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
        child: Column(
            //main column of post container
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // for poster avatar, name and more button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: CColors.secondarydark,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.value.userData != null
                            ? NetworkImage(widget.value
                                .getPosterData(post[widget.index].posterUid)
                                ?.image as String) as ImageProvider
                            : AssetImage(AppImages.dummyuser),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.value
                              .getPosterData(
                                post[widget.index].posterUid,
                              )!
                              .username,
                          style: TextStyle(
                              color: CColors.secondarydark,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat('hh:mm a')
                              .format(post[widget.index].timestamp),
                          style:
                              TextStyle(color: CColors.secondary, fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          if (widget.isUserPosts) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialogs.deletePostDialog(
                                    context, post[widget.index].postid);
                              },
                            );
                          }
                        },
                        icon: Icon(
                          IconlyLight.more_square,
                          color: CColors.secondary,
                        )),
                  ],
                ),
              ),

              //for post caption
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  post[widget.index].caption,
                  style: TextStyle(color: CColors.secondarydark),
                ),
              ),

              //for post image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                        maxWidth: 350,
                        minHeight: 400,
                        minWidth: 350,
                      ),
                      child: post[widget.index].type == "image"
                          ? CachedNetworkImage(
                              imageUrl: post[widget.index].image,
                            )
                          : VideoPlayerWidget(
                              videoUrl: post[widget.index].image)),
                ),
              ),
              //like, comment and share buttons
              Row(
                children: [
                  //like button
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialogs.likedByDialog(widget.index,
                                  widget.value, widget.isUserPosts);
                            },
                          );
                        },
                        onTap: () {
                          if (post[widget.index]
                              .likedby!
                              .contains(widget.value.uid)) {
                            Functions.removeLike(post[widget.index].postid,
                                widget.value.userData!.id);
                          } else {
                            Functions.addLike(post[widget.index].postid,
                                widget.value.userData!.id);
                          }
                        },
                        child: Icon(
                          post[widget.index].likedby!.contains(widget.value.uid)
                              ? IconlyBold.heart
                              : IconlyLight.heart,
                          color: CColors.secondary,
                        )),
                  ),
                  Text(
                    post[widget.index].likedby!.length.toString(),
                    style: TextStyle(color: CColors.secondary),
                  ),
                  //comment button
                  IconButton(
                      onPressed: () {
                        BottomSheets.commentsBottomSheet(
                            context,
                            widget.index,
                            widget.value,
                            widget.commentController,
                            widget.isUserPosts);
                        //commentsBottomSheet(context, index, value);
                      },
                      icon: Icon(
                        IconlyLight.chat,
                        color: CColors.secondary,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        IconlyLight.send,
                        color: CColors.secondary,
                      )),
                ],
              )
            ]),
      ),
    );
  }
}

//used in chat dashboard screen
class ChatDashboardTile extends StatelessWidget {
  DataProvider value;
  int index;
  ChatDashboardTile({
    super.key,
    required this.value,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        child: InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      friendID: value
                          .getPosterData(value.userData!.chatwith![index])!
                          .id),
                ),
                (route) => true);
          },
          child: ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(value
                    .getPosterData(value.userData!.chatwith![index])
                    ?.image as String)),
            title: Text(
              value.getPosterData(value.userData!.chatwith![index])!.username,
              style: TextStyle(
                  color: CColors.secondarydark,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Row(
              children: [
                if (value.allChats.isNotEmpty &&
                    value.allChats[index].senderID == value.uid)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 5),
                    child: value.allChats[index].isReaded == false
                        ? Image.asset(
                            AppImages.unseen,
                            scale: 3,
                          )
                        : Image.asset(
                            AppImages.seen,
                            scale: 3,
                          ),
                  ),
                if (value.allChats.isNotEmpty)
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 155, maxHeight: 20),
                    child: Text(
                      value.allChats[index].messageText,
                      style: TextStyle(
                          color: CColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.allChats.isNotEmpty
                      ? DateFormat('hh:mm a')
                          .format(value.allChats[index].timestamp)
                      : "",
                  style: TextStyle(color: CColors.primary, fontSize: 16),
                ),
                Badge(
                  backgroundColor: CColors.primary,
                  isLabelVisible: (value.allChats.isNotEmpty &&
                          value.allChats[index].isReaded == false &&
                          value.allChats[index].senderID != value.uid)
                      ? true
                      : false,
                  smallSize: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
