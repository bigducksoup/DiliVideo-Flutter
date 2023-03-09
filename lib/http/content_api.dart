import 'package:dio/dio.dart';

import 'dio_manager.dart';


Future getAllPartition() async {
  var response = dio.get('/content/partition/getall');
  return response;
}



Future getUploadCode() async {
  var response = dio.get('/content/video/getuploadcode');
  return response;
}


Future uploadVideo(Map<String,dynamic> data) async {
  var formdata = FormData.fromMap(data);
  var response = dio.post('/content/video/upload',data: formdata);
  return response;
}

Future submitVideoInfoForm(Map<String,dynamic> data) async {
  var formdata = FormData.fromMap(data);
  var response = dio.post('/content/video/submit_videoInfo_form',data: formdata);
  return response;
}


