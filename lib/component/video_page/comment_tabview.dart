import 'dart:convert';

import 'package:dili_video/component/commons/RoundedInput.dart';
import 'package:dili_video/component/video_page/comment.dart';
import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.videoInfoId});

  final String videoInfoId;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _commentListScrollController = ScrollController();

  RoundedInputController roundedInputController = RoundedInputController();

  String bottomHintText = "留下你的想法";

  int page = 1;
  int mode = 1;
  List commentList = [];
  String replyToid = "";

  void setReplyToid(String id,String nickName) {
    replyToid = id;
    setState(() {
      bottomHintText = "回复@$nickName:";
    });
    roundedInputController.focus();
  }

  void resetReplyInfo() {
    replyToid = "";
    setState(() {
      bottomHintText = "留下你的想法";
    });
    roundedInputController.unfocus();
  }

  void send(String value) async {
    //判断输入为空提示
    if (value.isEmpty) {
      Get.defaultDialog(
          title: "OvO",
          middleText: "请输入评论内容",
          backgroundColor: Colors.pink.shade300);
      return;
    }

    if (replyToid == "") {
      //发送评论请求
      var response = await sendComment(value, widget.videoInfoId);
      var res = jsonDecode(response.toString());
      TextToast.showToast(res['msg']);
      if (res['code'] != 200) return;
      //toast
    } else {
      //发送回复请求
      var response = await replyComment(value, replyToid, replyToid);
      var res = jsonDecode(response.toString());
      TextToast.showToast(res['msg']);
      if (res['code'] != 200) return;
      //toast
    }

    roundedInputController.clearText();
    roundedInputController.unfocus();

  }

  void getComments() async {
    var response = await getComment(page, mode, widget.videoInfoId);
    var res = jsonDecode(response.toString());

    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    if ((res['data'] as List).isEmpty) {
      return;
    }

    setState(() {
      commentList.addAll(res['data']);
    });
    page++;
  }

  void addCommentScrollToBottomListener() {
    _commentListScrollController.addListener(() {
      if (_commentListScrollController.offset >=
              _commentListScrollController.position.maxScrollExtent &&
          !_commentListScrollController.position.outOfRange) {
        getComments();
      }
    });
  }

  @override
  void initState() {
    getComments();
    addCommentScrollToBottomListener();
    super.initState();
  }

  @override
  void dispose() {
    roundedInputController.dispose();
    _commentListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: resetReplyInfo,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                page = 1;
                commentList.clear();
                getComments();
              },
              child: ListView.builder(
                controller: _commentListScrollController,
                itemBuilder: (context, index) {
                  return Comment(
                    likeCount: commentList[index]['likeCount'],
                    id: commentList[index]['id'],
                    avatarUrl: commentList[index]['userAvatarUrl'],
                    userName: commentList[index]['userNickname'],
                    date: commentList[index]['createTime'],
                    content: commentList[index]['content'],
                    children: commentList[index]['children'],
                    userId: commentList[index]['userId'],
                    setReplyToid: setReplyToid,
                  );
                },
                itemCount: commentList.length,
              ),
            ),
          ),

          ///
          ///底部评论输入框
          ///
          Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0.2))),
              child: RoundedInput(
                roundedInputController: roundedInputController,
                hintText: bottomHintText,
                textColor: Colors.white,
                hintColor: Colors.white,
                onClickSendBtn: (text) {
                  send(text);
                },
              ))
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
