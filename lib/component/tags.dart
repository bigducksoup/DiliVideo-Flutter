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