import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class HostMeetingPage extends StatelessWidget {
  final String liveID;

  const HostMeetingPage({Key? key, required this.liveID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1331073039, // Fill in the appID from ZEGOCLOUD Admin Console.
        appSign: "185726600161acf517ded45b39ac51a38888ecbc018cc9bfd9e5059467313ff0", // Fill in the appSign from ZEGOCLOUD Admin Console.
        userID: 'host_user_id',
        userName: 'host_user_name',
        liveID: liveID,
        config: ZegoUIKitPrebuiltLiveStreamingConfig.host(),
      ),
    );
  }
}
