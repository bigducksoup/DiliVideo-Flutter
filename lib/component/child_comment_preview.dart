import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../entity/child_comment_preview.dart';

class ChildCommentListPreview extends StatelessWidget {
  const ChildCommentListPreview(
      {super.key,
      required this.list,
      this.onClickUsername,
      this.onClickContent,
      this.clickSeeMore});

  final List<ChildPreviewComment> list;

  final Function(String userId, String userName)? onClickUsername;

  final Function(String commentId, String content)? onClickContent;

  final Function()? clickSeeMore;

  Widget _buildRecord(ChildPreviewComment item) {
    return Text.rich(TextSpan(style: const TextStyle(fontSize: 16), children: [
      TextSpan(
          text: "${item.nickName}: ",
          style:const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          recognizer: TapGestureRecognizer()..onTap = () {
              onClickUsername?.call(item.userId, item.nickName);
            }),
      TextSpan(
          text: item.content,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              onClickContent?.call(item.id, item.content);
            })
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xff242527),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (ChildPreviewComment c in list)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildRecord(c)),
                GestureDetector(
                    onTap: clickSeeMore,
                    child: const Text(
                      "查看更多回复",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ))
              ],
            ),
          );
  }
}
