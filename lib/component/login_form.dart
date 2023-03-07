import 'dart:convert';


import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/utils/loading_dialog_util.dart';
import 'package:dili_video/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../http/auth_api.dart';
import '../http/ResponseResult.dart';

GlobalKey<_LoginFormState> globalKey = GlobalKey();

class LoginForm extends StatefulWidget {
  LoginForm({required Key key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '969690525@qq.com';
  String password = 'Yjh969690525';

  InputDecoration getDecoration(String content) {
    return InputDecoration(
        border: InputBorder.none,
        prefixIcon: SizedBox(
          width: 80,
          child: Center(
            child: Text(content),
          ),
        ));
  }

  void login() async {
    _formKey.currentState!.save();

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    var res = await loginbyemail(email, password, timestamp, "127.0.0.1");
    Map<String, dynamic> response = jsonDecode(res.toString());
    if (response['code'] == 200) {
      //用户信息
      Map<String, dynamic> authmap = response['data'];

      //保存到state
      auth_state.init(authmap);

      //保存token
      

      LocalStorge.setValue("token", auth_state.authToken.value);
      
      LoadingDialogHelper.dismissLoading(context);
      Get.toNamed("/indexPage");
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              cursorWidth: 2,
              cursorColor: Colors.white,
              style: const TextStyle(fontSize: 20),
              decoration: getDecoration("账号"),
              onSaved: (newValue) {

                email = newValue!;
              },
            ),
            TextFormField(
              obscureText: true,
              cursorWidth: 2,
              cursorColor: Colors.white,
              style: const TextStyle(fontSize: 20),
              decoration: getDecoration("密码"),
              onSaved: (newValue) {
                password = newValue!;
              },
            )
          ],
        ));
  }
}
