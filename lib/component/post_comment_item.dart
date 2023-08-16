import 'dart:ffi';

import 'package:dili_video/component/like.dart';
import 'package:dili_video/component/time_formatter.dart';
import 'package:dili_video/component/user_avatar_small.dart';
import 'package:dili_video/component/user_name_tag.dart';
import 'package:dili_video/entity/comment_params.dart';
import 'package:flutter/material.dart';

class PostCommentItem extends StatefulWidget {
  const PostCommentItem(
      {super.key,
      required this.params,
      required this.postId,
      required this.upId, this.slot});

  final CommentDisplayParams params;

  final String postId;

  final String upId;

  final Widget? slot;

  @override
  State<PostCommentItem> createState() => _PostCommentItemState();
}

class _PostCommentItemState extends State<PostCommentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 7,
              child: Column(
                children: [UserAvatarSmall(url: widget.params.userAvatarUrl)],
              ),
            ),
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NickNameTag(
                    level: widget.params.userLevel,
                    name: widget.params.userNickname,
                    ifUp: widget.upId == widget.params.userId,
                    ifVIP: true,
                    userId: widget.params.userId,
                  ),
                  TimeComparisonScreen(
                    dateTimeString: widget.params.createTime,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.params.content,
                      softWrap: true, style: const TextStyle(fontSize: 17)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children:  const [
                      LikeAction(
                        like: false,
                        size: 20,
                        likeCount: 2131122,
                      ),
                      SizedBox(width: 10,), // TODO like
                      HateAction(hate: false,size: 20,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  widget.slot==null? const SizedBox(width: 0,height: 0,):widget.slot!
                ],
              ),
            ))
          ],
        ));
  }
}
