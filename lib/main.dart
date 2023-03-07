
import 'dart:convert';

import 'package:dili_video/publish.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import './views/home.dart';
import './views/activity.dart';
import './views//mine.dart';
import './login_page.dart';

import 'assets/assets.dart';
import 'http/auth_api.dart';
import 'http/dio_manager.dart';

void main() {

  initDio();
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.

  return runApp(GetMaterialApp(
    initialRoute: "/indexPage",
    getPages: [
      GetPage(name: '/indexPage', page: () => IndexPage()),
      GetPage(
          name: '/login', page: () => Login(), transition: Transition.fadeIn),
      GetPage(name: '/publish',page: ()=>PublishPage())
    ],
    
  ));
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _currentIndex = 0;




  List<Widget> views = [];



    checktoken() async {
    var token = await LocalStorge.getValue("token", "".runtimeType);
    if (token != null) {
      var res = await checklogin();
      
      var response = jsonDecode(res.toString());

      if (response['code'] == 200) {
        Map<String, dynamic> authmap = response['data'];
        auth_state.init(authmap);
      }else{
        Get.toNamed('/login');
      }
    }
  }

  @override
  void initState() {
     checktoken();
    // TODO: implement initState
    views.add(Home());
    views.add(Activity());
    views.add(Mine());

    super.initState();
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
          body: views[_currentIndex],
          bottomNavigationBar: Theme(
            data: ThemeData(
              brightness: Brightness.light,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.black87,
              selectedItemColor: Colors.pink,
              unselectedItemColor: Colors.white,
              currentIndex: _currentIndex,
              items:  [
                const BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.wind_power), label: "动态"),
                BottomNavigationBarItem(icon: whitetvIcon, label: "我的",activeIcon: pinktvIcon),
              ],
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ));
  }
}
