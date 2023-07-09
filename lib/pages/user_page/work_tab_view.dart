import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/video_item.dart';
import '../../http/content_api.dart';
import '../../utils/success_fail_dialog_util.dart';


class Works extends StatefulWidget {
  const Works({super.key, required this.userId});

  final String userId;

  @override
  State<Works> createState() => _WorksState();
}

class _WorksState extends State<Works> with AutomaticKeepAliveClientMixin {
  var _videoList = [];

  int page = 1;

  void getUploaded() async {
    var response = await getUserPublishedVideos(widget.userId, page);
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
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = _videoList[index];
          return GestureDetector(
            onTap: () async {
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
        itemCount: _videoList.length,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
