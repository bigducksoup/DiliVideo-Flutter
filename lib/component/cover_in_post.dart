import 'package:flutter/material.dart';

class CoverInPost extends StatelessWidget {
  const CoverInPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                image: NetworkImage(
                    "http://127.0.0.1:9000/img/wallhaven-m3pex1.png"),
                fit: BoxFit.cover)));
  }
}
