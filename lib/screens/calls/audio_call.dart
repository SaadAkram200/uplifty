// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCall extends StatefulWidget {
 // String receiverID, callerName, callerID;

  AudioCall({
    super.key,
    // required this.receiverID,
    // required this.callerName,
    // required this.callerID,
  });

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  late String callID;

  // callIdCreater(String callerID, String receiverID){
  //    List<String> list = [callerID, receiverID];
  //   list.sort();
  //   callID = list.join("_");
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
      appID: 1720656719,
      appSign:
          "87e43114bfccfe12bbf4b8fee8025c4b43afd81ce49f09451ec34addb6a3d8b7",
      callID: "123 ",//widget.receiverID,
      userID:"234",// widget.callerID,
      userName:"Saad" ,//widget.callerName,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..onOnlySelfInRoom = ((context) => Navigator.pop(context)),
    ));
  }
}
