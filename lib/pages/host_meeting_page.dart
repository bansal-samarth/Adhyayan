import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class HostMeetingPage extends StatelessWidget {
  final String liveID;

  const HostMeetingPage({super.key, required this.liveID});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 2007596387, // Fill in the appID from ZEGOCLOUD Admin Console.
        appSign: "f9bbe27c348afa98a7d91f9249c703aeaf028226c61de56e947a04bc4d5ff84c", // Fill in the appSign from ZEGOCLOUD Admin Console.
        userID: 'host_user_id',
        userName: 'host_user_name',
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveStreamingConfig.host(),
      ),
    );
  }
}
