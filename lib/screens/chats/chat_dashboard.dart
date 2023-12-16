import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uplifty/providers/data_provider.dart';
import 'package:uplifty/screens/chats/chat_screen.dart';
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
                   // page title
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
                    child: value.userData!.chatwith!.isEmpty
                     ? Text(
                        "No chats yet...", 
                        style: TextStyle(color: CColors.secondary, fontSize: 20))
                     : ListView.builder(
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
                        child: InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      friendID: value
                                          .getPosterData(
                                              value.userData?.chatwith?[index])!.id),
                                ),
                                (route) => true);
                          },
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
                                  color: CColors.secondarydark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Row(
                              children: [
                               //Image.asset("assets/images/unseen5.png", scale: 3,),
                               if(value.allChats[index].senderID == value.uid)
                                Padding(
                                  padding: const EdgeInsets.only(top:2,right: 5),
                                  child: value.allChats[index].isReaded==false
                                      ? Image.asset("assets/images/unseen5.png", scale: 3,)
                                      : Image.asset("assets/images/seen5.png", scale: 3,),
                                ),
                               
                                Text(
                                  value.allChats[index].messageText,
                                  style: TextStyle(
                                    color: CColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                              trailing: Text(
                                DateFormat('hh:mm a')
                                .format(value.allChats[index].timestamp),
                                style: TextStyle(color: CColors.primary,fontSize: 16),),
                          ),
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
