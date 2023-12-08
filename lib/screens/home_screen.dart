import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/providers/functions_provider.dart';
import 'package:uplifty/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Consumer<FunctionsProvider>(
          builder: (context, value1, child) {
            return Scaffold(
                backgroundColor: CColors.background,
                body: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        Divider(
                          color: CColors.primary,
                        ),

                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 1 / 1.5),
                            itemCount: value.allPosts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Container(
                                  //main container for post
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
                                      //main column of post container
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // for poster avatar, name and more button
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    CColors.secondarydark,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: value
                                                              .userData !=
                                                          null
                                                      ? NetworkImage(
                                                        value.getPosterData(value.allPosts[index].posterUid,)?.image as String)
                                                          as ImageProvider
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
                                                  value.getPosterData(value.allPosts[index].posterUid,)!.username,
                                                  style: TextStyle(
                                                      color:CColors.secondarydark,
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

                                        //for post caption
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: Text(
                                            value.allPosts[index].caption,
                                            style: TextStyle(
                                                color: CColors.secondary),
                                          ),
                                        ),

                                        //for post image
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                maxHeight: 400,
                                                maxWidth: 350,
                                                minHeight: 400,
                                                minWidth: 350,
                                              ),
                                              child: Image.network(
                                                value.allPosts[index].image,
                                              ),
                                            ),
                                          ),
                                        ),
                                        //like, comment and share buttons
                                        Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: -12,
                                          children: [
                                            //like button
                                            IconButton(
                                                onPressed: () {
                                                  value1.liked(index);
                                                },
                                                icon: Icon(
                                                  value1.favlist.contains(index)
                                                      ? IconlyBold.heart
                                                      : IconlyLight.heart,
                                                  color: CColors.secondary,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                },
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
      },
    );
  }
}
