import 'dart:async';

import 'package:dili_video/component/RoundedInput.dart';
import 'package:dili_video/component/buttons.dart';
import 'package:dili_video/component/enhanced_widget.dart';
import 'package:dili_video/component/like.dart';
import 'package:dili_video/component/post_comment_item.dart';
import 'package:dili_video/component/tags.dart';
import 'package:dili_video/component/time_formatter.dart';
import 'package:dili_video/component/user_avatar_small.dart';
import 'package:dili_video/component/user_name_tag.dart';
import 'package:dili_video/component/video_page/video_control.dart';
import 'package:dili_video/component/video_page/video_list.dart';
import 'package:dili_video/component/video_page/video_player.dart';
import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:dili_video/constant/page_status_constant.dart';
import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:dili_video/entity/comment_params.dart';
import 'package:dili_video/entity/route_argument.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:dili_video/services/size_service.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/theme/text_styles.dart';
import 'package:dili_video/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../http/content_api.dart';

class VideoPageRemake extends StatefulWidget {
  const VideoPageRemake({super.key});

  @override
  State<VideoPageRemake> createState() => _VideoPageRemakeState();
}

class _VideoPageRemakeState extends State<VideoPageRemake>
    with TickerProviderStateMixin {
  //视频信息
  dynamic videoInfo;

  //播放信息
  dynamic playInfo;

  //视频控制器
  VideoPlayerController? videoPlayerController;

  late TabController tabController;

  List<Tab> tabs = [
    const Tab(
      text: '简介',
    ),
    const Tab(text: "评论")
  ];

  //加载状态
  LoadState loadState = LoadState();

  @override
  void initState() {
    super.initState();
    RouteArgument argument = Get.arguments;
    initData(argument);
    _initTab();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _initTab() {
    tabController = TabController(length: tabs.length, vsync: this);
  }

  //初始化数据
  Future<void> initData(RouteArgument argument) async {
    loadState.setLoading();
    initPlayInfo(argument, 5);

    if (argument.type == TYPE_VIDEO_ITEM) {
      setState(() {
        videoInfo = argument.data;
        loadState.setLoaded();
      });
    } else if (argument.type == TYPE_VIDEO_ID) {
      initVideoInfoById(argument.data, 5);
    }
  }

  //根据videoInfoId初始化video信息
  void initVideoInfoById(String videoInfoId, int retryTimes) async {
    if (retryTimes == 0) return;
    try {
      dynamic response = await getVideoInfoById(videoInfoId);

      setState(() {
        videoInfo = handleResponse(response)['data'];
        loadState.setLoaded();
      });
    } catch (e) {
      initVideoInfoById(videoInfoId, retryTimes - 1);
    }

    if (videoInfo == null) {
      setState(() {
        loadState.setError();
      });
    }
  }

  //初始化播放信息
  void initPlayInfo(RouteArgument argument, int retryTimes) async {
    if (retryTimes == 0) return;
    String videoInfoId;
    if (argument.type == TYPE_VIDEO_ITEM) {
      videoInfoId = argument.data['videoInfoId'];
    } else {
      videoInfoId = argument.data;
    }

    try {
      dynamic response = await getPlayUrl(videoInfoId);
      setState(() {
        playInfo = handleResponse(response)['data'];
      });
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(playInfo['fullpath']))
            ..initialize().then((value) {
              setState(() {});
              videoPlayerController!.play();
            });
    } catch (e) {
      initPlayInfo(RouteArgument(TYPE_VIDEO_ID, videoInfoId), retryTimes - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maindarkcolor,
      body: SafeArea(
        child: loadState.render(
            //loading widget
            const CircularProgressIndicator(),
            //error widget
            const FlutterLogo(),
            Column(
              children: [
                _buildVideoPlayer(),
                _buildTabbar(context, tabController, tabs),
                _buildTabView(context, tabController)
              ],
            )),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    double width = SizeUtil.getCurrentWidth(context);
    double height = SizeUtil.getCurrentWidth(context) * 9 / 16;

    return videoPlayerController != null &&
            videoPlayerController!.value.isInitialized
        ? SizedBox(
            height: height,
            width: width,
            child: CustomVideoPlayer(controller: videoPlayerController!),
          )
        : Container(
            height: height,
            width: width,
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()));
  }

  Widget _buildTabbar(
      BuildContext ctx, TabController controller, List<Tab> tabs) {
    return Container(
        width: double.infinity,
        height: 50,
        color: maindarkcolor,
        child: Row(
          children: [
            SizedBox(
              width: 0.5 * SizeUtil.getCurrentWidth(ctx),
              child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Colors.pink.shade400,
                  indicatorColor: Colors.pink.shade300,
                  unselectedLabelColor: Colors.white,
                  controller: controller,
                  tabs: tabs),
            ),
          ],
        ));
  }

  Widget _buildTabView(BuildContext ctx, TabController controller) {
    return Expanded(
      child: Container(
        color: maindarkcolor,
        child: TabBarView(
          controller: controller,
          children: [
            VideoInfoTabView(
              videoInfo: videoInfo,
            ),
            CommentTabView(
              videoInfo: videoInfo,
            )
          ],
        ),
      ),
    );
  }
}

class VideoInfoTabView extends StatefulWidget {
  const VideoInfoTabView({super.key, required this.videoInfo});

  final Map<String, dynamic> videoInfo;

  @override
  State<VideoInfoTabView> createState() => _VideoInfoTabViewState();
}

class _VideoInfoTabViewState extends State<VideoInfoTabView>
    with AutomaticKeepAliveClientMixin {
  LoadState loadState = LoadState(status: LOADED);

  dynamic authorInfo;

  bool show = false;

  List relatedVideos = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    loadState.setLoading();
    await initAuthorInfo();
    await loadRelatedVideo();
    if (!loadState.isError) {
      setState(() {
        loadState.setLoaded();
      });
    }
  }

  Future initAuthorInfo() async {
    try {
      dynamic response =
          await getVideoAuthorInfo(widget.videoInfo['videoAuthorId']);
      Map<String, dynamic> result = handleResponse(response);
      authorInfo = result['data'];
    } catch (e) {
      loadState.setError();
      print(e.toString());
    } finally {
      setState(() {});
    }
  }

  Future loadRelatedVideo() async {
    try {
      dynamic response = await getRelatedVideo(widget.videoInfo['videoInfoId']);
      Map<String, dynamic> res = handleResponse(response);
      setState(() {
        relatedVideos.addAll(res['data']);
      });
    } catch (e) {
      loadState.setError();
      print(e.toString());
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadState.render(
        const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
        const FlutterLogo(),
        SingleChildScrollView(
          child: Column(
            children: [
              _buildUserInfo(context),
              _buildVideoInfo(widget.videoInfo),
              _buildActionButtons(),
              // Text("${widget.videoInfo}"),
              // Text("${authorInfo}"),
              _buildReleatedVideoList()
            ],
          ),
        ));
  }

  Widget _buildUserInfo(BuildContext ctx) {
    double size = 16;

    return authorInfo != null
        ? Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatarSmall(url: authorInfo['avatarUrl']),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NickName(
                      name: authorInfo['nickname'],
                      size: size,
                      color: Colors.purple.shade400,
                    ),
                    FansCount(
                      fanscount: authorInfo['followerCount'],
                      size: 13,
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                const FilletButton(
                  defaultChild: Text("关注"),
                  changedChild: Text("取消"),
                )
              ],
            ),
          )
        : SizedBox();
  }

  Widget _buildVideoInfo(Map<String, dynamic> info) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: SizeUtil.getCurrentWidth(context) * 0.8,
                child: Text(
                  info['title'],
                  style: const TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Expanded(child: SizedBox()),
              FilletButton(
                width: 60,
                height: 30,
                defaultColor: maindarkcolor,
                changedColor: maindarkcolor,
                defaultChild: Text(
                  "展开",
                  style: blueClick,
                ),
                changedChild: Text(
                  "收起",
                  style: blueClick,
                ),
                onPressed: () {
                  setState(() {
                    show = true;
                  });
                },
                onCanceld: () {
                  setState(() {
                    show = false;
                  });
                },
              )
            ],
          ),
          Row(
            children: [
              IconAndTextTag(icon: Icons.tv, text: "${info['watchCount']}"),
              const SizedBox(
                width: 10,
              ),
              IconAndTextTag(
                  icon: Icons.timer_outlined,
                  text: relativeTime(info['createTime'])),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          show
              ? SizedBox(
                  width: double.infinity,
                  child: Text(widget.videoInfo['summary']))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    double size = 30;

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LikeAction(
            like: widget.videoInfo['liked'],
            likeCount: 100,
            size: size,
            bottom: true,
          ),
          HateAction(
            hate: false,
            size: size,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconChangeButton(
                defaultIcon: Icons.star,
                changedIcon: Icons.star_outlined,
                size: size,
                changedColor: Colors.pink,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text("收藏")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyIconButton(
                onPressed: () {},
                icon: Icons.share,
                size: size,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text("分享")
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReleatedVideoList() {
    return VideoList(
      videoList: relatedVideos,
      clickItem: (videoInfo) {
        Get.off(
          const VideoPageRemake(),
          arguments: RouteArgument(TYPE_VIDEO_ITEM, videoInfo),
          preventDuplicates: false,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CommentTabView extends StatefulWidget {
  const CommentTabView({super.key, required this.videoInfo});

  final Map<String, dynamic> videoInfo;

  @override
  State<CommentTabView> createState() => _CommentTabViewState();
}

class _CommentTabViewState extends State<CommentTabView>
    with AutomaticKeepAliveClientMixin {
  List data = [];

  int mode = 0;

  int page = 1;

  LoadState loadState = LoadState();

  String barText = "热门评论";

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      dynamic response =
          await getComment(page, mode, widget.videoInfo['videoInfoId']);
      Map<String, dynamic> res = handleResponse(response);
      setState(() {
        page++;
        data.addAll(res['data']);
        loadState.setLoaded();
      });
    } catch (e) {
      loadState.setError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadState.render(
        const Center(
          child: CircularProgressIndicator(),
        ),
        const FlutterLogo(),
        Column(
          children: [
            Expanded(
              child: EnhancedCustomeScrollView(
                onReachBottom: () async {
                  await _fetchData();
                },
                onPullDown: () async{
                  page = 1;
                  setState(() {
                    data.clear();
                  });
                  await _fetchData();
                },
                slivers: [
                  SliverToBoxAdapter(child: _buildTopBar()),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return PostCommentItem(params: CommentDisplayParams.fromJson(data[index]), id: data[index]['id'], upId: data[index]['userId']);
                  }, childCount: data.length))
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: RoundedInput(roundedInputController: RoundedInputController(), hintText: "haha"),
            )
          ],
        ));
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      width: double.infinity,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(barText),
          WidgetChangeButton(
            defaultWidget: const Text("=按热度"),
            changedWidget: const Text("=按时间"),
            onClick: () {
              setState(() {
                data.clear();
              });
              page = 1;
              mode = 1;
              _fetchData();
              setState(() {
                barText = "最近评论";
              });
            },
            onCancel: () {
              setState(() {
                data.clear();
              });
              page = 1;
              mode = 0;
              _fetchData();
              setState(() {
                barText = "热门评论";
              });
            },
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
