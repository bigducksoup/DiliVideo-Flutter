import 'dart:convert';

import 'package:dili_video/http/auth_api.dart';
import 'package:dili_video/pages/user_page/post_tab_view.dart';
import 'package:dili_video/pages/user_page/work_tab_view.dart';
import 'package:dili_video/services/userOperation.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:dili_video/pages/video_manage/video_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../http/content_api.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  String _userId = '';

  int followCount = 0;

  int fansCount = 0;

  String nickName = "";

  String summary = "";

  String avatarUrl = "";

  var userInfo;
  // {
  //       "id": "1",
  //       "nickname": "ducksoup",
  //       "avatarUrl": "http://127.0.0.1:9000/img/wallhaven-m3pex1.png",
  //       "summary": "none",
  //       "followerCount": 0,
  //       "followedCount": 0,
  //       "publishCount": 0,
  //       "isBaned": 0,
  //       "level": 0,
  //       "exp": 0,
  //       "birthday": "2023-03-03T16:00:00.000+00:00",
  //       "gender": 1
  //   }

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    _userId = Get.parameters['userId']!;

    getUserInfo();

    super.initState();
  }

  void setUserInfo(var info) {
    setState(() {
      userInfo = info;
      fansCount = info['followerCount'];
      followCount = info['followedCount'];
      summary = info['summary'];
      nickName = info['nickname'];
      avatarUrl = info['avatarUrl'];
    });
  }

  void getUserInfo() async {
    var response = await getBasicUserInfo(_userId);
    var res = jsonDecode(response.toString());
    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    userInfo = res['data'];
    setUserInfo(res['data']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(headerSliverBuilder:(context, innerBoxIsScrolled) {
        return [
          _buildSliverAppBar()
        ];
      }, body: TabBarView(
              controller: tabController,
              children: [
                Index(),
                Post(userId: _userId,),
                Works(
                  userId: _userId,
                )
              ],
            ),),
    );
  }





  Widget _buildSliverAppBar(){
    return SliverAppBar(
            toolbarHeight: 50,
            expandedHeight: 280,
            floating: true,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  children: [
                    Image.network(
                        "https://i0.hdslb.com/bfs/archive/a349e5844a068d9767d699ab4fdbaa16030af585.png",
                        fit: BoxFit.scaleDown),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: avatarUrl == ""
                                    ? null
                                    : DecorationImage(
                                        image: NetworkImage(avatarUrl),
                                        fit: BoxFit.cover)),
                          ),
                          CountInfo(
                              followCount: followCount,
                              fansCount: fansCount,
                              userId: _userId)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 100,
                                child: Center(
                                    child: Text(
                                  nickName,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600),
                                ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(summary),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 50),
              child: _buildTabbar()
            ),
          );
  }




  Widget _buildTabbar(){
    return Container(
                padding: const EdgeInsets.fromLTRB(5, 12, 5, 12),
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 0.3,color: Colors.grey))
                ),
                child: TabBar(
                  tabs: const [Text("主页"), Text("动态"), Text("投稿")],
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.pink.shade300,
                  labelColor: Colors.pink.shade300,
                  unselectedLabelColor: Colors.white,
                ),
              );
  }



}





class CountInfo extends StatefulWidget {
  const CountInfo(
      {super.key,
      required this.followCount,
      required this.fansCount,
      required this.userId});

  final int followCount;

  final int fansCount;

  final String userId;

  @override
  State<CountInfo> createState() => _CountInfoState();
}

class _CountInfoState extends State<CountInfo> {
  bool ifFollow = false;

  void checkIfFollow(id) async {
    var response = await checkFollow(id);
    var res = jsonDecode(response.toString());

    setState(() {
      ifFollow = res['data'];
    });
  }

  @override
  void initState() {
    checkIfFollow(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 100,
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [Text("粉丝"), Text("${widget.fansCount}")],
              ),
              Container(
                height: 30,
                width: 0.3,
                color: Colors.black,
              ),
              Column(
                children: [Text("关注"), Text("${widget.followCount}")],
              ),
            ],
          ),
          ifFollow
              ? ElevatedButton(
                  onPressed: () async {
                    var ifSuccess = await unfollowUp(widget.userId);
                    setState(() {
                      ifFollow = !ifSuccess;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  child: const Text("取消关注"),
                )
              : ElevatedButton(
                  onPressed: () async {
                    var ifSuccess = await followUp(widget.userId);
                    setState(() {
                      ifFollow = ifSuccess;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.pink.shade300)),
                  child: const Text("关注"),
                )
        ],
      ),
    );
  }
}

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder:(context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(width: double.infinity,height: 200,color: Colors.amber,),
      );
    },itemCount: 200,);
  }
}


