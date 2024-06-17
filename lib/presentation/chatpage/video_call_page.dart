
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// class PrebuiltCallPage extends StatefulWidget {
//   final String userID;
//   final String name;
//   const PrebuiltCallPage({Key? key, required this.userID, required this.name})
//       : super(key: key);

//   @override
//   State<StatefulWidget> createState() => PrebuiltCallPageState();
// }

// class PrebuiltCallPageState extends State<PrebuiltCallPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ZegoUIKitPrebuiltCall(
//         appID: 1582745940,
//         appSign:
//             "dd6607e9e64480679b64d481ab90b9ea680b2f9e0ec1ae452c03ee522c308950",
//         userID: widget.userID,
//         userName: widget.name,
//         callID: 'call_id',
//         plugins: [ZegoUIKitSignalingPlugin()],
//         config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//           ..turnOnCameraWhenJoining = true
//           ..layout = ZegoLayout.pictureInPicture(
//               isSmallViewDraggable: true, isSmallViewsScrollable: true)
//           ..duration = ZegoCallDurationConfig(
//             isVisible: true,
//           ),
//       ),
//     );
//   }
// }
/*
  appID: 617321584,
        appSign:
            "94c69c006b9c0e778a52102e1feb816de29685b3bcb8594f54e8835814ff9200",
     new app
        appID: 1582745940,
        appSign:
            "dd6607e9e64480679b64d481ab90b9ea680b2f9e0ec1ae452c03ee522c308950",


*/