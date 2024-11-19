import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LivePage({super.key, required this.liveID, this.isHost = false});

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
      const SnackBar(content: Text('Camera and Microphone permissions are required for live streaming.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1976727116, // Fill in the appID from ZEGOCLOUD Admin Console.
        appSign: "ec8c1d4fb0465a38134da822c9a4cf5af131dabb5556835e00ec8078c873139d", // Fill in the appSign from ZEGOCLOUD Admin Console.
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
