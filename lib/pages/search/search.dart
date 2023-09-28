import 'package:dili_video/component/RoundedInput.dart';
import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top: 30,),
          child: Column(
        children: [
          SearchTop(),
          Expanded(
              child: Container(
            color: maindarkcolor,
          ))
        ],
      )),
    );
  }
}

class SearchTop extends StatefulWidget {
  const SearchTop({super.key});

  @override
  State<SearchTop> createState() => _SearchTopState();
}

class _SearchTopState extends State<SearchTop> {
  late RoundedInputController roundedInputController;

  @override
  void initState() {
    super.initState();
    roundedInputController = RoundedInputController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 70,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(onTap: () => Get.back(),child:  Icon(Icons.arrow_back_ios,color: Colors.pink.shade400,))),
            Expanded(
              child: Container(
                  width: double.infinity,
                  height: 55,
                  child: RoundedInput(
                    roundedInputController: roundedInputController,
                    hintText: "搜索",
                    borderColor: Colors.pink.shade400,
                    textColor: Colors.white,
                    fillColor: Colors.black54,
                    btnIcon: Icons.search,
                    iconColor: Colors.pink.shade400,
                  )),
            ),
          ],
        ));
  }
}
