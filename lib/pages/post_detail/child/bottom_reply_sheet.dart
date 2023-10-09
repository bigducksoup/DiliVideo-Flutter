import 'package:dili_video/component/RoundedInput.dart';
import 'package:dili_video/component/reply_item.dart';
import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:dili_video/entity/replyVO.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:dili_video/services/router.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///动态评论的回复弹出框
class PostCommentReplySheet extends StatefulWidget {
  const PostCommentReplySheet(
      {super.key,
      required this.postCommentId,
      required this.postId,
      required this.userId});

  final String postCommentId;

  final String postId;

  final String userId;

  @override
  State<PostCommentReplySheet> createState() => _PostCommentReplySheetState();
}

class _PostCommentReplySheetState extends State<PostCommentReplySheet> {
  List<ReplyVO> data = [];

  int page = 1;

  bool empty = false;

  bool loading = false;

  bool orderByTime = false;

  String inputHint = "输入回复";

  int replyMode = 1;

  Map<String,dynamic> replyState = {
    "fatherCommentId":"",
    "commentId":"",
    "postId":"",
    "content":"",
  };


  RoundedInputController inputController = RoundedInputController();

  init() {
    replyState['fatherCommentId'] = widget.postCommentId;
    replyState['commentId'] = widget.postCommentId;
    replyState['postId'] = widget.postId;
    getData(data);
  }

  resetState() {
    print("reset");
    setState(() {
      data.clear();
      page = 1;
      empty = false;
      loading = false;
      getData(data);
    });
  }

  distory() {
    inputController.dispose();
  }

  void getData(List data) async {
    if (loading || empty) return;

    setState(() {
      loading = true;
    });

    try {
      var response = await getPostCommentReply(page, widget.postCommentId,
          orderByTime: orderByTime);

      Map<String, dynamic> res = handleResponse(response);

      List list = res['data'];

      setState(() {
        if (list.isEmpty) {
          empty = true;
        } else {
          List<ReplyVO> currentData = castData(list);
          data.addAll(currentData);
          page++;
        }
        loading = false;
      });
    } catch (e) {
      resetState();
    }
  }

  void reply(String fatherCommentId, String commentId, String postId,
      String content) async {
    try {
      var response =
          await replyToPostComment(fatherCommentId, commentId, postId, content);
      Map<String, dynamic> res = handleResponse(response);
      TextToast.showToast(res['msg']);
      if(res['data']){
        inputController.clearText();
      }
    } catch (e) {}
  }

  List<ReplyVO> castData(List list) {
    return list.map((e) => ReplyVO.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    distory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          inputHint = "输入回复";
        });
        replyState['commentId'] = widget.postCommentId;
        inputController.unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: maindarkcolor,
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
                child: SizedBox(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                    getData(data);
                    return true;
                  }
                  return false;
                },
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ReplyItem(
                        reply: data[index],
                        onClickAvatarAndName: (userId, userAvatar, userNickName) {
                          routeToUserPage(userId);
                        },
                        onClickContent:(content, userId, userName, toId, toName, commentId) {
                          setState(() {
                            inputHint = "回复@$userName:";
                          });
                          inputController.focus();
                          replyState['commentId'] = commentId;
                        },
                        onClickToName: (userId, userName) {
                          routeToUserPage(userId);
                        },
                      );
                    },
                    itemCount: data.length),
              ),
            )),
            Container(
                padding: const EdgeInsets.all(2),
                width: double.infinity,
                height: 60,
                child: RoundedInput(
                    roundedInputController: inputController,
                    hintText: inputHint,
                    onClickSendBtn: (text) {
                      replyState['content'] = text;
                      reply(replyState['fatherCommentId'], replyState['commentId'], replyState['postId'], replyState['content']);
                    },
                    )),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      height: 40,
      color: maindarkcolor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(
          "评论详情",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ))
      ]),
    );
  }
}
