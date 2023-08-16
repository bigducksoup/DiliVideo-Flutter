import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/component/img_grid.dart';
import 'package:dili_video/component/post_comment_item.dart';
import 'package:dili_video/entity/comment_params.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widget/fixed_to_top.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with SingleTickerProviderStateMixin {
  //Map<String,dynamic>
  late Map<String, dynamic> item;

  late TabController tabController;

  List comments = [];

  int commentPage = 1;

  bool commentLoading = true;

  int curTabIndex = 1;

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

  void initTabController() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    curTabIndex = tabController.index;

    tabController.addListener(() {
      if (curTabIndex != tabController.index) {
        setState(() {
          curTabIndex = tabController.index;
        });
      }
    });
  }

  void loadComment() async {
    var response = await getPostComment(commentPage, item['id']);
    var res = jsonDecode(response.toString());
    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    if (res['data'].length != 0) {
      commentPage++;
    }
    setState(() {
      comments.addAll(res['data']);
      commentLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    item = Get.arguments;
    initTabController();
    loadComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text("动态详情"),
          pinned: true,
          floating: false,
          elevation: 0,
        ),
        SliverToBoxAdapter(
          child: _Detail(item: item),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: PersistentHeader(
            minHeight: 50.0,
            maxHeight: 50.0,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF303030),
                  border: Border(bottom: BorderSide()),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: TabBar(
                        tabs: const [
                          Tab(
                            text: "转发",
                          ),
                          Tab(
                            text: "评论",
                          ),
                        ],
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.pink.shade400,
                        controller: tabController,
                      ),
                    ),
                    const Expanded(child: SizedBox())
                  ],
                )),
          ),
        ),
        curTabIndex == 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                return ListTile(title: Text('Item $index'));
              }, childCount: 30))
            : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                return PostCommentItem(
                    params: CommentDisplayParams.fromJson(comments[index]),
                    postId: comments[index]['id'],
                    upId: comments[index]['userId'],
                    slot: Text("TODO"),);
              }, childCount: comments.length)),
      ],
    ));
  }
}

class _Detail extends StatefulWidget {
  const _Detail({super.key, required this.item, this.child});

  final Map<String, dynamic> item;
  final Map<String, dynamic>? child;

  @override
  State<_Detail> createState() => __DetailState();
}

class __DetailState extends State<_Detail> {
  Widget _buildHeader(String nickName, String time, String avatarUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nickName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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

  Widget _buildContent(String content, List imgList,
      {Map<String, dynamic>? child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: const TextStyle(fontSize: 17),
        ),
        const SizedBox(
          height: 10,
        ),
        ImgRowList(width: MediaQuery.of(context).size.width, urls: imgList),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
              widget.item['module']['userNickname'],
              widget.item['createTime'],
              widget.item['module']['userAvatarUrl']),
          const SizedBox(
            height: 10,
          ),
          _buildContent(widget.item['module']['description'],
              widget.item['module']['imgs'])
        ],
      ),
    );
  }
}
