import 'dart:convert';

import 'package:dili_video/danmu_player/barrage_controller.dart';
import 'package:dili_video/http/barrage_api.dart';
import 'package:dili_video/http/params/sendBarrageParams.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/success_fail_dialog_util.dart';



class SendBarrage extends StatefulWidget {
  const SendBarrage({super.key, required this.width, required this.videoInfoId});
    final double width;
    final String videoInfoId;

  @override
  State<SendBarrage> createState() => _SendBarrageState();
}

class _SendBarrageState extends State<SendBarrage> {


    var barrageController = Get.find<BarrageController>();

    

    TextEditingController textEditingController = TextEditingController();


    @override
  Widget build(BuildContext context) {
    return Container(
                      padding: const EdgeInsets.all(4),
                      width: 0.5 * widget.width,
                      height: 55,
                      child: Center(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purple.shade200),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                 Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    controller: textEditingController,
                                    scrollPadding: const EdgeInsets.all(2),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.pink,
                                    maxLines: 1,
                                  ),
                                ),
                                //发送按钮
                                GestureDetector(
                                  onTap: () async {
                                    if(textEditingController.text.isEmpty)return;

                                    var param =  BarrageParam(content: textEditingController.text, color: 1, seconds: 1, videoInfoId: widget.videoInfoId, ifMid: 0);

                                    var response =  await sendBarrage(param);

                                    barrageController.addToChannel(1,textEditingController.text);

                                    var res =  jsonDecode(response.toString());
                                    
                                    if(res['code']==200){
                                      textEditingController.text = "";
                                      // ignore: use_build_context_synchronously
                                      TextToast.showToast(res['msg']);
                                    }

                                    
                                    
                                  },
                                  child: Container(
                                    width: 0.08*widget.width,
                                    height: 0.08*widget.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.pink.shade300,
                                    ),
                                    child: const Center(child: Text("弹",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                    ),)),
                                  ),
                                )
                              ],
                            )),
                      ));
  }
}