import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LivePage({Key? key, required this.liveID, this.isHost = false}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request camera and microphone permissions
    var cameraStatus = await Permission.camera.request();
    var microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      // Permissions granted, proceed with live streaming
      setState(() {}); // Update the UI if necessary
    } else {
      // Handle permissions not granted (e.g., show a message)
      _showPermissionDeniedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Camera and Microphone permissions are required for live streaming.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1331073039, // Fill in the appID from ZEGOCLOUD Admin Console.
        appSign: "185726600161acf517ded45b39ac51a38888ecbc018cc9bfd9e5059467313ff0", // Fill in the appSign from ZEGOCLOUD Admin Console.
        userID: 'user_id',
        userName: 'user_name',
        liveID: widget.liveID,
        config: widget.isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
