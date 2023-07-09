import 'dart:convert';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/video_item.dart';
import '../../http/content_api.dart';

class VideoManager extends StatefulWidget {
  const VideoManager({super.key});

  @override
  State<VideoManager> createState() => _VideoManagerState();
}

class _VideoManagerState extends State<VideoManager> {
  var _videoList = [];

  void getUploaded() async {
    var response = await getUploadedVideos(1);
    var res = jsonDecode(response.toString());
    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    setState(() {
      _videoList = res['data'];
    });
  }

  @override
  void initState() {
    getUploaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("稿件管理"),
        backgroundColor: maindarkcolor,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var item = _videoList[index];
          return GestureDetector(
            onTap: () async {
              var res = await Get.toNamed("/videoItem_manage", arguments: item);
              if (res != null) {
                setState(() {
                  _videoList.removeWhere((element) =>
                      element['videoInfoId'] == res['videoInfoId']);
                });
              }
            },
            child: VideoItem(
              coverUrl: item['coverUrl'],
              title: item['title'],
              videoAuthorName: item['videoAuthorName'],
              watchCount: item['watchCount'],
              date: item['createTime'],
            ),
          );
        },
        itemCount: _videoList.length,
      ),
    );
  }
}


