import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplifty/models/user_model.dart';

class FunctionsProvider with ChangeNotifier {
  //for bottom appbar
  int selectedPage = 0;
  onTabTapped(int index) {
    selectedPage = index;
    notifyListeners();
  }

  //for search friends
  List<UserModel?> foundUsers = [];
  void filterSearchResults(
      String query, UserModel currentUser, List<UserModel?> allUsers) {
    foundUsers = allUsers
        .where((user) =>
            user != null &&
            user.username.toLowerCase().contains(query.toLowerCase()) &&
            !currentUser.myfriends!.contains(user.id))
        .toList();
    notifyListeners();
    if (query == "") {
      foundUsers.clear();
    }
  }

  //for search list - used in search screen
  bool isempty = true;
  checking(TextEditingController searchController) {
    if (searchController.text != "") {
      isempty = false;
    } else {
      isempty = true;
    }
    notifyListeners();
  }

  List<UserModel> friendRequestList = [];
  getFriendRequests(UserModel? userData, List<UserModel?> allUsers) {
    friendRequestList = allUsers
        .where((user) =>
            user != null &&
            userData!.friendrequest != null &&
            userData.friendrequest!.contains(user.id))
        .map((user) => user as UserModel)
        .toList();
    notifyListeners();
  }

//for image picker
  XFile? _selectedImage;

  set selectedImage(XFile? selectedImage) {
    _selectedImage = selectedImage;
    notifyListeners();
  }

  XFile? get selectedImage => _selectedImage;

  imagePicker(bool fromGallery) async {
    ImagePicker imagePicker = ImagePicker();
    selectedImage = await imagePicker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    notifyListeners();
  }
}
