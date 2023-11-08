
import 'package:dili_video/component/commons/buttons.dart';
import 'package:dili_video/component/video_page/progress_bar.dart';
import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';


///视频控制器
class VideoControlWindow extends StatefulWidget {
  const VideoControlWindow({super.key, required this.controller, required this.controlWindowType});

  final VideoPlayerController controller;

  final int controlWindowType;

  @override
  State<VideoControlWindow> createState() => _VideoControlWindowState();
}

class _VideoControlWindowState extends State<VideoControlWindow> {


  bool show = false;



  void click(){
    setState(() {
      show = !show;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: show? 1:0,
          duration: const Duration(milliseconds: 500),
          child: IgnorePointer(
            ignoring: !show,
            child: _renderWindow(widget.controlWindowType))),
      ),
    );
  }


  Widget _renderWindow(int type){
    switch (type){
      case VIDEO_CONTROL_SMALL:return _buildSmallWindow();
      case VIDEO_CONTROL_BIG:return _buildBigWindow();
      default:return _buildSmallWindow();
    }
  }



  Widget _buildSmallWindow(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            MyIconButton(onPressed: (){
              Get.back();
            }, icon: Icons.arrow_back_ios)
          ],
        ),
        Row(
          children: [
            IconChangeButton(defaultIcon: Icons.pause, changedIcon: Icons.play_arrow,onPressedDefault: () {
              widget.controller.pause();
            },onPressedChanged: () {
              widget.controller.play();
            },size: 25,),
            Expanded(child: SizedBox(
              height: 20,
              child: ProgressBar(controller: widget.controller),
            )),
            FaIconsButton(icon: FontAwesomeIcons.maximize, onPressed: (){})
          ],
        )
      ],
    );
  }


  Widget _buildBigWindow(){
    return Placeholder();
  }




}