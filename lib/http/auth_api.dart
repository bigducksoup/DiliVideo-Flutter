

import 'dart:io';

import 'package:dio/dio.dart';

import 'dio_manager.dart';

Future loginbyemail(String email, String password, int timestamp, String ip) async {
  var response = dio.post('/auth/login/login_by_email', data: {
    "email": email,
    "password": password,
    "ip": ip,
    "timestamp": timestamp
  });
  return response;
}


Future checklogin() async {
  var response = dio.get('/auth/login/check_login');
  return response;
}


Future getBasicUserInfo(id){

   var response = dio.get('/auth/user_info/basic',queryParameters: {
     "userId":id
   });

   return response;

}


Future follow(String followId){

  var response = dio.post('/auth/relation/follow',data: {
    "followId":followId
  });

  return response;

}

Future unfollow(String followId){

  var response = dio.post('/auth/relation/unfollow',data: {
    "followId":followId
  });

  return response;

}

Future checkFollow(String followId){

  var response = dio.get('/auth/relation/check_follow',queryParameters: {
    "followId":followId
  });

  return response;

}


Future sendVerifyCodeByEmail(String email){
  var response = dio.get('/auth/register/get_code_by_email',queryParameters: {
    "email":email
  });

  return response;
}


Future upLoadRegAvatar(File avatar)async{

  Map<String,dynamic> form = {
    "file": null
  };

  form['file'] = await MultipartFile.fromFile(avatar.path);


  FormData formData = FormData.fromMap(form);


  var response = dio.post('/auth/register/upload_avatar',data:formData );

  return response;
}


Future submitRegForm(Map<String,dynamic> form){

  var response = dio.post('/auth/register/submit_form',data:form );

  return response;
}