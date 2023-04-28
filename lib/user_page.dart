import 'dart:convert';

import 'package:dili_video/http/auth_api.dart';
import 'package:dili_video/services/userOperation.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:dili_video/video_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'http/content_api.dart';

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                      "https://i0.hdslb.com/bfs/archive/a349e5844a068d9767d699ab4fdbaa16030af585.png",
                      fit: BoxFit.scaleDown))),
          SliverToBoxAdapter(
            child: Padding(
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
          ),
          SliverToBoxAdapter(
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
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 0.3, color: Colors.white54))),
              height: 50,
              child: TabBar(
                tabs: const [Text("主页"), Text("动态"), Text("投稿")],
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.pink.shade300,
                labelColor: Colors.pink.shade300,
                unselectedLabelColor: Colors.white,
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabController,
              children: [
                Index(),
                Trends(),
                Works(
                  userId: _userId,
                )
              ],
            ),
          )
        ],
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
    return const Placeholder();
  }
}

class Works extends StatefulWidget {
  const Works({super.key, required this.userId});

  final String userId;

  @override
  State<Works> createState() => _WorksState();
}

class _WorksState extends State<Works> with AutomaticKeepAliveClientMixin {
  var _videoList = [];

  int page = 1;

  void getUploaded() async {
    var response = await getUserPublishedVideos(widget.userId, page);
    var res = jsonDecode(response.toString());
    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    setState(() {
      _videoList = res['data'];
      print(_videoList);
    });
  }

  @override
  void initState() {
    getUploaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var item = _videoList[index];
          return GestureDetector(
            onTap: () async {
              Get.toNamed('/video', arguments: item);
            },
            child: VideoItem(
              coverUrl: item['coverUrl'],
              title: item['title'],
              videoAuthorName: item['videoAuthorName'],
              watchCount: item['watchCount'],
              date: item['createTime'],
            ),
          );
        },
        itemCount: _videoList.length,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Trends extends StatefulWidget {
  const Trends({super.key});

  @override
  State<Trends> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  @override
  Widget build(BuildContext context) {
    return FlutterLogo();
  }
}
