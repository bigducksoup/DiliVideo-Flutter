import 'dart:math';

import 'package:dili_video/component/card/card_with_cover.dart';
import 'package:dili_video/component/card/video_item.dart';
import 'package:dili_video/component/commons/enhanced_widget.dart';
import 'package:dili_video/component/user/user_avatar.dart';
import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:dili_video/entity/route_argument.dart';
import 'package:dili_video/pages/live_page/LivePage.dart';
import 'package:dili_video/services/size_service.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/theme/box_style.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../http/bili/live.dart';



class Live extends StatefulWidget {
  const Live({super.key});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live>  with AutomaticKeepAliveClientMixin{


  List data = [];

  int page = 1;


  Future<void> _fetchData()async{
    Map<String,dynamic> response = await getLiveList(page);
    setState(() {
      data.addAll(response['data']['list']);
    });
    page++;
  }



  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: EnhancedCustomeScrollView(
        slivers: [
          //  SliverToBoxAdapter(
          //   child: FollowingLive(userId: auth_state.id.value,)
          // ),
          SliverList(delegate:SliverChildBuilderDelegate((context, index) {
            return Container(
              padding: const EdgeInsets.all(5),
              height:250,
              child:  CardWithCover(
                coverUrl: data[index]['user_cover'],
                title: data[index]['title'],
                leftBottomWidget: Text("${data[index]['watched_show']['text_large']}"),
                bottomHeight: 50,
                onClick: () {
                  Get.to(const LivePage(),arguments: RouteArgument(LIVE_ROOM_ID,data[index]['roomid']));
                },
                ));
          },childCount: data.length))
        ],
        onReachBottom: () async{
          _fetchData();
        },
        onPullDown: () async{
          setState(() {
            data.clear();
            page = 1;
          });
          _fetchData();
        },
      ),
    );
}

  @override
  bool get wantKeepAlive => true;


}





class FollowingLive extends StatefulWidget {
  const FollowingLive({super.key, required this.userId});

  final String userId;

  @override
  State<FollowingLive> createState() => _FollowingLiveState();
}

class _FollowingLiveState extends State<FollowingLive> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: roundedBox(radius: 5,color: maindarkcolor),
      child: Column(
        children: [
          _buildTopBar(5),
          Expanded(child:_buildFollowLiveList())
        ],
      ),
    );
  }





  Widget _buildTopBar(int n){
    return  SizedBox(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Text("我的关注",style: whiteHeavy(size: 17),),
                const SizedBox(width: 5,),
                Text("$n人正在直播")],),
                TextButton(onPressed: (){}, child: const Text("查看更多"))
              ],
            ),
          );
  }


  Widget _buildFollowLiveList(){

    return ListView.builder(itemBuilder:(context, index) =>  Container(
      padding: const EdgeInsets.only(left: 20),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Avatar(url: "http://127.0.0.1:9000/img/wallhaven-m3pex1.png",size: 30,borderColor: Colors.pink,),
        Text("${Random().nextInt(100)}"),
      ]),
    ),scrollDirection: Axis.horizontal,itemCount: 20,);

  }




}




