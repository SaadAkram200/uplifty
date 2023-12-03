import 'package:flutter/material.dart';
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
  filterSearchResults(String query, List<UserModel?> allUsers) {
    foundUsers = allUsers
        .where((user) =>
            user!.username.toLowerCase().contains(query.toLowerCase()))
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
}
