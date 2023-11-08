import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:dili_video/entity/route_argument.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../component/card/video_item.dart';
import '../../../http/content_api.dart';

class RecommandList extends StatefulWidget {
  const RecommandList({super.key});

  @override
  State<RecommandList> createState() => _RecommandListState();
}

class _RecommandListState extends State<RecommandList>
    with AutomaticKeepAliveClientMixin {
  List recommends = [];
  int page = 1;
  bool isLoading = false;

  bool init = false;

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
    if (isLoading) return;

    isLoading = true;

    try {
      var response = await getLatestRecommend(page);
      Map<String, dynamic> res = handleResponse(response);

      if (res['code'] != 200) {
        resetState();
        return;
      }

      List data = res['data'];
      if (data.isEmpty) {
        isLoading = false;
        init = true;
        return;
      }
      recommends.addAll(data);
      page = page + 1;
      setState(() {});
      isLoading = false;
      init = true;
    } catch (e) {
      resetState();
    }
  }

  void resetState() {
    page = 1;
    isLoading = false;
    setState(() {
      recommends.clear();
    });
    getRecommend();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: (init && !isLoading)
            ? NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                    if (isLoading == false) {
                      getRecommend();
                    } else {
                      return false;
                    }
                  }
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    resetState();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    // controller: _scrollController,
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
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
          VideoItemSmall(
            coverurl: item1['coverUrl'],
            plcount: item1['watchCount'],
            authorname: item1['videoAuthorName'],
            title: item1['title'],
            id: item1['videoInfoId'],
            item: item1,
          ),
          VideoItemSmall(
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


