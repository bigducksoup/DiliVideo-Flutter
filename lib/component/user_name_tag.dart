import 'package:dili_video/component/tags.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


///
/// 显示nickname和后面携带的标签图标等
/// 常用于评论 用户头像后
///


class NickNameTag extends StatelessWidget {
  const NickNameTag(
      {super.key,
      required this.level,
      required this.name,
      required this.ifUp,
      required this.ifVIP,
      this.onTouchName,
      required this.userId});

  final Widget space = const SizedBox(width: 5);

  final int level;

  final String name;

  final bool ifUp;

  final bool ifVIP;

  final String userId;

  final Function(String name, String userId)? onTouchName;

  Widget _buildName(String name, bool ifVIP) {
    TextStyle textStyle =
        TextStyle(color: ifVIP ? Colors.pink : Colors.white,fontSize: 15);
    return Text(
      name,
      style: textStyle,
    );
  }

  Widget _buildLevel(int level) {
    double size = 23;

    Color color = Colors.pink.shade500;

    List levelIcons = [
      Icon(Icons.square, size: size, color: color),
      Icon(Icons.one_k_outlined, size: size, color: color),
      Icon(Icons.two_k_outlined, size: size, color: color),
      Icon(Icons.three_k_outlined, size: size, color: color),
      Icon(Icons.four_k_outlined, size: size, color: color),
      Icon(Icons.five_k_outlined, size: size, color: color),
      Icon(Icons.six_k_outlined, size: size, color: color)
    ];

    return levelIcons[level];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(onTap: (){
          onTouchName?.call(name,userId);
        },child: _buildName(name, ifVIP)),
        space,
        _buildLevel(level),
        space,
        if(ifUp)const FaIcon(FontAwesomeIcons.user,size: 16,color: Colors.pink),
      ],
    );
  }
}







class NickName extends StatelessWidget {
  const NickName({super.key, this.size = 20, required this.name, this.color = Colors.white});

  final double? size;

  final String name;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(name,style: TextStyle(fontSize: size,color: color,fontWeight: FontWeight.w400));
  }
}



class FansCount extends StatelessWidget {
  const FansCount({super.key, required this.fanscount, this.size = 20, this.color = Colors.white});

  final int fanscount;

  final double? size;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconAndTextTag(text: "${handleFansCount(fanscount)}粉丝");
  }


  String handleFansCount(int count){
    if(count>=10000){
      return '${(count/10000).toStringAsFixed(1)}万';
    }
    return count.toString();
  }

}