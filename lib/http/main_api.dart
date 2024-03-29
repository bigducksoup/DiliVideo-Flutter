import 'dart:io';

import 'package:dio/dio.dart';

import 'dio_manager.dart';

Future sendComment(String content, String videoInfoId) async {
  var response = dio.post('/main/comment/replyToVideo',
      data: {"content": content, "videoInfoId": videoInfoId});
  return response;
}

Future replyComment(String content, String fatherCommentId, String replyToId,
    {int ifDirect = 1}) async {
  var response = dio.post('/main/comment/replyToComment', data: {
    "content": content,
    "fatherId": fatherCommentId,
    "replyToId": replyToId,
    "ifDirect": ifDirect
  });
  return response;
}

Future getComment(int page, int mode, String videoInfoId) async {
  var response = dio.get('/main/comment/comment_item', queryParameters: {
    "videoInfoId": videoInfoId,
    "mode": mode,
    "page": page
  });
  return response;
}

Future getReply(String fatherCommentId) async {
  var response = dio.get('/main/comment/comment_reply',
      queryParameters: {"fatherCommentId": fatherCommentId});
  return response;
}

Future getPostsByUserId(String userId, int page, {bool? video_only}) async {
  var response = dio.get('/main/post_query/query_by_userId',
      queryParameters: {"userId": userId, "page": page ,"video_only":video_only ?? false});
  return response;
}

Future getTopicList(int page) {
  var response =
      dio.get('/main/post_topic/topic_list', queryParameters: {"page": page});
  return response;
}

Future postText(Map<String, dynamic> postForm) async {
  List<MultipartFile> files = [];

  for (File f in (postForm['files'] as List)) {
    files.add(await MultipartFile.fromFile(f.path));
  }

  postForm['files'] = files;

  var response = dio.post('/main/post/text', data: FormData.fromMap(postForm));
  return response;
}


//获取动态评论
Future getPostComment(int page, String postId, {bool orderByTime = false}) {
  var response = dio.get('/main/post_comment/get_comments', queryParameters: {
    "page": page,
    "pageSize": 20,
    "postId": postId,
    "orderByTime": orderByTime
  });
  return response;
}


Future getPostCommentReply(int page,String commentId,{int pageSize=20,bool orderByTime = false,CancelToken? cancelToken}){
  return dio.get('/main/post_comment/get_comment_reply',queryParameters: {
    "page":page,
    "pageSize":pageSize,
    "commentId":commentId,
    "orderByTime":orderByTime
  },cancelToken: cancelToken);
}



//like action for post,post comment and VideoComment
Future likeAction(int type, String id) async {
  var response = dio.post('/main/action/like', data: {"targetType": type, "targetId": id});
  return response;
}



//reply to a post
Future replyToPost(String postId,String content){
  var response = dio.post('/main/post_comment/reply_to_post',data: {
    "content":content,
    "postId":postId
  });

  return response;
}

//reply to a comment below post
Future replyToPostComment(String fatherId,String replyToId,String postId,String content){
  var response = dio.post('/main/post_comment/reply_to_post_comment',data: {
    "fatherId":fatherId,
    "replyToId":replyToId,
    "content":content,
    "postId":postId
  });

  return response;

}




Future getPostInfoById (String postId) async {
  var response = dio.get('/main/post_query/query_by_id', queryParameters: {
    "postId": postId
  });
  return response;

}




Future getPostByFollows(int page,int pageSize,{bool? video_only,CancelToken? cancelToken}){

  var response = dio.get('/main/post_query/query_by_follow',queryParameters: {
    "page":page,
    "pageSize":pageSize,
    "video_only": video_only?? false
  });

  return response;

}