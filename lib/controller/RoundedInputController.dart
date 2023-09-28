
import 'package:flutter/material.dart';

class RoundedInputController{


  late TextEditingController textEditingController;

  late FocusNode focusNode;

  RoundedInputController(){
    textEditingController = TextEditingController();
    focusNode = FocusNode();
  }

  void dispose(){
    textEditingController.dispose();
    focusNode.dispose();
  }


  void focus(){
    focusNode.requestFocus();
  }

  void unfocus(){
    focusNode.unfocus();
  }

  void clearText(){
    textEditingController.clear();
  }


  void setText(String text){
    textEditingController.text = text;
  }

}