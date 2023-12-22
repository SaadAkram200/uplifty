// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplifty/utils/colors.dart';

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
  bool showPassword =false;

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
              ? IconButton(onPressed: (){
                setState(() {
                  showPassword = !showPassword;
                });
              },
               icon: Icon(
                showPassword ? IconlyLight.show : IconlyLight.hide,
                color: CColors.secondary,))
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
                ? AssetImage("assets/images/dummyuser.jpg")
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
        Divider(color: CColors.primary),
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
