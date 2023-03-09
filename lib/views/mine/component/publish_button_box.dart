import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../assets/assets.dart';
import '../../../theme/colors.dart';



class PublishButtonBox extends StatelessWidget {
  const PublishButtonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return           Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 65,
            decoration: BoxDecoration(
                color: littlepink, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                videoIcon,
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  "点击发布新的视频",
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/publish');
                  },
                  style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size(90, 40)),
                    backgroundColor:
                        MaterialStatePropertyAll(Color(0xfff46c98)),
                  ),
                  child: const Text("发布"),
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
          );
  }
}