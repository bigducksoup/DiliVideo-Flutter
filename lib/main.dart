import 'dart:convert';

import 'package:dili_video/pages/publish/publish.dart';
import 'package:dili_video/pages/register/register.dart';
import 'package:dili_video/pages/setting/setting_page.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/pages/user_page/user_page.dart';
import 'package:dili_video/utils/shared_preference.dart';
import 'package:dili_video/pages/video_manage/videoItem_manage_page.dart';
import 'package:dili_video/pages/video_fullscreen/video_fulllscreen_page.dart';
import 'package:dili_video/pages/video_history/video_history.dart';
import 'package:dili_video/pages/video_manage/video_manager.dart';
import 'package:dili_video/pages/video_page/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import './views/activity/activity.dart';
import 'views/home/home.dart';

import 'views/mine/mine.dart';
import 'pages/login/login_page.dart';

import 'assets/assets.dart';
import 'controller/index_page_controller.dart';
import 'http/auth_api.dart';
import 'http/dio_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  initDio();
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //设置为竖屏
      .then((_) {
    runApp(GetMaterialApp(
      theme: ThemeData.dark(),
    initialRoute: "/indexPage",
    getPages: [
      GetPage(name: '/indexPage', page: () => const IndexPage()),
      GetPage(name: '/login', page: () => const Login()),
      GetPage(name: '/publish', page: () => const PublishPage()),
      GetPage(name: '/video', page: ()=>const VideoPage()),
      GetPage(name: '/video_manager', page: ()=>const VideoManager()),
      GetPage(name: '/videoItem_manage', page: ()=>const VideoItemManage()),
      GetPage(name: '/user_info', page: ()=>const UserPage()),
      GetPage(name: '/setting', page: ()=>const SettingPage()),
      GetPage(name: '/register', page: ()=>const RegisterPage()),
      GetPage(name: '/video_history', page: ()=> const VideoHistoryPage())
    ],
  ));
  });
  
  
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
   

   final controller = Get.put(IndexController());

  List<Widget> views = [];

  ///检查token的合法性，
  ///合法进入首页，
  ///不合法跳转登录页
  checktoken() async {
    var token = await LocalStorge.getValue("token", "".runtimeType);
    if (token != null) {
      var res = await checklogin();

      var response = jsonDecode(res.toString());

      if (response['code'] == 200) {
        Map<String, dynamic> authmap = response['data'];
        auth_state.init(authmap);
      } else {
        Get.offAllNamed('/login');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void initState() {
     checktoken();
    super.initState();
        views.add(const Home());
    views.add(const Activity());
    views.add(const Mine());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF18181a),
          ),
        ),
        home: Scaffold(
          body: Obx(() => IndexedStack(index: controller.currentIndex.value,children: views,)),
          bottomNavigationBar: Theme(
            data: ThemeData(
              brightness: Brightness.light,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Obx(() => BottomNavigationBar(
                  backgroundColor: Colors.black87,
                  selectedItemColor: Colors.pink,
                  unselectedItemColor: Colors.white,
                  currentIndex: controller.currentIndex.value,
                  items: [
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "首页"),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.wind_power), label: "动态"),
                    BottomNavigationBarItem(
                        icon: whitetvIcon, label: "我的", activeIcon: pinktvIcon),
                  ],
                  onTap: (int index) {
                    controller.currentIndex.value = index;
                  },
                )),
          ),
        ));
  }
}
