import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../assets/assets.dart';

class BottomOptions extends StatelessWidget {
  const BottomOptions({super.key});

  static final List<Widget> _icons = [
    customerServiceIcon,
    settingIcon,
    writingIcon
  ];

  static final List<String> descriptions = ['客服', '设置', '稿件管理'];

  List<Widget> buildRows() {
    List<Widget> rows = [];

    for (int i = 0; i < _icons.length; i++) {
      var r = Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: GestureDetector(
          onTap: () {
            if(descriptions[i]=="稿件管理"){
              Get.toNamed('/video_manager');
            }else if(descriptions[i]=="设置"){
              Get.toNamed('/setting');
            }
          },
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              _icons[i],
              const SizedBox(width: 15,),
              Text(
                descriptions[i],
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
               Expanded(child: ConstrainedBox(
                 constraints: const BoxConstraints.tightFor(height: 30),
                 child: Container(color: Colors.transparent,),
                 )),
              const Icon(Icons.arrow_circle_right_outlined,color: Colors.white,),
              const SizedBox(width: 15,)
            ],
          ),
        ),
      );

      rows.add(r);
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildRows(),
    );
  }
}
