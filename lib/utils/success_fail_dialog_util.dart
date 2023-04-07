import 'package:flutter/material.dart';
import 'package:get/get.dart';





class TextToast{


  static void showToast(String msg){
        Get.dialog(
      Center(
        child: Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.pink.shade300,
            borderRadius: BorderRadius.circular(10)
          ),
          child:
            Center(child: Text(msg,style: const TextStyle(decoration: TextDecoration.none,color: Colors.white,fontSize: 15),),),
        ),
      )
    );
  }


}