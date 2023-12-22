// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uplifty/screens/signup_screen.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  //textfield controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //logo
                Image.asset(
                  "assets/images/logo.png",
                  scale: 1.5,
                ),

                //page name
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    "Login",
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

                //forget password
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: CColors.primary),
                        ))),

                //login button
                Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 20),
                  child: SignButton(
                      buttonName: "Login",
                      onPressed: () {
                        Functions.logIn(
                            context, emailController, passwordController);
                      }),
                ),

                //sign up text button
                RichText(
                    text: TextSpan(
                        text: "New around here?",
                        style: TextStyle(color: CColors.primary),
                        children: [
                      TextSpan(
                          text: " Sign Up",
                          style: TextStyle(
                              color: CColors.secondarydark,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                  (route) => true);
                            })
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
