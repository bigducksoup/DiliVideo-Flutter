import 'package:dio/dio.dart';

import 'dio_manager.dart';



//获取所有分区
Future getAllPartition() async {
  var response = dio.get('/content/partition/getall');
  return response;
}


//获取code防止重复提交
Future getUploadCode() async {
  var response = dio.get('/content/video/getuploadcode');
  return response;
}

//上传视频
Future uploadVideo(Map<String,dynamic> data) async {
  var formdata = FormData.fromMap(data);
  var response = dio.post('/content/video/upload',data: formdata);
  return response;
}


//提交视频信息表单
Future submitVideoInfoForm(Map<String,dynamic> data) async {
  var formdata = FormData.fromMap(data);
  var response = dio.post('/content/video/submit_videoInfo_form',data: formdata);
  return response;
}


//获取推荐
Future getLatestRecommend(int page) async {

  var response = dio.get('/content/recommend/latest',queryParameters: {
    "page":page
  });
  return response;
}


Future getPlayUrl(String videoId) async {
  var response = dio.get('/content/video_info/get_playurl',queryParameters: {
    "videoId":videoId
  });
  return response;
}


Future getVideoAuthorInfo(String authorId) async {
  var response = dio.get('/content/video_info/get_authorInfo',queryParameters: {
    "authorId":authorId
  });
  return response;
}



