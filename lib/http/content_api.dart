import 'dart:convert';

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


//上传分片
Future uploadVideoChunk(Map<String,dynamic> data) async {
    ///data:
  /// String code
  /// MultipartFile file
  /// Integer index
  /// Integer totalChunkCount
  /// String fileName
  var formdata = FormData.fromMap(data);
  var response = dio.post('/content/video/upload_chunk',data: formdata);
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

//获取热门视频
Future getHotVideos(int page) async {
  var response = dio.get('/content/recommend/hot',queryParameters: {
    "page":page
  });
  return response;
}

//获取播放链接
Future getPlayUrl(String videoId) async {
  var response = dio.get('/content/video_info/get_playurl',queryParameters: {
    "videoId":videoId
  });
  return response;
}

//获取视频作者信息
Future getVideoAuthorInfo(String authorId) async {
  var response = dio.get('/content/video_info/get_authorInfo',queryParameters: {
    "authorId":authorId
  });
  return response;
}



//获取稿件
Future getUploadedVideos(int page) async {
  var response = dio.get('/content/video/published_videos',queryParameters: {
    "page":page
  });
  return response;
}

//删除稿件
Future deleteVideo(String videoInfoid) async {
  var response = dio.post(
    '/content/video/delete',
    data: {
      "videoInfoId":videoInfoid
    }
  );
  return response;
}

Future updateVideoInfo(Map form)async{
  var response = dio.post(
    '/content/video/update_info',
    data: form
  );

  return response;
}


Future getVideoInfoById(String videoInfoId)async{
  var response = dio.get(
    '/content/video_info/get_videoInfo_byId',
    queryParameters: {
      "videoInfoId":videoInfoId
    }
  );

  return response;
}



Future getUserPublishedVideos(String id,int page)async{
    var response = dio.get(
    '/content/user_videos/published',
    queryParameters: {
      "userId":id,
      "page":page
    }
  );

  return response;
}


Future checkLikeVideo(String videoInfoId){

  var response = dio.get("/content/like/check",queryParameters: {
    "videoInfoId":videoInfoId
  });

  return response;

}


Future likeVideo(String videoInfoId){
  var response = dio.post("/content/like/like_video",data: {
    "videoInfoId":videoInfoId
  });

  return response;
}


Future unlikeVideo(String videoInfoId){
  var response = dio.post("/content/like/unlike_video",data: {
    "videoInfoId":videoInfoId
  });

  return response;
}


Future getVideoVosByIds(List<String> ids){
  var response = dio.get("/content/video_info/get_videoInfo_byIdList",data: jsonEncode(ids));
  return response;
}