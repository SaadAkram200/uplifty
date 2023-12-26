import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/screens/addpost_screen.dart';
import 'package:uplifty/screens/chats/chat_dashboard.dart';
import 'package:uplifty/screens/home_screen.dart';
import 'package:uplifty/screens/search_screen.dart';
import 'package:uplifty/screens/setting_screen.dart';
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
    const SettingScreen(),
  ];

// for initializing the Functions constructor
// changing the uid
  late Functions functions;
  @override
  void initState() {
    functions = Functions();
    super.initState();
  }
//bottomsheet to select post type
  selectPostType() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
              color: CColors.background,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: Icon(
                    IconlyLight.image,
                    color: CColors.secondary,
                  ),
                  title: Text(
                    'Image',
                    style: TextStyle(color: CColors.secondary),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(isImage: true),
                        ),
                        (route) => true).then(
                      (value) => Navigator.pop(context),
                    );
                  }),
              ListTile(
                leading: Icon(
                  IconlyLight.video,
                  color: CColors.secondary,
                ),
                title: Text(
                  'Video',
                  style: TextStyle(color: CColors.secondary),
                ),
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPost(isImage: false),
                    ),
                    (route) => true).then(
                  (value) => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            selectPostType();
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
                )
              ],
            ),
          ),
        ),
        body: pageOptions[value.selectedPage],
      );
    });
  }
}
