import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/friends/myfriends_screen.dart';
import 'package:uplifty/utils/colors.dart';

class ChatDashboard extends StatelessWidget {
  const ChatDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: CColors.background,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //page title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //page title
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            IconlyLight.plus,
                            color: CColors.secondary,
                            size: 28,
                          )),
                    ),
                    Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CColors.primary),
                    ),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return MyFriends(
                                isComingfromChatD: true,
                              );
                            },
                          );
                        },
                        icon: Icon(
                          IconlyLight.plus,
                          color: CColors.secondary,
                          size: 28,
                        )),
                  ],
                ),
                Divider(color: CColors.primary),
                Expanded(
                    child: ListView.builder(
                  itemCount: value.userData?.chatwith?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: CColors.bottomAppBarcolor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              )
                            ]),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(value
                                  .getPosterData(
                                      value.userData?.chatwith?[index])
                                  ?.image as String)),
                          title: Text(
                            value
                                .getPosterData(
                                    value.userData?.chatwith?[index])!
                                .username,
                            style: TextStyle(
                                color: CColors.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          // subtitle: Text(
                          //   value.userData?.chatwith?[index],
                          //   style: TextStyle(color: CColors.secondarydark),
                          // ),
                          //  trailing: Text(DateFormat('hh:mm a').format(value1.postCommentsList![i].timestamp)),
                        ),
                      ),
                    );
                  },
                ))
              ],
            ),
          )),
        );
      },
    );
  }
}
