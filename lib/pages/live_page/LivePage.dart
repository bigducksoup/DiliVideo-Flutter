import 'package:dili_video/constant/argument_type_constant.dart';
import 'package:dili_video/entity/route_argument.dart';
import 'package:dili_video/http/bili/live.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {


  @override
  void initState() {
    super.initState();
    RouteArgument argument = Get.arguments;
    if(argument.type == LIVE_ROOM_ID){
      getLivePlayInfo(argument.data.toString()).then((value) {
        print(value.toString());
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}