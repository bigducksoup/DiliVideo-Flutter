import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
        backgroundColor: maindarkcolor,
      ),
      body: Center(
        child: ElevatedButton(onPressed: ()async{
          var res = await LocalStorge.remove("token");
          print(res);

          Get.offAllNamed('/login');

        }, child: Text("退出登录"),style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red)
        ),),
      ),
    );
  }
}