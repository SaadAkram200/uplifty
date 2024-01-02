// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCall extends StatelessWidget {
  String receiverID, callerName, callerID;
  late String callID;
  AudioCall({
    super.key,
    required this.receiverID,
    required this.callerName,
    required this.callerID,
  });

  callIdCreater(String callerID, String receiverID){
     List<String> list = [callerID, receiverID];
    list.sort();
    callID = list.join("_");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ZegoUIKitPrebuiltCall(
        appID: 1720656719,
        appSign:
            "87e43114bfccfe12bbf4b8fee8025c4b43afd81ce49f09451ec34addb6a3d8b7",
        callID: receiverID,
        userID: callerID,
        userName: callerName,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          ..onOnlySelfInRoom = ((context) => Navigator.pop(context)),
      )),
    );
  }
}
