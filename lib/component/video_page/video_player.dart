
import 'package:dili_video/component/video_page/video_control.dart';
import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

///
///a frame to play video
///size adjust to father container
///
class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.controller, this.title,  this.url});


  final VideoPlayerController controller;

  final String? title;

  final String? url;


  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: VideoFrame(controller: widget.controller)
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: VideoControlWindow(controller: widget.controller, controlWindowType: VIDEO_CONTROL_SMALL),
        )
      ],
    );
  }
}










class VideoFrame extends StatefulWidget {
  const VideoFrame({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  State<VideoFrame> createState() => _VideoFrameState();
}

class _VideoFrameState extends State<VideoFrame> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AspectRatio(aspectRatio: widget.controller.value.aspectRatio,child: VideoPlayer(widget.controller)));
  }
}