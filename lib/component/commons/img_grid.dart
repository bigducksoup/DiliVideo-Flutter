
import 'package:flutter/material.dart';

class ImgRowList extends StatelessWidget {
  ImgRowList({super.key, required this.width, required this.urls});
  final double width;

  double _imgMaxWidth = 120;

  final List urls;

  @override
  Widget build(BuildContext context) {
    if (width / 3 - 12 < _imgMaxWidth) {
      _imgMaxWidth = width / 3 - 12;
    }

    return Wrap(
      children: [for (int i = 0; i < urls.length; i++) _buildImg(urls[i])],
    );
  }

  Widget _buildImg(String url) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 0.3,color: Colors.grey)),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            url,
            width: _imgMaxWidth,
            height: _imgMaxWidth,
            fit: BoxFit.cover,
          )),
    );
  }
}