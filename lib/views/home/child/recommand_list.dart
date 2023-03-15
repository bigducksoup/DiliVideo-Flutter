
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../http/content_api.dart';

class RecommandList extends StatefulWidget {
  const RecommandList({super.key});

  @override
  State<RecommandList> createState() => _RecommandListState();
}

class _RecommandListState extends State<RecommandList> with AutomaticKeepAliveClientMixin{
  final _scrollController = ScrollController();

  List recommends = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getRecommend();

    
  }

  @override
  void dispose() {
    super.dispose();
  }

//  获取推荐
  void getRecommend() async {
    isLoading = true;
    var response = await getLatestRecommend(page);
    var responseresult = jsonDecode(response.toString());
    List data = responseresult['data'];
    if(data.isEmpty){
      isLoading = false;
      return;
    }
    recommends.addAll(data);
    page = page+1;
    setState(() {
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: double.infinity,
      color: Colors.black,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification)  {
            if(notification.metrics.pixels==notification.metrics.maxScrollExtent){
              if(isLoading==false){
                getRecommend();
              }else{
                return false;
              }
            }

            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemBuilder: (context, index) {
              return TwoVideoInOneRow(
                item1: recommends[index * 2],
                item2: recommends[index * 2 + 1],
              );
            },
            itemCount: (recommends.length / 2 - 0.1).round(),
          ),
        ),
      ),
    );
  }
  
  @override

  bool get wantKeepAlive => true;

}

class TwoVideoInOneRow extends StatelessWidget {
  const TwoVideoInOneRow({super.key, this.item1, this.item2});

  final dynamic item1;
  final dynamic item2;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.96;
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          VideoItem(
            coverurl: item1['coverUrl'],
            plcount: item1['watchCount'],
            authorname: item1['videoAuthorName'],
            title: item1['title'],
            id: item1['videoInfoId'],
            item: item1,
          ),
          VideoItem(
            coverurl: item2['coverUrl'],
            plcount: item2['watchCount'],
            authorname: item2['videoAuthorName'],
            title: item2['title'],
            id: item2['videoInfoId'],
            item: item2,
          ),
        ],
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem(
      {super.key,
      required this.coverurl,
      required this.plcount,
      required this.authorname,
      required this.title,
      required this.id, this.item});

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
          Get.toNamed('/video', arguments:item );
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: maindarkcolor,
          ),
          width: width,
          height: width * 1.1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                height: width * 0.7,
                child: Stack(
                  children: [
                    Hero(
                      tag: id,
                      child: SizedBox(
                          width: width,
                          height: width * 0.7,
                          child: CachedNetworkImage(
                            imageUrl: coverurl,
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                            )),
                    ),
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
