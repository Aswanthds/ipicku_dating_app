// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/repositories/vc_repository.dart';
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
  String id = '';
  @override
  void initState() {
    super.initState();
    VideoRepository.getUniqueUserId().then((value) {
      setState(() {
        id = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    BlocProvider.of<VideochatBloc>(context)
        .add(SendVideoChatData(token: id, selectedUser: widget.userID));
    return id == null
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          )
        : SafeArea(
            child: ZegoUIKitPrebuiltCall(
              appID: 501520519,
              appSign:
                  "0c21665018bcedca21ce6078c992156918b5618611eb63ef025930e1e7faa34d",
              userID: uid,
              userName: FirebaseAuth.instance.currentUser!.uid
                  .substring(uid.length - 6),
              callID: 'call_id',
              plugins: [ZegoUIKitSignalingPlugin()],
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                ..turnOnCameraWhenJoining = false
                ..layout = ZegoLayout.gallery(
                    addBorderRadiusAndSpacingBetweenView: true)
                ..duration = ZegoCallDurationConfig(
                  isVisible: true,
                  onDurationUpdate: (p0) {
                    if (p0.inSeconds == 300) {
                      ZegoCallEndEvent(
                          reason: ZegoCallEndReason.localHangUp,
                          isFromMinimizing: false);
                    }
                  },
                ),
            ),
          );
  }
}
