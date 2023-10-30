
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///
///a frame to play video
///size adjust to father container
///
class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.controller});


  final VideoPlayerController controller;

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AspectRatio(aspectRatio: widget.controller.value.aspectRatio,child: VideoPlayer(widget.controller)),
    );
  }
}