import 'dart:ffi';

import 'package:dili_video/component/number_formater.dart';
import 'package:flutter/material.dart';

class LikeAction extends StatefulWidget {
   const LikeAction({super.key, this.size = 18, required this.like, this.likeAction, this.disLikeAction, required this.likeCount});

  final double? size;

  final bool like;
  
  final Function? likeAction;

  final Function? disLikeAction;

  final int likeCount;


  @override
  State<LikeAction> createState() => _LikeActionState();
}

class _LikeActionState extends State<LikeAction> {
  
  bool _like = false;

  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _like = widget.like;
    _likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _like
        ? GestureDetector(
            onTap: () {
              setState(() {
                _like = !_like;
                widget.disLikeAction?.call();
                _likeCount--;
              });
            },
            child: Icon(
              Icons.thumb_up_rounded,
              size: widget.size,
              color: Colors.pink,
            ))
        : GestureDetector(
            onTap: () {
              setState(() {
                _like = !_like;
                widget.likeAction?.call();
                _likeCount++;
              });
            },
            child: Icon(Icons.thumb_up_rounded, size: widget.size)),
            const SizedBox(width: 5,),
            SizedBox(width: 50,child: NumberConverter(number: _likeCount),)
      ],
    );
  }
}



class HateAction extends StatefulWidget {
   const HateAction({super.key, this.size = 18, required this.hate, this.hateAction, this.disHateAction});

  final double? size;

  final bool hate;
  
  final Function? hateAction;

  final Function? disHateAction;


  @override
  State<HateAction> createState() => _HateActionState();
}

class _HateActionState extends State<HateAction> {
  
  bool _hate = false;


  @override
  void initState() {
    super.initState();
    _hate = widget.hate;
  }

  @override
  Widget build(BuildContext context) {
    return _hate
        ? GestureDetector(
            onTap: () {
              setState(() {
                _hate = !_hate;
                widget.disHateAction?.call();
              });
            },
            child: Icon(
              Icons.thumb_down_alt_rounded,
              size: widget.size,
              color: Colors.pink,
            ))
        : GestureDetector(
            onTap: () {
              setState(() {
                _hate = !_hate;
                widget.hateAction?.call();
              });
            },
            child: Icon(Icons.thumb_down_alt_rounded, size: widget.size));
  }
}