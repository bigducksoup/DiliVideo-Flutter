import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/component/commons/tags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../states/auth_state.dart';
import '../../../theme/colors.dart';

class UserInfoBox extends StatefulWidget {
  final String nickname;

  final int bicon;

  final int icon;

  const UserInfoBox(
      {Key? key,
      required this.nickname,
      required this.bicon,
      required this.icon})
      : super(key: key);

  @override
  State<UserInfoBox> createState() => _UserInfoBoxState();
}

class _UserInfoBoxState extends State<UserInfoBox> {

  void routeToInfo(){
     Get.toNamed('/user_info',parameters: {
       "userId":auth_state.id.value
     });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 15,
          ),
          //头像
          GestureDetector(
            onTap: routeToInfo,
            child: Container(
                width: 75,
                height: 75,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: Obx(() => CachedNetworkImage(
                  imageUrl: auth_state.avatarUrl.value,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Container(color: Colors.white,);
                  },
                ))),
          ),
              // Image.network(
              //       auth_state.avatarUrl.value,
              //       height: 80,
              //       width: 80,
              //       fit: BoxFit.cover,
              //       errorBuilder: (context, error, stackTrace) {
              //         return Container(color: Colors.white,);
              //       },
              //     )
          const SizedBox(
            width: 20,
          ),
          //头像右边信息
          SizedBox(
            width: 130,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      widget.nickname,
                      style: TextStyle(
                          color: textwhitecolor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/user_info_manage');
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        color: textwhitecolor,
                        size: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: const [
                    VIPTag()
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "B币:${widget.bicon}",
                      style: const TextStyle(color: Color(0xff5b5d64)),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      "硬币:${widget.icon}",
                      style: const TextStyle(color: Color(0xff5b5d64)),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                )
              ],
            ),
          ),

          //右边空白
          Expanded(
              child: GestureDetector(
                onTap: routeToInfo,
                child: SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "空间",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )),
              ))
        ],
      ),
    );
  }
}
