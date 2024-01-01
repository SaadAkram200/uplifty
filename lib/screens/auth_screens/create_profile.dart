// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/models/user_model.dart';
import 'package:uplifty/providers/functions_provider.dart';
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
  late Functions functions;
  //to check if user is coming from sign up screen or from edit profile
  @override
  void initState() {
    if (widget.userData != null) {
      displayData(widget.userData);
    } else {
      functions = Functions();
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
    return Consumer<FunctionsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: CColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    //pagename and back button
                    Row(
                      children: [
                        //back button
                        if (widget
                            .isEditing) //runs only when user is coming to edit profile
                          IconButton(
                              onPressed: () => (Navigator.pop(context)),
                              icon: Icon(
                                IconlyLight.arrow_left_2,
                                color: CColors.secondary,
                                size: 30,
                              )),
                        if (!widget.isEditing)
                          Opacity(
                            opacity: 0,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  IconlyLight.arrow_left_2,
                                  size: 30,
                                )),
                          ),
                        //page name
                        Expanded(
                          child: Text(
                            widget.isEditing
                                ? "Edit Profile"
                                : "Create Profile",
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
                    ),
                    Divider(color: CColors.primary),
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
                        prefixIcon: IconlyLight.profile,
                        keyboardType: TextInputType.name,
                      ),
                    ),

                    //country textfield
                    UpliftyTextfields(
                      controller: countryController,
                      fieldName: "Country",
                      prefixIcon: IconlyLight.location,
                      readOnly: true,
                      onTap: () {
                        Functions.countryPicker(context, (Country country) {
                          countryController.text =
                              country.displayNameNoCountryCode;
                        });
                      },
                      suffixIcon: IconlyLight.arrow_down_2,
                    ),

                    //phone textfield
                    UpliftyTextfields(
                      controller: phoneController,
                      fieldName: "Phone Number",
                      prefixIcon: IconlyLight.call,
                      keyboardType: TextInputType.phone,
                    ),

                    //Address
                    UpliftyTextfields(
                      controller: addressController,
                      fieldName: "Address",
                      maxLines: 3,
                      //prefixIcon: IconlyLight.home,
                      keyboardType: TextInputType.streetAddress,
                    ),

                    //get started
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: SignButton(
                        buttonName:
                            widget.isEditing ? "Edit Profile" : "Get Started",
                        onPressed: () async {
                          await Functions.profileCreation(
                              context,
                              selectedImage,
                              widget.userData?.image!,
                              usernameController,
                              phoneController,
                              countryController,
                              addressController,
                              widget.isEditing);

                          if (widget.isEditing) {
                            Navigator.pop(context);
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
