import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dili_video/http/auth_api.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //register form
  Map<String, dynamic> registerForm = {
    "password": "",
    "nickname": "",
    "code": "",
    "avatarCode": "",
    "gender": 0
  };

  //input decoration
  final OutlineInputBorder _inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.pink));

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //count down
  int timeLimit = 60;
  //if show sendCode button
  bool showButton = true;
  //email controller
  final TextEditingController emailController = TextEditingController();
  //password
  final TextEditingController passwordController = TextEditingController();

  void setAvatarCode(String avatarCode) {
    print(avatarCode);
    registerForm['avatarCode'] = avatarCode;
  }

  void sendVerifyCode(String email) async {
    setState(() {
      timeLimit = 60;
      //设置按钮不可点击
      showButton = false;
    });

    var t = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLimit == 0) {
        timer.cancel();
        setState(() {
          showButton = true;
        });
      }
      //timer set countDown
      setState(() {
        timeLimit = timeLimit - 1;
      });
    });

    //send getCode request
    var response = await sendVerifyCodeByEmail(email);
    var res = jsonDecode(response.toString());
    if (res['data'] != true) {
      TextToast.showToast(res['msg']);
      t.cancel();
      setState(() {
        showButton = true;
      });
      return;
    }
  }

  //submit register from
  submit() async {
    var response = await submitRegForm(registerForm);
    var res = jsonDecode(response.toString());

    if (res['data']) {
      Get.back();
    } else {
      TextToast.showToast(res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maindarkcolor,
      appBar: AppBar(
        title: const Text("用户注册"),
        elevation: 0,
        backgroundColor: maindarkcolor,
      ),
      body: Column(
        children: [
          Center(
              child: AvatarPicker(
            setAvatarCode: setAvatarCode,
          )),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: _inputBorder,
                          labelText: "邮箱",
                          labelStyle: const TextStyle(color: Colors.white),
                          contentPadding: const EdgeInsets.all(8),
                          suffixIcon: Container(
                              width: 60,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10))),
                              child: showButton
                                  ? ElevatedButton(
                                      onPressed: () {
                                        String email = emailController.text;
                                        if (!email.endsWith(".com")) {
                                          TextToast.showToast("请输入正确的邮箱");
                                          return;
                                        }
                                        sendVerifyCode(email);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.pink.shade300)),
                                      child: const Text("发送"),
                                    )
                                  : Center(child: Text("$timeLimit"))),
                          focusedBorder: _inputBorder),
                      validator: (value) {
                        if (value == null) {
                          return "请输入内容";
                        }
                        if (!value.endsWith(".com") || !value.isEmail) {
                          return "请输入正确的邮箱";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        border: _inputBorder,
                        labelText: "验证码",
                        contentPadding: const EdgeInsets.all(8),
                        focusedBorder: _inputBorder,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if(value==null){
                          return "请输入内容";
                        }
                        if(value.length!=6){
                          return "验证码格式错误";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        registerForm['code'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: _inputBorder,
                        labelText: "昵称",
                        contentPadding: const EdgeInsets.all(8),
                        focusedBorder: _inputBorder,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if(value==null){
                          return "请输入内容";
                        }
                        if(value.isEmpty || value.length > 15){
                          return "昵称长度在1-15个字符之间";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        registerForm['nickname'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: _inputBorder,
                        labelText: "密码",
                        contentPadding: const EdgeInsets.all(8),
                        focusedBorder: _inputBorder,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "请输入内容";
                        }
                        if (value.length < 10) {
                          return "请输入安全性较高的密码";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        registerForm['password'] = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: _inputBorder,
                        labelText: "确认密码",
                        contentPadding: const EdgeInsets.all(8),
                        focusedBorder: _inputBorder,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                      validator: (value) {
                         if (value == null) {
                          return "请输入内容";
                        }
                        if(value != passwordController.text ){
                          return "确认密码应与密码一至";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    
                    SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              print(registerForm);
                              if(_formKey.currentState!.validate()){
                                submit();
                              }
                            }, child: const Text("注册")))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({super.key, required this.setAvatarCode});

  final Function(String avatarCode) setAvatarCode;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  final ImagePicker _imagePicker = ImagePicker();

  //image_picker 选取的头像图片文件
  XFile? avatar;

  //设置头像
  selectImage() async {
    //pick avatar img
    XFile? pickedAvatar = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (pickedAvatar != null) {
      avatar = pickedAvatar;
      setState(() {});
      File f = File(avatar!.path);
      var response = await upLoadRegAvatar(f);
      var res = jsonDecode(response.toString());
      if (res['code'] != 200) {
        TextToast.showToast(res['msg']);
        return;
      }
      print(res);
      widget.setAvatarCode(res['data']);
      f.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await selectImage();
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.pink.shade300),
        clipBehavior: Clip.hardEdge,
        child: avatar == null
            ? const Center(
                child: Text("选择图片"),
              )
            : Image.asset(
                avatar!.path,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
