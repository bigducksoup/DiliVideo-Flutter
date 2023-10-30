import 'package:dili_video/component/video_page/video_control.dart';
import 'package:dili_video/component/video_page/video_player.dart';
import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:dili_video/constant/page_status_constant.dart';
import 'package:dili_video/entity/route_argument.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:dili_video/services/size_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../http/content_api.dart';

class VideoPageRemake extends StatefulWidget {
  const VideoPageRemake({super.key});

  @override
  State<VideoPageRemake> createState() => _VideoPageRemakeState();
}

class _VideoPageRemakeState extends State<VideoPageRemake> {
  //视频信息
  dynamic videoInfo;

  //播放信息
  dynamic playInfo;

  //视频控制器
  VideoPlayerController? videoPlayerController;

  //加载状态
  LoadState loadState = LoadState();

  @override
  void initState() {
    super.initState();
    RouteArgument argument = Get.arguments;
    initData(argument);
  }


  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  //初始化数据
  Future<void> initData(RouteArgument argument) async {
    loadState.setLoading();
    initPlayInfo(argument, 5);

    if (argument.type == TYPE_VIDEO_ITEM) {
      setState(() {
        videoInfo = argument.data;
        loadState.setLoaded();
      });
    } else if (argument.type == TYPE_VIDEO_ID) {
      initVideoInfoById(argument.data, 5);
    }
  }

  //根据videoInfoId初始化video信息
  void initVideoInfoById(String videoInfoId, int retryTimes) async {
    if (retryTimes == 0) return;
    try {
      dynamic response = await getVideoInfoById(videoInfoId);

      setState(() {
        videoInfo = handleResponse(response)['data'];
        loadState.setLoaded();
      });
    } catch (e) {
      initVideoInfoById(videoInfoId, retryTimes - 1);
    }

    if (videoInfo == null) {
      setState(() {
        loadState.setError();
      });
    }
  }

  //初始化播放信息
  void initPlayInfo(RouteArgument argument, int retryTimes) async {
    if (retryTimes == 0) return;
    String videoInfoId;
    if (argument.type == TYPE_VIDEO_ITEM) {
      videoInfoId = argument.data['videoInfoId'];
    } else {
      videoInfoId = argument.data;
    }

    try {
      dynamic response = await getPlayUrl(videoInfoId);
      setState(() {
        playInfo = handleResponse(response)['data'];
      });
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(playInfo['fullpath']))
            ..initialize().then((value) {
              setState(() {});
              videoPlayerController!.play();
            });
    } catch (e) {
      initPlayInfo(RouteArgument(TYPE_VIDEO_ID, videoInfoId), retryTimes - 1);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: loadState.render(
            //loading widget
            const CircularProgressIndicator(),
            //error widget
            const FlutterLogo(),
            Column(
              children: [
                _buildVideoPlayer()
              ],
            )),
      ),
    );
  }


  Widget _buildVideoPlayer(){
    double width = SizeUtil.getCurrentWidth(context);
    double height = SizeUtil.getCurrentWidth(context) * 9 / 16;

    return videoPlayerController != null && videoPlayerController!.value.isInitialized
                    ? _stackLayout([
                        _buildPlayer(context, videoPlayerController!),
                        _buildControlWindow(context, videoPlayerController!)
                      ], width, height)
                    : SizedBox(
                        height: height,
                        width: width,
                        child: const Center(child: CircularProgressIndicator()));
  }

  Widget _stackLayout(List<Widget> list, double width, double height) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: list,
      ),
    );
  }

  Widget _buildPlayer(BuildContext ctx, VideoPlayerController controller) {
    double width = SizeUtil.getCurrentWidth(ctx);
    double height = width * 9 / 16;
    return SizedBox(
        width: width,
        height: height,
        child: CustomVideoPlayer(controller: controller));
  }

  Widget _buildControlWindow(BuildContext ctx, VideoPlayerController controller) {
    double width = SizeUtil.getCurrentWidth(ctx);
    double height = width * 9 / 16;
    return SizedBox(
      width: width,
      height: height,
      child: VideoControlWindow(controller: controller,controlWindowType: VIDEO_CONTROL_SMALL,),
    );
  }
}
