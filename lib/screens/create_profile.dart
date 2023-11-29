// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';
import 'package:country_picker/country_picker.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  //for image
  String? imageUrl = '';
  XFile? selectedImage;

  //textfield controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
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
                  value.userData != null? "Edit Profile": "Create Profile",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CColors.primary),
                ),
              ),

              // Profile avatar
              ProfileAvatar(
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
                iconButton: IconButton(
                  onPressed: () {
                    Functions.countryPicker(context, (Country country) {
                      countryController.text = country.displayNameNoCountryCode;
                    });

                    // countryPicker(context);
                  },
                  icon: Icon(
                    IconlyLight.arrow_down_2,
                    color: CColors.secondary,
                  ),
                ),
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
                    buttonName: "Get Started",
                    onPressed: () {
                      Functions.profileCreation(
                          context,
                          selectedImage,
                          usernameController,
                          phoneController,
                          countryController,
                          addressController);
                    }),
              ),
            ],
          ),
        ),
      )),
    );
    },);
    
  }
}
