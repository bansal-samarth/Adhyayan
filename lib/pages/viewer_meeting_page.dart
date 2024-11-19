import 'package:flutter/material.dart';
import 'dart:math';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
class LivePage extends StatefulWidget {
  final String liveID;
  
  const LivePage({super.key, required this.liveID,});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {

  String generateRandomString(int length) {
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random random = Random();
  List<String> randomString = List.generate(length, (index) => characters[random.nextInt(characters.length)]);
  return randomString.join('');
}



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 2007596387, // Fill in the appID from ZEGOCLOUD Admin Console.
        appSign: "f9bbe27c348afa98a7d91f9249c703aeaf028226c61de56e947a04bc4d5ff84c", // Fill in the appSign from ZEGOCLOUD Admin Console.
        userID: generateRandomString(6),
        userName: generateRandomString(6),
        liveID: widget.liveID,
        config: ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}