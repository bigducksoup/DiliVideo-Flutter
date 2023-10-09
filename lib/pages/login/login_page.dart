
import 'package:dili_video/component/login_form.dart';


import 'package:dili_video/utils/loading_dialog_util.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final _textStyle = const TextStyle(color: Colors.white, fontSize: 20);



  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Get.toNamed("/indexPage");
        },child: const Icon(Icons.refresh),),
        appBar: AppBar(
          title: const Text("账号密码登录"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://i0.hdslb.com/bfs/archive/a349e5844a068d9767d699ab4fdbaa16030af585.png",
                  width: 150,
                  height: 72,
                )
              ],
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(), bottom: BorderSide())),
              child: LoginForm(
                key: globalKey,
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(170, 45),
                    maximumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF424242),
                  ),
                  child: const Text("注册"),
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    globalKey.currentState?.login();
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(170, 45),
                      maximumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.pink,
                      textStyle: const TextStyle(fontSize: 16)),
                  child: const Text("登录"),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
