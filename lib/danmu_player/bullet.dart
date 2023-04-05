import 'package:flutter/material.dart';

class Bullet{

  double right;

  String content;

  UniqueKey key;

  double offsetX = 1000;

  double targerX = -200;

  double screenWidth;

  int speed;

  bool status = true;

  int seconds;

  




  void moveOneFrame(){
    if(offsetX>targerX){
      // print(offsetX);
      offsetX-=2*speed;
    }else{
      status = false;
    }
  }


  Bullet( { required this.content,required this.key,required this.right, this.speed = 1,required this.seconds,required this.screenWidth}){
      offsetX = screenWidth + 100;
      targerX = 0 - 100;
  }


}