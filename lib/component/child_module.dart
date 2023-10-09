import 'dart:convert';

import 'package:dili_video/entity/post_vo.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:dili_video/services/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/post_detail/post_detail.dart';

class ChildPost extends StatefulWidget {
  const ChildPost({super.key, required this.postId});

  final String postId;

  @override
  State<ChildPost> createState() => _ChildPostState();
}

class _ChildPostState extends State<ChildPost> {
  late PostVO post;

  bool isInit = false;

  Future<void> initData() async {
    var response = await getPostInfoById(widget.postId);

    
    Map res = jsonDecode(response.toString());
    if (res['code'] != 200) {
      Get.back();
      return;
    }
    setState(() {
      print(res['data'].toString());
      post = PostVO.fromJson(res['data']);
      isInit = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        Get.to(const PostDetailPage(), arguments: post.toJson());
      },
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black,
          ),
          child: isInit
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(onTap: () {
                    routeToUserPage(post.moduleVO.userId);
                  },child: Text("@${post.moduleVO.userNickname}",style: const TextStyle(color: Colors.blue,fontSize: 16),)),
                  const SizedBox(height: 10,),
                  Text(post.moduleVO.description,style: const TextStyle(color: Colors.white,fontSize: 18)),
                  const SizedBox(height: 5,)
                ],
              )
              :  Center(child: CircularProgressIndicator(color: Colors.pink.shade400,))),
    );
  }
}
