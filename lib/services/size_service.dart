

import 'package:flutter/material.dart';

class SizeUtil{


  static double getCurrentWidth(BuildContext context){
      return MediaQuery.of(context).size.width;
  }

  static double getCurrentHeight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }


}