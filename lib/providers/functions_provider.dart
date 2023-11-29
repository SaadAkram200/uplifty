import 'package:flutter/material.dart';

class FunctionsProvider with ChangeNotifier {
  
  //for bottom appbar
  int selectedPage = 0;
  onTabTapped(int index) {
    selectedPage = index;
    notifyListeners();
  }
}
