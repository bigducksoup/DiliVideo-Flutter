import 'package:dili_video/component/like.dart';
import 'package:dili_video/component/commons/time_formatter.dart';
import 'package:dili_video/component/user/user_avatar.dart';
import 'package:dili_video/component/user/user_name_tag.dart';
import 'package:dili_video/entity/comment_params.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:flutter/material.dart';

class PostCommentItem extends StatefulWidget {
  const PostCommentItem(
      {super.key,
      required this.params,
      required this.id,
      required this.userId,
      this.slot,
      this.onClickAvatarAndName,
      this.onClickContent, this.likeType = 0});

  final CommentDisplayParams params;

  final String id;

  final String userId;

  final Widget? slot;

  final int? likeType;

  final Function(String userId, String userAvatar)? onClickAvatarAndName;

  final Function(String content, String commentId, String userNickName)?
      onClickContent;

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
            SizedBox(
              width: MediaQuery.of(context).size.width / 7,
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        widget.onClickAvatarAndName?.call(
                            widget.params.userId, widget.params.userAvatarUrl);
                      },
                      child: UserAvatarSmall(url: widget.params.userAvatarUrl))
                ],
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NickNameTag(
                  level: widget.params.userLevel,
                  name: widget.params.userNickname,
                  ifUp: widget.userId == widget.params.userId,
                  ifVIP: true,
                  userId: widget.params.userId,
                ),
                TimeComparisonScreen(
                  dateTimeString: widget.params.createTime,
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onClickContent?.call(widget.params.content,
                        widget.id, widget.params.userNickname);
                  },
                  child: Text(widget.params.content,
                      softWrap: true, style: const TextStyle(fontSize: 17)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    LikeAction(
                      like: false,
                      size: 20,
                      likeCount: widget.params.likeCount,
                      likeAction: () {
                        likeAction(widget.likeType!, widget.id);
                      },
                    ),
                    // TODO like
                    const HateAction(
                      hate: false,
                      size: 20,
                      hint: SizedBox(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.slot == null
                    ? const SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : widget.slot!
              ],
            ))
          ],
        ));
  }
}
