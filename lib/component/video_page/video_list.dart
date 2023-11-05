import 'package:dili_video/component/video_item.dart';
import 'package:flutter/material.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key, required this.videoList, this.clickItem});

  final List videoList;

  final Function(dynamic videoInfo)? clickItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        dynamic video = videoList[index];
        return GestureDetector(
          onTap: () {
            clickItem?.call(video);
          },
          child: VideoItem(
              coverUrl: video['coverUrl'],
              title: video['title'],
              videoAuthorName: video['videoAuthorName'],
              watchCount: video['watchCount'],
              date: video['createTime']),
        );
      },
      shrinkWrap: true,
      itemCount: videoList.length,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
