// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/screens/home_screen.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';
import 'package:uplifty/utils/reusables.dart';
import 'package:country_picker/country_picker.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  //for image
  String? imageUrl = '';
  XFile? selectedImage;

  profileCreation() async {
     imageUrl = await Functions.uploadFile(selectedImage!);
      setState(() {});
    if (usernameController.text == "" ||
        phoneController.text == "" ||
        countryController.text == "" ||
        addressController.text == "") {
      Functions.showToast("Please fill all the fields");
    } else if (imageUrl == '') {
      Functions.showToast("Please select the profile picture");
     
    } else {
      Functions.showLoading(context);

      imageUrl = await Functions.uploadFile(selectedImage!);
      setState(() {});
      final user = UserModel(
          username: usernameController.text,
          email: Functions.userEmail as String,
          phone: phoneController.text,
          country: countryController.text,
          address: addressController.text,
          image: imageUrl);

      Functions.createNewUser(user).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  //textfield controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  countryPicker(context) {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 25,
          backgroundColor: CColors.background,
          textStyle: TextStyle(fontSize: 16, color: CColors.secondarydark),
          bottomSheetHeight: 500, // Optional. Country list modal height
          //Optional. Sets the border radius for the bottomsheet.
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              focusColor: CColors.secondary,
              hintText: "Start typing to search",
              hintStyle: TextStyle(color: CColors.secondary),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: CColors.secondary)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: CColors.secondary)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: CColors.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(30)))),
        ),
        onSelect: (Country country) {
          countryController.text = country.displayNameNoCountryCode;
        });
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
                  "Create Profile",
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
                  //Functions.uploadImage();
                  //imageUrl = Functions.uploadImage().toString();

                  selectedImage = await Functions.imagePicker();
                  setState(() {});
                },
              ),

              //username textfield
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: UpliftyTextfields(
                    controller: usernameController, fieldName: "User Name"),
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
              ),

              //Address
              UpliftyTextfields(
                controller: addressController,
                fieldName: "Address",
                maxLines: 3,
              ),

              //get started
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: SignButton(
                    buttonName: "Get Started",
                    onPressed: () {
                      profileCreation();
                    }),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
