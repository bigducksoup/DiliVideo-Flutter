import 'dart:convert';

import 'package:dili_video/component/video_page/%20comment.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentView extends StatefulWidget {
  const CommentView({super.key, required this.videoInfoId});

  final String videoInfoId;

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> with AutomaticKeepAliveClientMixin {

  TextEditingController commentController = Get.put<TextEditingController>(TextEditingController());

  FocusNode commentInputFocusNode = Get.put(FocusNode());

  final ScrollController _commentListScrollController = ScrollController();

  int page = 1;
  int mode = 1;
  List commentList = [];
  String replyToid = "";



  void setReplyToid(String id) {
    replyToid = id;
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
    }else{
      //发送回复请求
      var response = await replyComment(value, replyToid, replyToid);
      var res = jsonDecode(response.toString());
      TextToast.showToast(res['msg']);
      if (res['code'] != 200) return;
      //toast
      
    }
    commentInputFocusNode.unfocus();
    commentController.clear();
  }

  void getComments() async {
    var response = await getComment(page, mode, widget.videoInfoId);
    var res = jsonDecode(response.toString());

    if(res['code']!=200){
      TextToast.showToast(res['msg']);
      return;
    }

    if((res['data'] as List).isEmpty){
      return;
    }

    setState(() {
      commentList.addAll(res['data']);
    });
    page++;
  }

  void addFocusNodeListener() {
    commentInputFocusNode.addListener(() {
      if (!commentInputFocusNode.hasFocus) {
        setReplyToid("");
      }
    });
  }


  void addCommentScrollToBottomListener(){
    _commentListScrollController.addListener(() {
      if(_commentListScrollController.offset >= _commentListScrollController.position.maxScrollExtent && !_commentListScrollController.position.outOfRange){
        getComments();
      }
    });
  }

  @override
  void initState() {
    getComments();
    addFocusNodeListener();
    addCommentScrollToBottomListener();
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    commentInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        if (commentInputFocusNode.hasFocus) {
          commentInputFocusNode.unfocus();
        } else {
          return;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                page=1;
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
                    date: (commentList[index]['createTime'] as String)
                        .split("T")[0],
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.grey, width: 0.2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            height: 40,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Container(
                                height: 40,
                                child: TextField(
                                  maxLines: 1,
                                    focusNode: commentInputFocusNode,
                                    controller: commentController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0)
                                    ),
                                    cursorColor: Colors.pink,
                                    onSubmitted: send,
                                    
                                    ),
                              ),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          send(commentController.text);
                        },
                        child: Icon(
                          Icons.send,
                          size: 30,
                          color: Colors.pink.shade300,
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
