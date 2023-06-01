import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreenPage extends StatefulWidget {
  const VideoFullScreenPage(
      {super.key, required this.videoPlayerController, required this.tag});

  final VideoPlayerController? videoPlayerController;

  final String tag;

  @override
  State<VideoFullScreenPage> createState() => _VideoFullScreenPageState();
}

class _VideoFullScreenPageState extends State<VideoFullScreenPage> {
  @override
  void initState() {
    super.initState();
    // 强制横屏

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.videoPlayerController);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
            tag: widget.tag,
            child: AspectRatio(
              aspectRatio: widget.videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(widget.videoPlayerController!),
            )),
      ),
    );
  }
}
