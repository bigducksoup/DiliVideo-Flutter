


import 'dart:convert';

import 'package:dili_video/http/auth_api.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';

Future<bool> followUp(followId)async{
  
  var response =  await follow(followId);

  var res = jsonDecode(response.toString());


  if(res['data']==false){
    TextToast.showToast(res['msg']);
    return false;
  }else{
    return true;
  }

}



Future<bool> unfollowUp(followId)async{
    var response =  await unfollow(followId);

  var res = jsonDecode(response.toString());


  if(res['data']==false){
    TextToast.showToast(res['msg']);
    return false;
  }else{
    return true;
  }
}