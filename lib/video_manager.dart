import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'http/content_api.dart';

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
            onTap: () async{
             var res =  await Get.toNamed("/videoItem_manage",arguments: item);
             if(res!=null){
               setState(() {
                 _videoList.removeWhere((element) => element['videoInfoId'] == res['videoInfoId']);
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

class VideoItem extends StatelessWidget {
  const VideoItem(
      {super.key,
      required this.coverUrl,
      required this.title,
      required this.videoAuthorName,
      required this.watchCount,
      required this.date});

  final String coverUrl;

  final String title;

  final String videoAuthorName;

  final int watchCount;

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 0.2))),
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              clipBehavior: Clip.hardEdge,
              width: 200,
              height: 110,
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                fit: BoxFit.cover,
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                const Expanded(child: SizedBox()),
                Row(
                  children: [
                     Icon(Icons.person,color: Colors.pink.shade300,size: 15,),
                    Text(
                      videoAuthorName,
                      softWrap: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                     Icon(Icons.tv_rounded,color: Colors.pink.shade300,size: 15,),
                    Text(
                      "$watchCount",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(date.substring(0, 10),
                        style: const TextStyle(color: Colors.white))
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
