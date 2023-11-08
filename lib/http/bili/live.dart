


import 'dart:convert';

import 'package:dio/dio.dart';

final biliRequest = Dio(); 



Future<Map<String,dynamic>> getLiveList(int page)async{

  Response<dynamic> res = await biliRequest.get("https://api.live.bilibili.com/xlive/web-interface/v1/second/getList",queryParameters: {
    "platform":"web",
    "parent_area_id":2,
    "area_id":86,
    "sort_type":"",
    "page":page,
    "vajra_business_key":""
  });

  return jsonDecode(res.toString());

}



Future<Map<String,dynamic>> getLivePlayInfo(String roomId)async{
  Response<dynamic> res = await biliRequest.get("https://api.live.bilibili.com/xlive/web-room/v2/index/getRoomPlayInfo",queryParameters: {
      "room_id":roomId,
      "no_playurl":0,
      "mask":1,
      "qn":0,
      "platform":"web",
      "protocol":[0,1],
      "format":[0,1,2],
      "codec":[0,1]
  });
  return jsonDecode(res.toString());
}