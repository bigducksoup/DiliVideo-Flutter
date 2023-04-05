import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Comment extends StatelessWidget {
  Comment(
      {super.key,
      required this.avatarUrl,
      required this.userName,
      required this.date,
      required this.content,
      required this.id,
      required this.likeCount,
      required this.children,
      required this.userId, required this.setReplyToid});

  final String avatarUrl;

  final String userName;

  final String date;

  final String content;

  final String id;

  final int likeCount;

  final String userId;

  TextStyle textStyle =
      TextStyle(color: Colors.purple.shade300, fontWeight: FontWeight.w400);

  final List children;


  final Function(String id) setReplyToid;



  TextEditingController commentController = Get.find<TextEditingController>();

  FocusNode commentInputFocusNode = Get.find();

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.1))),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    userName,
                    style: textStyle,
                  ),
                  Text(
                    date,
                    style: textStyle,
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
            child: GestureDetector(
              onTap: () {
                setReplyToid(id);
                FocusScope.of(context).requestFocus(commentInputFocusNode);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  Expanded(
                    child: Text(
                      content,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                          height: 1.7,
                          ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 60,
                ),
                const Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                Text(
                  "$likeCount",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.thumb_down_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.comment,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
          Visibility(
            visible: children.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  Expanded(
                      child: CommentChildren(
                    children: children,
                    userId: userId,
                    fatherCommentId: id,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentChildren extends StatelessWidget {
  const CommentChildren(
      {super.key,
      required this.children,
      required this.userId,
      required this.fatherCommentId});

  final List children;

  final String userId;

  final String fatherCommentId;

  ///
  ///弹出bottomsheet展示回复详情
  ///
  void popCommentDetail(ctx) {
    Get.bottomSheet(
        ReplyBottomSheetContent(
          fatherCommentId: fatherCommentId,
        ),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xff242527),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++)
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: double.infinity,
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: children[i]['nickName'],
                    style:
                        TextStyle(color: Colors.blue.shade300, fontSize: 16)),
                TextSpan(
                    text: " : ${children[i]['content']} ",
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ])),
            ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            width: double.infinity,
            child: GestureDetector(
                onTap: () {
                  popCommentDetail(context);
                },
                child: Text(
                  "查看更多回复",
                  style: TextStyle(color: Colors.blue.shade300),
                )),
          ),
        ],
      ),
    );
  }
}

class ReplyBottomSheetContent extends StatefulWidget {
  const ReplyBottomSheetContent({super.key, required this.fatherCommentId});

  final String fatherCommentId;

  @override
  State<ReplyBottomSheetContent> createState() =>
      _ReplyBottomSheetContentState();
}

class _ReplyBottomSheetContentState extends State<ReplyBottomSheetContent> {
  List data = [];

  void getdata() async {
    var res = await getReply(widget.fatherCommentId);

    res = jsonDecode(res.toString());

    if (res['code'] != 200) return;

    setState(() {
      data = res['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.black,
      width: width,
      height: height - (width * 9 / 16) - 56,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ///
          ///顶部文字和x号关闭
          ///
          buildTopBar(),
          const SizedBox(
            height: 20,
          ),

          ///
          ///回复列表
          ///
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: ListView.builder(
                itemBuilder: (context, index) => buildReplyItem(index),
                itemCount: data.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildReplyItem(int index) {
    return Container(
      width: double.infinity,
      // height: ,
      decoration: BoxDecoration(
          border:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
          color: maindarkcolor),
      child: Row(
        children: [
          ///
          ///头像区域
          ///
          SizedBox(
            width: 60,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(imageUrl: data[index]['avatar'],fit: BoxFit.cover,)),
                ],
              ),
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8,),
                  Text(data[index]['replierName'],style: TextStyle(color: Colors.white,fontSize: 15),),
                  Text((data[index]['time'] as String).split("T")[0],style: TextStyle(color: Colors.white,fontSize: 13), ),
                  const SizedBox(height: 10,),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white
                      ),
                      children: [
                        const TextSpan(
                          text: "回复"
                        ),
                        TextSpan(
                          text: "@${data[index]['toName']}",
                          style: const TextStyle(color: Color(0xff64b2f1))
                        ),
                        TextSpan(
                          text: "${data[index]['content']}"
                        )
                      ]
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 10,)
                ],
              ))
        ],
      ),
    );
  }

  Widget buildTopBar() {
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
