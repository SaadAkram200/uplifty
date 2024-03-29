// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uplifty/utils/app_images.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  //textfield controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: fields(context),
          ),
        ),
      ),
    );
  }

  Column fields(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //logo
              Image.asset(
                AppImages.logo,
                scale: 1.5,
              ),

              //page name
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CColors.primary),
                ),
              ),
              //email textfield
              UpliftyTextfields(
                controller: emailController,
                fieldName: "Email",
                prefixIcon: IconlyLight.message,
                keyboardType: TextInputType.emailAddress,
              ),

              //password textfield
              UpliftyTextfields(
                controller: passwordController,
                fieldName: "password",
                prefixIcon: IconlyLight.password,
                obscureText: true,
                suffixIcon: IconlyLight.show,
              ),

              //confirm password
              UpliftyTextfields(
                controller: confirmPassController,
                fieldName: "Confirm Password",
                prefixIcon: IconlyLight.password,
                obscureText: true,
              ),

              //Sign Up button
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                child: SignButton(
                    buttonName: "Sign Up",
                    onPressed: () {
                      Functions.signUp(context, emailController,
                          passwordController, confirmPassController);
                    }),
              ),

              //Login text button
              RichText(
                text: TextSpan(
                  text: "Already have an account?",
                  style: TextStyle(color: CColors.primary),
                  children: [
                    TextSpan(
                      text: " Login",
                      style: TextStyle(
                          color: CColors.secondarydark,
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
