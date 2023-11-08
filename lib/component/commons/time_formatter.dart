import 'package:dili_video/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


///
///将日期时间转化为
///今天 昨天 几小时内 日期
///

class TimeFormat extends StatelessWidget {
  const TimeFormat({super.key, required this.time});


  final String time;




  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



class TimeComparisonScreen extends StatelessWidget {
  final String dateTimeString;

  final double? fontSize;

  const TimeComparisonScreen({super.key, required this.dateTimeString,this.fontSize});


  @override
  Widget build(BuildContext context) {


    String res =  relativeTime(dateTimeString);

    return Text(res,style: TextStyle(fontSize: fontSize??15),);
  }
}
