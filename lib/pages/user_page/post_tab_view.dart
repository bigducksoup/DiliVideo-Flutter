import 'dart:convert';

import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';

import '../../component/post_item.dart';

class Post extends StatefulWidget {
  const Post({super.key, required this.userId});

  final String userId;

  @override
  State<Post> createState() => _PostState();
}


///
/// 用户动态列表
///

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
  //数据
  List data = [];

  //页数
  int page = 1;

  bool isEnd = false;

  //获取数据
  void getPosts() async {
    var response = await getPostsByUserId(widget.userId, page);
    var res = jsonDecode(response.toString());
    if (res['code'] == 200) {
      if((res['data'] as List).isEmpty){
        return;
      }
      setState(() {
        data.addAll(res['data']);
      });
      page++;
      return;
    }
    TextToast.showToast(res['msg']);
  }


  bool onScrollNotification(ScrollNotification notification){
    if(!isEnd && notification.metrics.pixels == notification.metrics.maxScrollExtent){
      isEnd = true;
      getPosts();
    }else if (isEnd && notification.metrics.pixels < notification.metrics.maxScrollExtent){
      isEnd = false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }



  //listview在这里
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                PostItem(
                  item: data[index],
                ),
      
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.black,
                )
              ],
            );
          },
          itemCount: data.length,
        ),
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}





