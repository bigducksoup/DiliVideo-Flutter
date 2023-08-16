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
    TextStyle timeStyle =  TextStyle(color: Colors.white54,fontSize: fontSize ?? 14);
    DateTime currentDateTime = DateTime.now();
    DateTime parsedDateTime = DateTime.parse(dateTimeString);
    Duration difference = currentDateTime.difference(parsedDateTime);

    if (difference.inMinutes.abs() < 60) {
      // 不到一小时前
      return Text('${difference.inMinutes}分钟前',style: timeStyle,);
    } else if (difference.inHours < 24 && currentDateTime.day == parsedDateTime.day) {
      // 今天内的时间
      DateFormat format = DateFormat.Hm(); // 显示小时和分钟
      String formattedTime = format.format(parsedDateTime);
      return Text('今天 $formattedTime',style: timeStyle,);
    } else if (difference.inHours < 48 && currentDateTime.day - parsedDateTime.day == 1) {
      // 昨天的时间
      DateFormat format = DateFormat.Hm(); // 显示小时和分钟
      String formattedTime = format.format(parsedDateTime);
      return Text('昨天 $formattedTime',style: timeStyle,);
    } else {
      // 其他日期
      DateFormat format = DateFormat.yMd(); // 显示年月日
      String formattedDate = format.format(parsedDateTime);
      return Text(formattedDate,style: timeStyle,);
    }
  }
}
