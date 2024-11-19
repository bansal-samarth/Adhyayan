import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class HostMeetingPage extends StatelessWidget {
  final String liveID;

  const HostMeetingPage({super.key, required this.liveID});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1976727116, // Fill in the appID from ZEGOCLOUD Admin Console.
        appSign: "ec8c1d4fb0465a38134da822c9a4cf5af131dabb5556835e00ec8078c873139d", // Fill in the appSign from ZEGOCLOUD Admin Console.
        userID: 'host_user_id',
        userName: 'host_user_name',
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveStreamingConfig.host(),
      ),
    );
  }
}
