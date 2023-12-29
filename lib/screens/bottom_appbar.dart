import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/screens/app_screens/home_screen.dart';
import 'package:uplifty/screens/app_screens/search_screen.dart';
import 'package:uplifty/screens/app_screens/setting_screen.dart';
import 'package:uplifty/screens/chats/chat_dashboard.dart';
import 'package:uplifty/utils/bottomsheets.dart';
import 'package:uplifty/utils/colors.dart';
import 'package:uplifty/utils/functions.dart';

class BottomAppBarClass extends StatefulWidget {
  const BottomAppBarClass({super.key});

  @override
  State<BottomAppBarClass> createState() => _BottomAppBarClassState();
}

class _BottomAppBarClassState extends State<BottomAppBarClass> {
  final pageOptions = [
    HomeScreen(),
    const ChatDashboard(),
    SearchScreen(),
    SettingScreen(),
  ];

// for initializing the Functions constructor
// changing the uid
  late Functions functions;
  @override
  void initState() {
    functions = Functions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FunctionsProvider>(builder: (context, value, child) {
      return Scaffold(
        backgroundColor: CColors.background,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           BottomSheets. selectPostType(context);
          },
          tooltip: 'Increment',
          elevation: 5.0,
          backgroundColor: CColors.secondary,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: CColors.bottomAppBarcolor,
          notchMargin: 6,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Homescreen
                IconButton(
                  iconSize: 30.0,
                  padding: const EdgeInsets.only(left: 28.0),
                  icon: Icon(IconlyLight.home,
                      color: value.selectedPage == 0
                          ? CColors.secondary
                          : CColors.background),
                  onPressed: () {
                    value.onTabTapped(0);
                  },
                ),

                //chat screen
                IconButton(
                  iconSize: 30.0,
                  padding: const EdgeInsets.only(right: 28.0),
                  icon: Icon(IconlyLight.chat,
                      color: value.selectedPage == 1
                          ? CColors.secondary
                          : CColors.background),
                  onPressed: () {
                    value.onTabTapped(1);
                  },
                ),

                //search screen
                IconButton(
                  iconSize: 30.0,
                  padding: const EdgeInsets.only(left: 28.0),
                  icon: Icon(IconlyLight.search,
                      color: value.selectedPage == 2
                          ? CColors.secondary
                          : CColors.background),
                  onPressed: () {
                    value.onTabTapped(2);
                  },
                ),

                //setting screen
                IconButton(
                  iconSize: 30.0,
                  padding: const EdgeInsets.only(right: 28.0),
                  icon: Icon(IconlyLight.setting,
                      color: value.selectedPage == 3
                          ? CColors.secondary
                          : CColors.background),
                  onPressed: () {
                    setState(() {
                      value.onTabTapped(3);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        body: pageOptions[value.selectedPage],
      );
    });
  }
}
