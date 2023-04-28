

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_pack;




import '../utils/shared_preference.dart';



final dio = Dio();


void initDio(){
  dio.options.baseUrl = 'http://127.0.0.1:8084';
  // dio.options.connectTimeout = const Duration(seconds: 10);
  // dio.options.receiveTimeout = const Duration(seconds: 10);

  dio.interceptors.add(
    InterceptorsWrapper(
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
      // 如果你想终止请求并触发一个错误,你可以使用 `handler.reject(error)`。



      var token = await LocalStorge.getValue("token", "12".runtimeType);
      if(token!=null){
              Map<String,dynamic> tokenmap = {
              "token":token
      };
      options.headers.addAll(tokenmap);
      }


      return handler.next(options);
    },
    onResponse: ( Response e, handler) {
      var res = jsonDecode(e.toString());

      // if(res['code']!=200){
      //   get_pack.Get.defaultDialog(title: "ops!",middleText: "请求出错了 o.o!",backgroundColor:Colors.pink.shade300 );
      // }

      return handler.next(e);
    },
    onError: (e, handler){
      get_pack.Get.defaultDialog(title: "ops!",middleText: "请求出错了 o.o!",backgroundColor:Colors.pink.shade300 );
      return handler.next(e);
    },
  ),
  );

}



