import 'package:dili_video/component/commons/time_formatter.dart';
import 'package:dili_video/component/user/user_avatar.dart';
import 'package:dili_video/entity/replyVO.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


import '../theme/colors.dart';

class ReplyItem extends StatelessWidget {
  const ReplyItem({super.key, required this.reply, this.onClickAvatarAndName, this.onClickToName, this.onClickContent});

  final ReplyVO reply;
  
  final Function(String userId,String? userAvatar,String userNickName)? onClickAvatarAndName;

  final Function(String userId,String userName)? onClickToName;

  final Function(String? content,String? userId,String? userName,String? toId,String? toName,String commentId)? onClickContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: ,
      decoration: BoxDecoration(
          border:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
          color: maindarkcolor),
      child: Column(
        children: [
          GestureDetector(onTap: () {
            onClickAvatarAndName?.call(reply.replierId,reply.avatar,reply.replierName);
          },child: _buildInfoBar(reply)),
          const SizedBox(height: 10,),
          Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        children: [
                          const TextSpan(text: "回复"),
                          TextSpan(
                              text: "@${reply.toName}",
                              style: const TextStyle(color: Color(0xff64b2f1)),
                              recognizer: TapGestureRecognizer()..onTap=(){
                                onClickToName?.call(reply.toId,reply.toName);
                              }
                              ),
                          TextSpan(
                              text: ": ${reply.content}",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  onClickContent?.call(reply.content,reply.replierId,reply.replierName,reply.toId,reply.toName,reply.id);
                                })
                        ]),
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }





  Widget _buildInfoBar(ReplyVO r){


    return Row(
      children: [
        SizedBox(width: 60,child: UserAvatarSmall(url: r.avatar),),
        Column(
          children: [
          Text(
            reply.replierName,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          TimeComparisonScreen(dateTimeString: reply.time),
          ],
        )
      ],
    );
  }



}
