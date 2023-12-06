import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Scaffold(
            backgroundColor: CColors.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    //logo with user profile avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: CColors.secondary,
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            backgroundImage: value.userData != null
                                ? NetworkImage(value.userData!.image!)
                                    as ImageProvider
                                : const AssetImage(
                                    'assets/images/dummyuser.jpg'),
                            child: null,
                          ),
                        ),
                        Image.asset(
                          "assets/images/logo2.png",
                          width: 80,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              IconlyLight.notification,
                              color: CColors.secondary,
                            ))
                      ],
                    ),
                    Divider(color: CColors.primary),

                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CColors.bottomAppBarcolor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                    )
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // for poster avatar, name and more button
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: CColors.secondary,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              backgroundImage: value.userData !=
                                                      null
                                                  ? NetworkImage(value.userData!
                                                      .image!) as ImageProvider
                                                  : const AssetImage(
                                                      'assets/images/dummyuser.jpg'),
                                              child: null,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              value.userData != null
                                                  ? value.userData!.username
                                                  : 'loading',
                                              style: TextStyle(
                                                  color: CColors.secondary,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                IconlyLight.more_square,
                                                color: CColors.secondary,
                                              ))
                                        ],
                                      ),
                                    ),

                                    //for post image
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: Image.asset(
                                            "assets/images/picture.png"),
                                      ),
                                    ),
                                    //for like comment and share
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: -15,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              IconlyLight.heart,
                                              color: CColors.secondary,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              IconlyLight.chat,
                                              color: CColors.secondary,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              IconlyLight.send,
                                              color: CColors.secondary,
                                            )),
                                      ],
                                    )
                                  ]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
