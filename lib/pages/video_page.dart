import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class VideoPlaybackPage extends StatefulWidget {
  final String subject;

  const VideoPlaybackPage({Key? key, required this.subject}) : super(key: key);

  @override
  _VideoPlaybackPageState createState() => _VideoPlaybackPageState();
}

class _VideoPlaybackPageState extends State<VideoPlaybackPage> {
  late YoutubePlayerController _controller;
  String videoId = '';
  

  @override
  void initState() {
    super.initState();
    if(widget.subject=='MATHEMATICS'){
      videoId='2AmldBXnzvY';
    }
    else if(widget.subject=='SOCIAL STUDIES'){
      videoId='Ea1NRpzBuIc';
    }
    else if(widget.subject=='SCIENCE'){
      videoId='nq69nVHXaf8';
    }
    else if(widget.subject=='ENGLISH'){
      videoId='gNEp-njn-iQ';
    }
    else if(widget.subject=='HINDI'){
      videoId='k2TT3oJFePc';
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // Prevent auto play
        mute: false, // Start unmuted
        hideControls: false, // Show controls
        enableCaption: false, // Enable captions if needed
      ),
    );

    // Lock orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    // Reset orientation to portrait when exiting the video page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Stop video playback when back is pressed
        _controller.pause();
        return true; // Allow the pop
      },
      child: Scaffold(
        body: SafeArea(
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            onReady: () {
              // Optionally, do something when the player is ready
            },
          ),
        ),
      ),
    );
  }
}