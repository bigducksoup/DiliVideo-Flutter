import 'package:dili_video/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Options extends StatelessWidget {
  const Options({super.key});

  static List<Widget> icons = [saveIcon, historyIcon, collectIcon, laterIcon];
  static List<String> description = ["离线缓存","历史记录","我的收藏","稍后再看"];
  static List<String> route = ["","/video_history","",""];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for(int i=0;i<4;i++)
          GestureDetector(
            onTap: (){
              Get.toNamed(route[i]);
            },
            child: Column(
              children: [
                icons[i],
                const SizedBox(height: 4,),
                Text(description[i],style: const TextStyle(color: Colors.white),)
              ],
            ),
          )
      ]
      );
  }
}
