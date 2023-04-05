
import 'dio_manager.dart';



Future sendComment(String content,String videoInfoId) async {
  var response = dio.post('/main/comment/replyToVideo',data: {
    "content":content,
    "videoInfoId":videoInfoId
  });
  return response;
}


//获取所有分区
Future getComment(int page,int mode,String videoInfoId) async {
  var response = dio.get('/main/comment/comment_item',queryParameters: {
    "videoInfoId":videoInfoId,
    "mode":mode,
    "page":page
  });
  return response;
}



Future getReply(String fatherCommentId) async {
  var response = dio.get('/main/comment/comment_reply',queryParameters: {
    "fatherCommentId":fatherCommentId
  });
  return response;
}