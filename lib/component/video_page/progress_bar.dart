

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key, required this.controller, this.onEnd, this.color, });


  final VideoPlayerController controller;

  final Function()? onEnd;

  final Color? color;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {


  //进度条value（0.0-1.0）
  double value = 0;

  


  @override
  void initState() {
    super.initState();
    //监听进度改变进度条
    widget.controller.addListener(() {
      setState(() {
        value = widget.controller.value.position.inMilliseconds.toDouble() / widget.controller.value.duration.inMilliseconds.toDouble();
      });
    },);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            // progress
            child: Slider(value: value, onChanged: (value){
              setState(() {
                widget.controller.seekTo(Duration(seconds: (value * widget.controller.value.duration.inSeconds).toInt()));
                widget.controller.play();
              });
            },thumbColor: widget.color?? Colors.pink.shade400,activeColor: widget.color?? Colors.pink.shade400,),
          ),
          
          SizedBox(
            width: 40,
            height: 20,
            child: Text("${(widget.controller.value.position.inSeconds/60).floor()}:${(widget.controller.value.position.inSeconds%60).toString().padLeft(2,"0")}"),
          )
        ],
      ),
    );
  }
}