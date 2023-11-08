import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/component/commons/RoundedInput.dart';
import 'package:dili_video/component/child_comment_preview.dart';
import 'package:dili_video/component/commons/img_grid.dart';
import 'package:dili_video/component/post_comment_item.dart';
import 'package:dili_video/component/commons/time_formatter.dart';
import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:dili_video/entity/child_comment_preview.dart';
import 'package:dili_video/entity/comment_params.dart';
import 'package:dili_video/entity/module_vo.dart';
import 'package:dili_video/entity/post_vo.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/pages/post_detail/child/bottom_reply_sheet.dart';
import 'package:dili_video/services/router.dart';
import 'package:dili_video/theme/colors.dart';
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

  late RoundedInputController roundedInputController;

  String bottomHint = "#说点什么吧";

  int replyMode = 0;

  late String replyTargetId;

  // {
  //           "id": "6f6b73e3-a882-4b3a-b980-c0055073558e",
  //           "moduleId": "1ae73532-f481-4ec3-8a70-c37c8e96a5b9",
  //           "topicId": "123123",
  //           "likeCount": 0,
  //           "commentCount": 0,
  //           "shareCount": 0,
  //           "createTime": "2023-05-10T09:14:53.000+00:00",
  //           "status": 1,
  //           "moduleVO": {
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

  void switchReplyMode(int mode, {String? name, String? targetId}) {
    //mode == 0 是回复动态,mode == 1 是回复评论
    if (mode == 0) {
      setState(() {
        replyMode = mode;
        bottomHint = "#说点什么吧";
        replyTargetId = item['id'];
      });
    } else if (mode == 1) {
      setState(() {
        replyMode = mode;
        bottomHint = "回复@$name";
        replyTargetId = targetId!;
        roundedInputController.focus();
      });
    }
  }

  //点击输入框发送按钮后
  void clickSendButton(String text) async {
    //回复动态
    if (replyMode == 0) {
      var response = await replyToPost(replyTargetId, text);
      var res = jsonDecode(response.toString());
      TextToast.showToast(res['msg']);
      if (res['code'] != 200) return;
      roundedInputController.unfocus();
      roundedInputController.clearText();

      return;
    }

    //回复评论
    if (replyMode == 1) {
      var response = await replyToPostComment(
          replyTargetId, replyTargetId, item['id'], text);
      var res = jsonDecode(response.toString());
      TextToast.showToast(res['msg']);
      if (res['code'] != 200) return;
      roundedInputController.unfocus();
      roundedInputController.clearText();
    }
  }

  @override
  void initState() {
    super.initState();
    roundedInputController = RoundedInputController();

    //传入Post.toJson的情况
    if (Get.arguments['moduleVO'].runtimeType == ModuleVO) {
      Map<String, dynamic> postVO = Get.arguments;
      Map<String, dynamic> moduleVO =
          (Get.arguments['moduleVO'] as ModuleVO).toJson();

      postVO['moduleVO'] = moduleVO;
      item = postVO;
    } else {
      //传入dynamic的情况
      item = Get.arguments;
    }
    switchReplyMode(0);
    initTabController();
    loadComment();
  }

  @override
  void dispose() {
    roundedInputController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _showBottomSheetReply(String postCommentId) {
    //TODO show more comments
     Get.bottomSheet(PostCommentReplySheet(postCommentId: postCommentId, postId: item['id'], userId: item['moduleVO']['userId']), backgroundColor: maindarkcolor);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        roundedInputController.unfocus();
        switchReplyMode(0);
      },
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: CustomScrollView(
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
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                          return ListTile(title: Text('Item $index'));
                        }, childCount: 30))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) {
                          //build childPreviewComment list for ChildCommentListPreview
                          List<ChildPreviewComment> list = [];
                          for (int i = 0;
                              i < comments[index]['child'].length;
                              i++) {
                            Map<String, dynamic> item =
                                comments[index]['child'][i];
                            list.add(ChildPreviewComment.fromJson(item));
                          }

                          return PostCommentItem(
                            params:
                                CommentDisplayParams.fromJson(comments[index]),
                            id: comments[index]['id'],
                            userId: comments[index]['userId'],
                            onClickContent: (content, commentId, userNickName) {
                              //切换回复模式为回复评论
                              switchReplyMode(1,
                                  name: userNickName, targetId: commentId);
                            },
                            slot: ChildCommentListPreview(
                              list: list,
                              onClickUsername: (userId, userName) {
                                //judge if current post owner is comment owner
                                //if so not route to user page because it can cause stack over flow
                                if (item['moduleVO']['userId'] != userId) {
                                  routeToUserPage(userId);
                                }
                              },
                              clickSeeMore: (){
                                _showBottomSheetReply(comments[index]['id']);
                              },
                            ),
                            onClickAvatarAndName: (userId, userAvatar) {
                              //judge if current post owner is comment owner
                              //if so not route to user page because it can cause stack over flow
                              if (item['moduleVO']['userId'] != userId) {
                                routeToUserPage(userId);
                              }
                            },
                          );
                        },
                              childCount: comments.length,
                              addAutomaticKeepAlives: true)),
                ],
              ),
            ),
          ),

          //bottom input Container
          Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide())),
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.only(bottom: 20),
            child: RoundedInput(
              roundedInputController: roundedInputController,
              hintText: bottomHint,
              onClickSendBtn: clickSendButton,
            ),
          )
        ],
      )),
    );
  }
}

class _Detail extends StatefulWidget {
  const _Detail({required this.item, this.child});

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
            TimeComparisonScreen(dateTimeString: time)
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
              widget.item['moduleVO']['userNickname'],
              widget.item['createTime'],
              widget.item['moduleVO']['userAvatarUrl']),
          const SizedBox(
            height: 10,
          ),
          _buildContent(widget.item['moduleVO']['description'],
              widget.item['moduleVO']['imgs'])
        ],
      ),
    );
  }
}
