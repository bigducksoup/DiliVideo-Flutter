import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/component/time_formatter.dart';
import 'package:flutter/material.dart';


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
                    Icon(
                      Icons.person,
                      color: Colors.pink.shade300,
                      size: 15,
                    ),
                    Text(
                      videoAuthorName,
                      softWrap: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.tv_rounded,
                      color: Colors.pink.shade300,
                      size: 15,
                    ),
                    Text(
                      "$watchCount",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Expanded(child: SizedBox()),
                    TimeComparisonScreen(dateTimeString: date)
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


