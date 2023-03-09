import 'dart:convert';

import 'package:dio/dio.dart';

import '../utils/shared_preference.dart';



final dio = Dio();


void initDio(){
  dio.options.baseUrl = 'http://127.0.0.1:8084';
  // dio.options.connectTimeout = const Duration(seconds: 5);
  // dio.options.receiveTimeout = const Duration(seconds: 3);

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

      return handler.next(e);
    },
    onError: (e, handler){
      return handler.next(e);
    },
  ),
  );

}



