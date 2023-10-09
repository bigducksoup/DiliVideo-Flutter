



import 'dart:convert';

import 'package:dili_video/utils/success_fail_dialog_util.dart';

 Map<String,dynamic> handleResponse(dynamic response){

  var res =  jsonDecode(response.toString());

  if(res['code']!=200){
    TextToast.showToast(res['msg']);
    throw Exception();
  }

  return res;

}



