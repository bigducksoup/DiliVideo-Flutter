import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/http/content_api.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'assets/assets.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  var item;

  // {
  //           "videoInfoId": "a8acba5e-c21f-43cf-af0f-ce86f537f8f6",
  //           "videoAuthorId": "1",
  //           "collectCount": 0,
  //           "commentCount": 0,
  //           "createTime": "2023-03-09T03:16:26.000+00:00",
  //           "isOriginal": 0,
  //           "watchCount": 0,
  //           "likeCount": 0,
  //           "isPublish": 1,
  //           "openComment": 1,
  //           "title": "code",
  //           "summary": "code",
  //           "videoFileId": "8fadbbc7-48af-421a-a667-cb50ee750caa",
  //           "videoFileUrl": "null",
  //           "videoFileName": "null",
  //           "coverId": "4fe6fd99-1243-4eb0-b31f-210e40eb1633",
  //           "coverName": "f71fa4ff-a93d-4bb3-a7e1-e6fb58448d5a.jpg",
  //           "coverUrl": "http://127.0.0.1:9000/img/cf/c6/f71fa4ff-a93d-4bb3-a7e1-e6fb58448d5a.jpg"
  //       }

  late TabController _tabController;

  @override
  void initState() {
    item = Get.arguments;
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black)),
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Container(
            color: maindarkcolor,
            width: double.infinity,
            height: double.infinity,
            child: Column(children: [
              MyVideoPlayer(
                item: item,
              ),
              Row(
                children: [
                  Container(
                    width: 0.5 * width,
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.pink.shade400,
                        indicatorColor: Colors.pink.shade300,
                        unselectedLabelColor: Colors.white,
                        controller: _tabController,
                        tabs: const [
                          Tab(
                            text: '简介',
                          ),
                          Tab(text: "评论")
                        ]),
                  ),
                ],
              ),
              Expanded(
                  child: TabBarView(controller: _tabController, children: [
                Center(
                  child: VideoInfoView(
                    item: item,
                  ),
                ),
                const Center(
                  child: FlutterLogo(),
                )
              ]))
            ]),
          )),
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({super.key, this.item});

  final item;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  VideoPlayerController? _videoController;

  var itemcopy;

  bool _videoControllFrame = false;

  Map<String, dynamic> videoPlayState = {"playing": true, "progress": 0.0};

  @override
  void initState() {
    super.initState();
    itemcopy = widget.item;
    getVideoPlayUrl();
  }

  @override
  void dispose() {
    if (_videoController != null) {
      _videoController!.dispose();
    }
    super.dispose();
  }

  void getVideoPlayUrl() async {
    var response = await getPlayUrl(itemcopy['videoFileId']);
    var responResult = jsonDecode(response.toString());
    var videoFile = responResult['data'];
    itemcopy['videoFileUrl'] = videoFile['fullpath'];
    itemcopy['videoFileName'] = videoFile['uniqueName'];

    _videoController = VideoPlayerController.network(itemcopy['videoFileUrl'])
      ..initialize().then((value) {
        setState(() {});
      });

    _videoController!.play();
  }

  Widget buildPlayerWindow() {
    if (_videoController == null ||
        _videoController!.value.isInitialized == false) {
      return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(imageUrl: widget.item['coverUrl'],fit: BoxFit.cover,)
          );
    } else {
      _videoController!.addListener(() {
        setState(() {
          videoPlayState['progress'] =
              _videoController!.value.position.inSeconds /
                  _videoController!.value.duration.inSeconds *
                  100;

          if (videoPlayState['progress'] == 100) {
            videoPlayState['playing'] = false;
          }
        });
      });
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: width * 9 / 16,
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: width * 9 / 16,
            child: Hero(
              tag: widget.item['videoInfoId'],
              child: buildPlayerWindow(),
            ),
          ),
          //控制层
          GestureDetector(
            onTap: () {
              setState(() {
                _videoControllFrame = !_videoControllFrame;
              });
            },
            child: AnimatedOpacity(
              opacity: _videoControllFrame ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.transparent,
                width: width,
                height: width * 9 / 16,
                child: Visibility(
                  visible: _videoControllFrame,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            //back button
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            //pause or play button
                            SizedBox(
                              child: videoPlayState['playing']
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          _videoController?.pause();
                                          videoPlayState['playing'] = false;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.pause,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          _videoController?.play();
                                          videoPlayState['playing'] = true;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                            ),
                            //进度条
                            SizedBox(
                                width: width * 0.8,
                                child: Slider(
                                    activeColor: Colors.pink.shade300,
                                    inactiveColor: Colors.white,
                                    min: 0.0,
                                    max: 100,
                                    divisions: 100,
                                    value: videoPlayState['progress'],
                                    onChanged: (value) {
                                      setState(() {
                                        videoPlayState['progress'] = value;
                                        int seconds =
                                            ((videoPlayState['progress'] /
                                                    100 *
                                                    _videoController!
                                                        .value
                                                        .duration
                                                        .inSeconds) as double)
                                                .round();
                                        Duration d = Duration(seconds: seconds);
                                        _videoController!.seekTo(d);
                                      });
                                    })),
                            const FaIcon(
                              FontAwesomeIcons.maximize,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}






class VideoInfoView extends StatefulWidget {
  const VideoInfoView({super.key, this.item});

  final item;

  @override
  State<VideoInfoView> createState() => _VideoInfoViewState();
}

class _VideoInfoViewState extends State<VideoInfoView> {
  Map<String, dynamic> _videoUserInfo = {
    "id": "1",
    "nickname": "loading..",
    "avatarUrl": "http://127.0.0.1:9000/img/wallhaven-m3pex1.png",
    "summary": "none",
    "followerCount": 0,
    "followedCount": 0,
    "publishCount": 0,
    "isBaned": 0,
    "level": 0,
    "exp": 0,
    "birthday": "2023-03-03T16:00:00.000+00:00",
    "gender": 1
  };

  @override
  void initState() {
    super.initState();
    getVideoAuthorInfo(widget.item['videoAuthorId']).then((value) {
      var responseResult = jsonDecode(value.toString());
      if(mounted){
        setState(() {
        _videoUserInfo = responseResult['data'];
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserInfoRow(videoUserInfo: _videoUserInfo,),
        VideoTitleAndInfo(videoInfo: widget.item,)
      ],
    );
  }
}





class UserInfoRow extends StatelessWidget {
  const UserInfoRow({super.key, this.videoUserInfo});

  final videoUserInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
          child: Container(
            height: 50,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  clipBehavior: Clip.hardEdge,
                  width: 40,
                  height: 40,
                  child: Image.network(
                    videoUserInfo['avatarUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text("ops!"));
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(videoUserInfo['nickname'],
                        style: TextStyle(
                            color: Colors.pink.shade400,
                            fontWeight: FontWeight.w600)),
                    Text(
                      "${videoUserInfo['followerCount']}粉丝",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                    width: 80,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("关注"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.pink.shade300)
                      ),
                    )),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        );
  }
}




class VideoTitleAndInfo extends StatelessWidget {
   VideoTitleAndInfo({super.key, this.videoInfo});
  final videoInfo;

  

  List<Widget> buildIcons(){
    List<Widget> icons = [];
    double size = 35;
    Color color = Colors.white54;
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color
    );
    icons.add(
      Column(
        children: [
          Icon(Icons.favorite,size: size,color: color,),
          SizedBox(height: 5,),
          Text("点赞",style:textStyle)
        ],
      )
    );
    icons.add(
      Column(
        children: [
          Icon(Icons.heart_broken_rounded,size: size,color: color,),
          SizedBox(height: 5,),
          Text("不喜欢",style:textStyle)
        ],
      )
    );    
  icons.add(
      Column(
        children: [
          Icon(Icons.control_point_rounded,size: size,color: color,),
          SizedBox(height: 5,),
          Text("投币",style:textStyle)
        ],
      )
    );
    icons.add(
      Column(
        children: [
          Icon(Icons.star_rate_rounded,size: size,color: color,),
          SizedBox(height: 5,),
          Text("收藏",style:textStyle)
        ],
      )
    );
    icons.add(
      Column(
        children: [
          Icon(Icons.share_rounded,size: size,color: color,),
          SizedBox(height: 5,),
          Text("分享",style:textStyle)
        ],
      )
    );


    return icons;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(videoInfo['title'],style: const TextStyle(color: Colors.white,fontSize: 20),),
          SizedBox(height: 10,),
          Row(
            children: [
              Icon(Icons.play_arrow_outlined,size: 20,color: Colors.white30,weight: 10,),
              Text("${videoInfo['watchCount']}",style: TextStyle(color: Colors.white30),),
              SizedBox(width: 10,),
              Icon(Icons.comment,size: 20,color: Colors.white30,),
              SizedBox(width: 5,),
              Text("${videoInfo['commentCount']}",style: TextStyle(color: Colors.white30),),
              SizedBox(width: 10,),
              Text("${(videoInfo['createTime'] as String).substring(0,16)}",style: TextStyle(color: Colors.white30),)

            ],
          ),
          SizedBox(height: 5,),
          Text("${videoInfo['summary']}",style: TextStyle(color: Colors.white30)),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buildIcons()
          )

        ],
      ),
    );
  }
}