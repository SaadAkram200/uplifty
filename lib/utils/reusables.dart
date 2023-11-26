// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
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
class UpliftyTextfields extends StatelessWidget {
  final TextEditingController controller;
  final String fieldName;
  final bool obscureText, readOnly;
  final int maxLines;
  final IconButton? iconButton;
  const UpliftyTextfields(
      {super.key,
      required this.controller,
      required this.fieldName,
      this.obscureText = false,
      this.readOnly = false,
      this.maxLines = 1,
      this.iconButton,
      });

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
          maxLines: maxLines,
          minLines: maxLines,
          keyboardType: TextInputType.multiline,
          readOnly: readOnly,
          obscureText: obscureText,
          controller: controller,
          cursorColor: CColors.secondary,
          style: TextStyle(
            color: CColors.secondary,
          ),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              suffixIcon: iconButton,
              filled: true,
              fillColor: Colors.white,
              hintText: fieldName,
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
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 82,
      backgroundColor: CColors.secondary,
      child: CircleAvatar(
        radius: 80,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/images/dummyuser.jpg"),
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {},
              child: CircleAvatar(
                radius: 15,
                backgroundColor: CColors.background,
                child: Icon(
                  Icons.camera_alt_outlined,
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
