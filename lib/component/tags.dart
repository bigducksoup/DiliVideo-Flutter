import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';




class VIPTag extends StatelessWidget {
  const VIPTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                      height: 20,
                      width: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.pink, width: 1),
                          borderRadius: BorderRadius.circular(2)),
                      child: const Center(
                          child: Text(
                        "正式会员",
                        style: TextStyle(
                            color: Colors.pink,
                            fontSize: 11,
                            fontWeight: FontWeight.w700),
                      )),
                    );
  }
}





class IconAndTextTag extends StatelessWidget {
  const IconAndTextTag({super.key, this.icon, required this.text});

  final IconData? icon;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon!=null? Icon(icon,weight: 8,size: 15,color: thinTextColor,):const SizedBox(),
        icon!=null?const SizedBox(width: 10,):const SizedBox(),
        Text(text,style: TextStyle(fontWeight: FontWeight.w500,color: thinTextColor,fontSize: 13),)
      ],
    );
  }
}