import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/component/cover_in_post.dart';
import 'package:dili_video/pages/post_detail/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'img_grid.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key, this.item});

  final item;

  // {
  //           "id": "6f6b73e3-a882-4b3a-b980-c0055073558e",
  //           "moduleId": "1ae73532-f481-4ec3-8a70-c37c8e96a5b9",
  //           "topicId": "123123",
  //           "likeCount": 0,
  //           "commentCount": 0,
  //           "shareCount": 0,
  //           "createTime": "2023-05-10T09:14:53.000+00:00",
  //           "status": 1,
  //           "module": {
  //               "id": "1ae73532-f481-4ec3-8a70-c37c8e96a5b9",
  //               "userId": "1",
  //               "userAvatarUrl": "http://127.0.0.1:9000/img/wallhaven-m3pex1.png",
  //               "userNickname": "ducksoup",
  //               "description": "12121",
  //               "typeId": "2",
  //               "videoInfoId": null,
  //               "childPostmoduleId": null
  //           },
  //           "imgs": [
  //               "http://127.0.0.1:9000/post-imgs/55/ec/eb05ee6a-0233-4876-a229-6f9eab1fafb2.png",
  //               "http://127.0.0.1:9000/post-imgs/26/fb/0a683ed1-fc4f-40f8-8b86-7115e8c6f5d3.png"
  //           ]
  //       }

  @override
  State<PostItem> createState() => _PostItemState();
}

//单个动态样式
class _PostItemState extends State<PostItem> {
  bool like = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              widget.item['module']['userNickname'],
              widget.item['createTime'],
              widget.item['module']['userAvatarUrl'],
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  if (widget.item['module']['typeId'] == "1") {
                    return;
                  } else if (widget.item['module']['typeId'] == "2") {
                    Get.to(const PostDetailPage(), arguments: widget.item);
                  }
                },
                child: _buildContent(context, widget.item['module'])),
            const SizedBox(
              height: 10,
            ),
            _buildBottom(widget.item['shareCount'], widget.item['commentCount'],
                widget.item['likeCount'])
          ],
        ),
      ),
    );
  }

  //动态头部
  Widget _buildHeader(String nickName, String time, String avatarUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nickName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              time.substring(0, 16),
              style: const TextStyle(fontSize: 12),
            )
          ],
        )
      ],
    );
  }

  //内容渲染
  Widget _buildContent(BuildContext context, var module) {
    double width = MediaQuery.of(context).size.width;

    //判断动态类型
    Widget selector(String typeId) {
      if (typeId == '1') {
        return CoverInPost(
          videoInfoId: widget.item['module']['videoInfoId'],
          postUserId: widget.item['module']['userId'],
        );
      }

      if (typeId == '2') {
        return ImgRowList(
          width: width,
          urls: module['imgs'],
        );
      }

      return const SizedBox();
    }

    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module['description'],
            style: const TextStyle(fontSize: 17),
          ),
          Container(
            color: Colors.transparent,
            height: 20,
            width: double.infinity,
          ),
          selector(module['typeId'])
        ],
      ),
    );
  }

  //底部按钮
  Widget _buildBottom(int shareCount, int commentCount, int likeCount) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 40,
          width: (screenWidth - 16) / 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.share),
              const SizedBox(
                width: 5,
              ),
              shareCount == 0 ? const Text("分享") : Text("$shareCount")
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: (screenWidth - 16) / 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.comment),
              const SizedBox(
                width: 5,
              ),
              commentCount == 0 ? const Text("评论") : Text("$commentCount")
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: (screenWidth - 16) / 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (like) {
                        widget.item['likeCount']--;
                      }
                      if (!like) {
                        widget.item['likeCount']++;
                      }
                      like = !like;
                    });
                  },
                  child: Icon(
                    Icons.thumb_up_alt_rounded,
                    color: like ? Colors.pink.shade400 : Colors.white,
                  )),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 50,
                child: likeCount == 0 ? const Text("点赞") : Text("$likeCount"),
              )
            ],
          ),
        )
      ],
    );
  }
}
