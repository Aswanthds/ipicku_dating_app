// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class PrebuiltCallPage extends StatefulWidget {
  final String userID;
  final String name;
  const PrebuiltCallPage({Key? key, required this.userID, required this.name})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PrebuiltCallPageState();
}

class PrebuiltCallPageState extends State<PrebuiltCallPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 617321584,
        appSign:
            "94c69c006b9c0e778a52102e1feb816de29685b3bcb8594f54e8835814ff9200",
        userID: widget.userID,
        userName: widget.name,
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
/*
      old app ( 08/4/2024)
        appID: 1085180797,
        appSign:
            "237bd91d9359c4084866e3881d5e6b656912bedd09c4e287bd63baa28b182c95",


*/