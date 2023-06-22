import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';

import '../../component/img_grid.dart';

class Post extends StatefulWidget {
  const Post({super.key, required this.userId});

  final String userId;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
  //数据
  List data = [];

  //页数
  int page = 1;

  bool isEnd = false;

  //获取数据
  void getPosts() async {
    var response = await getPostsByUserId(widget.userId, page);
    var res = jsonDecode(response.toString());
    if (res['code'] == 200) {
      if((res['data'] as List).isEmpty){
        return;
      }
      setState(() {
        data.addAll(res['data']);
      });
      page++;
      return;
    }
    TextToast.showToast(res['msg']);
  }


  bool onScrollNotification(ScrollNotification notification){
    if(!isEnd && notification.metrics.pixels == notification.metrics.maxScrollExtent){
      isEnd = true;
      getPosts();
    }else if (isEnd && notification.metrics.pixels < notification.metrics.maxScrollExtent){
      isEnd = false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }



  //listview在这里
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                PostItem(
                  item: data[index],
                ),
      
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.black,
                )
              ],
            );
          },
          itemCount: data.length,
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

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
            _buildContent(context, widget.item['module'])
          ],
        ),
      ),
    );
  }

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
      if (typeId == '2') {
        return ImgRowList(
          width: width,
          urls: module['imgs'],
        );
      }

      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(module['description'],style: const TextStyle(fontSize: 17),),
        const SizedBox(
          height: 10,
        ),
        selector(module['typeId'])
      ],
    );
  }
}



class CoverInPost extends StatelessWidget {
  const CoverInPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                image: NetworkImage(
                    "http://127.0.0.1:9000/img/wallhaven-m3pex1.png"),
                fit: BoxFit.cover)));
  }
}
