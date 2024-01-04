// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioVideoCall extends StatefulWidget {
  String receiverID, callerName, callerID;
  bool isVideoCall;
  AudioVideoCall({
    super.key,
    required this.receiverID,
    required this.callerName,
    required this.callerID,
    required this.isVideoCall,
  });

  @override
  State<AudioVideoCall> createState() => _AudioVideoCallState();
}

class _AudioVideoCallState extends State<AudioVideoCall> {
  late String callID;

  callIdCreater(String callerID, String receiverID) {
    List<String> list = [callerID, receiverID];
    list.sort();
    callID = list.join("_");
    setState(() {});
  }

  @override
  void initState() {
    callIdCreater(widget.callerID, widget.receiverID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
      appID: 1720656719,
      appSign:
          "87e43114bfccfe12bbf4b8fee8025c4b43afd81ce49f09451ec34addb6a3d8b7",
      callID: callID,
      userID: widget.callerID,
      userName: widget.callerName,
      config: widget.isVideoCall
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..onOnlySelfInRoom = ((context) => Navigator.pop(context)),
    ));
  }
}
