


import 'package:dili_video/component/time_formatter.dart';



import 'package:intl/intl.dart';

// 定义一个将ISO 8601格式的日期时间字符串转换为相对时间字符串的函数
String relativeTime(String isoString) {
  // 解析ISO 8601格式的字符串，获取DateTime对象
  DateTime input = DateTime.parse(isoString);
  // 获取当前的日期时间，并根据输入字符串的时区进行调整
  DateTime now = DateTime.now().toUtc().add(input.timeZoneOffset);
  // 计算输入字符串和当前日期时间之间的差值
  Duration diff = now.difference(input);
  // 根据差值的大小，选择合适的相对时间单位
  if (diff.inHours < 24) {
    // 如果差值小于24小时，返回"x小时前"
    return "${diff.inHours}小时前";
  } else if (diff.inDays < 30) {
    // 如果差值小于365天，返回"x天前"
    return "${diff.inDays}天前";
  } else {
    // 如果差值大于等于365天，返回"yyyy-MM-dd"格式的字符串
    return DateFormat("yyyy-MM-dd").format(input);
  }
}
