
import 'package:dili_video/views/mine/component/bottom_options.dart';
import 'package:dili_video/views/mine/component/options.dart';
import 'package:dili_video/views/mine/component/publish_button_box.dart';
import 'package:dili_video/views/mine/component/top_button.dart';
import 'package:dili_video/views/mine/component/user_info_box.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:get/get.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  final width = window.physicalSize.width;
  final height = window.physicalSize.height;

  final _numberTextStyle = const TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maindarkcolor,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          // width: double.infinity,
          // height: MediaQuery.of(context).size.height,
          color: maindarkcolor,
          child: Column(
            children: [
              //顶部三个按钮
              const TopButton(),
              //个人信息栏
              Obx(() => UserInfoBox(
                    nickname: "${auth_state.nickname}",
                    icon: 0,
                    bicon: 0,
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${auth_state.publishCount}",
                            style: _numberTextStyle,
                          ),
                          Text(
                            "动态",
                            style: TextStyle(color: textwhitecolor),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${auth_state.followedCount}",
                            style: _numberTextStyle,
                          ),
                          Text(
                            "关注",
                            style: TextStyle(color: textwhitecolor),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${auth_state.followerCount}",
                            style: _numberTextStyle,
                          ),
                          Text(
                            "粉丝",
                            style: TextStyle(color: textwhitecolor),
                          )
                        ],
                      )
                    ]),
              ),
              //发布视频按钮
              const PublishButtonBox(),
              const SizedBox(
                height: 30,
              ),
              const Options(),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "更多服务",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const BottomOptions()
            ],
          ),
        ),
      ),
    );
  }
}
