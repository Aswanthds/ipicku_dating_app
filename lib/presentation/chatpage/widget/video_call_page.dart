// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/domain/video_chat/videochat_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class PrebuiltCallPage extends StatefulWidget {
  final String userID;
  const PrebuiltCallPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PrebuiltCallPageState();
}

class PrebuiltCallPageState extends State<PrebuiltCallPage> {
  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 501520519,
        appSign:
            "0c21665018bcedca21ce6078c992156918b5618611eb63ef025930e1e7faa34d",
        userID: widget.userID,
        userName: widget.userID.substring(1, 10).toUpperCase(),
        callID: 'call_id',
        plugins: [ZegoUIKitSignalingPlugin()],
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..turnOnCameraWhenJoining = true
          ..layout = ZegoLayout.pictureInPicture(
              isSmallViewDraggable: true, isSmallViewsScrollable: true)
          ..duration = ZegoCallDurationConfig(
            isVisible: true,
          ),
      ),
    );
  }
}
