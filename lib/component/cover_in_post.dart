import 'dart:convert';

import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:dili_video/entity/route_argument.dart';
import 'package:dili_video/http/content_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoverInPost extends StatefulWidget {
  const CoverInPost(
      {super.key, required this.videoInfoId, required this.postUserId});
  final String videoInfoId;

  final String postUserId;

  @override
  State<CoverInPost> createState() => _CoverInPostState();
}

///
///Post中的视频封面与标题
///
class _CoverInPostState extends State<CoverInPost> with AutomaticKeepAliveClientMixin {
  var videoInfo;

  bool load = false;

  // {
  //       "videoInfoId": "8269d8d5-a0c3-42de-b942-bc44844b2fe0",
  //       "videoAuthorId": "1",
  //       "videoAuthorName": "ducksoup",
  //       "collectCount": 0,
  //       "commentCount": 0,
  //       "createTime": "2023-03-16T08:53:18.000+00:00",
  //       "isOriginal": 0,
  //       "watchCount": 0,
  //       "likeCount": 0,
  //       "isPublish": 1,
  //       "openComment": 1,
  //       "title": "动漫推荐",
  //       "summary": "动漫混剪推荐",
  //       "videoFileId": "dffe7205-6f93-460b-863f-3329cac8156a",
  //       "videoFileUrl": "null",
  //       "videoFileName": "null",
  //       "coverId": "f9bc4f08-51ca-4bad-9bdf-d4143f777935",
  //       "coverName": "e2b131a0-bf88-4323-9ef8-5b0d9be4f818.png",
  //       "coverUrl": "http://127.0.0.1:9000/img/95/5c/e2b131a0-bf88-4323-9ef8-5b0d9be4f818.png",
  //       "partitionId": "1"
  //   }

  void fetchVideoInfo() async {
    var response = await getVideoInfoById(widget.videoInfoId);
    var res = jsonDecode(response.toString());
    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    videoInfo = res['data'];
    setState(() {
      load = true;
    });
  }

  @override
  void initState() {
    fetchVideoInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return load? GestureDetector(
      onTap: () {
        Get.toNamed('/video', arguments: RouteArgument(TYPE_VIDEO_ITEM, videoInfo) );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //判断是否显示作者
          if (widget.postUserId != videoInfo['videoAuthorId'])
            Text(
              "@${videoInfo['videoAuthorName']}",
              style: const TextStyle(color: Colors.blue, fontSize: 20),
            ),
          const SizedBox(
            height: 5,
          ),
          //视频封面
          Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: NetworkImage(videoInfo['coverUrl']),
                      fit: BoxFit.cover))),
          const SizedBox(
            height: 10,
          ),
          //视频标题
          Text(
            " ${videoInfo['title']}",
            maxLines: 1,
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ) :
    SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink.shade400,
                  ),
                ),
              );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
