// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';
import 'package:country_picker/country_picker.dart';

class CreateProfile extends StatefulWidget {
  UserModel? userData;
  bool isEditing;
  CreateProfile({
    super.key,
    this.userData,
    this.isEditing = false,
  });

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  @override
  void initState() {
    if (widget.userData != null) {
      displayData(widget.userData);
    } else {
      widget.userData = null;
    }
    super.initState();
  }

  //for image
  String? imageUrl = '';
  XFile? selectedImage;

  //textfield controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  //display userdata in textfields
  displayData(UserModel? userData) {
    usernameController.text = userData!.username;
    countryController.text = userData.country!;
    phoneController.text = userData.phone;
    addressController.text = userData.address!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.background,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              //page name
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Text(
                  widget.isEditing ? "Edit Profile" : "Create Profile",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CColors.primary),
                ),
              ),

              // Profile avatar
              ProfileAvatar(
                imageUrl: widget.userData?.image!,
                selectedImage: selectedImage,
                onTap: () async {
                  selectedImage = await Functions.imagePicker();
                  setState(() {});
                },
              ),

              //username textfield
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: UpliftyTextfields(
                  controller: usernameController,
                  fieldName: "User Name",
                  keyboardType: TextInputType.name,
                ),
              ),

              //country textfield
              UpliftyTextfields(
                controller: countryController,
                fieldName: "Country",
                readOnly: true,
                onTap: () {
                  Functions.countryPicker(context, (Country country) {
                    countryController.text = country.displayNameNoCountryCode;
                  });
                },
                icon: IconlyLight.arrow_down_2,
              ),

              //phone textfield
              UpliftyTextfields(
                controller: phoneController,
                fieldName: "Phone Number",
                keyboardType: TextInputType.phone,
              ),

              //Address
              UpliftyTextfields(
                controller: addressController,
                fieldName: "Address",
                maxLines: 3,
                keyboardType: TextInputType.streetAddress,
              ),

              //get started
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: SignButton(
                    buttonName:
                        widget.isEditing ? "Edit Profile" : "Get Started",
                    onPressed: () {
                      // displayData(value.userData!);
                      Functions.profileCreation(
                          context,
                          selectedImage,
                          widget.userData?.image!,
                          usernameController,
                          phoneController,
                          countryController,
                          addressController,
                          widget.isEditing);
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
