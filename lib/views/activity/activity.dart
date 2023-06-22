import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:dili_video/views/activity/child/all_activity.dart';
import 'package:dili_video/views/activity/child/post_publish.dart';
import 'package:dili_video/views/activity/child/video_activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> with SingleTickerProviderStateMixin {


  List<Widget> tabs = [
    Tab(text: "视频",),
    Tab(text: "动态"),
  ];

  late TabController _tabController;


  List<Widget> tabViews(){
    return [const VideoActivityView(),const AllActivityView()];
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 150,
          child: TabBar(
            tabs:tabs,
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            indicatorColor: const Color(0xffdc5081),
            labelColor: const Color(0xffdc5081),
            // ignore: prefer_const_constructors
            unselectedLabelColor: Color(0xff767678),
            labelStyle: const TextStyle(fontSize: 19,fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600),
            ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Get.to(PostPublish(),transition: Transition.downToUp);
              },
              child: const Icon(Icons.edit_note,color: Color(0xffa0a2aa),
              size: 30,
              ),
            ),
          )
        ],
      ),
      body: TabBarView(controller: _tabController,children: tabViews(),),
    );
  }



}