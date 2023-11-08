import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/component/commons/time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constant/argument_type_constant.dart';
import '../../entity/route_argument.dart';
import '../../theme/colors.dart';


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





class VideoItemSmall extends StatelessWidget {
  const VideoItemSmall(
      {super.key,
      required this.coverurl,
      required this.plcount,
      required this.authorname,
      required this.title,
      required this.id,
      this.item});

  final String id;
  final String coverurl;
  final int plcount;
  final String authorname;
  final String title;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.96 * 0.51;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/video', arguments: RouteArgument(TYPE_VIDEO_ITEM, item));
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: maindarkcolor,
          ),
          width: width,
          height: width * 1.15,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                height: width * 0.7,
                child: Stack(
                  children: [
                    SizedBox(
                        width: width,
                        height: width * 0.7,
                        child: CachedNetworkImage(
                          imageUrl: coverurl,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        )),
                    Positioned(
                        left: 5,
                        bottom: 5,
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.youtube,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "$plcount",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      authorname,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}