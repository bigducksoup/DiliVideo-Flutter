import 'dart:convert';

import 'package:dili_video/http/content_api.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/shared_preference.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:dili_video/video_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoHistoryPage extends StatefulWidget {
  const VideoHistoryPage({super.key});

  @override
  State<VideoHistoryPage> createState() => _VideoHistoryPageState();
}

class _VideoHistoryPageState extends State<VideoHistoryPage> {
  List data = [];

  int page = 1;
  int size = 20;

  final ScrollController _listviewScrollController = ScrollController();

  void addScrollToBottomListener() {
    _listviewScrollController.addListener(() {
      if (_listviewScrollController.position.pixels == _listviewScrollController.position.maxScrollExtent) {
          getData();
      }
    });
  }

  //从本地获取历史记录id
  void getData() async {
    List<String>? videoHistoryList =
        await LocalStorge.getStringList("videoHistory" + auth_state.id.value);
    if (videoHistoryList == null) {
      return;
    }
    videoHistoryList = videoHistoryList.reversed.toList();
    //calc start and end
    int start = (page - 1) * size;
    int end = page * size > videoHistoryList.length
        ? videoHistoryList.length
        : page * size;

    if (start >= videoHistoryList.length) {
      return;
    }
    //split list
    List<String>? pagedHistoryList =
        videoHistoryList.getRange(start, end).toList();

    //fetch data
    var response = await getVideoVosByIds(pagedHistoryList);
    var res = jsonDecode(response.toString());

    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    setState(() {
      data.addAll(res['data']);
    });
    page++;
  }


  void deleteHistory(){
    LocalStorge.remove("videoHistory" + auth_state.id.value);
    setState(() {
      data  = [];
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
    addScrollToBottomListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: maindarkcolor,
        appBar: AppBar(
          backgroundColor: maindarkcolor,
          title: const Text("历史记录"),
          actions:  [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: "确认操作",
                    textCancel: "取消",
                    textConfirm: "确认",
                    middleText: "确认删除所有历史记录吗？",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      deleteHistory();
                      Get.back();
                    },
                  );
                },
                child: const Icon(
                  Icons.clear_all,
                  size: 25,
                ),
              ),
            )
          ],
        ),
        body: ListView.builder(
          controller: _listviewScrollController,
          itemBuilder: (context, index) {
            var item = data[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed('/video', arguments: item);
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
          itemCount: data.length,
        ));
  }

  @override
  void dispose() {
    _listviewScrollController.dispose();
    super.dispose();
  }
}
