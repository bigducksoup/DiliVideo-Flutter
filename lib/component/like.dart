import 'package:dili_video/component/commons/number_formater.dart';
import 'package:flutter/material.dart';

///
///The LikeAction widget is a stateful Flutter widget that represents a "like" action.
///It displays an icon that can be tapped to toggle the "like" state and also shows the number of likes.
/// It accepts properties for the icon size, the initial "like" state, the like count, and optional callbacks for the "like" and non-like actions.
///
class LikeAction extends StatefulWidget {
  const LikeAction(
      {super.key,
      this.size = 18,
      required this.like,
      this.likeAction,
      this.disLikeAction,
      required this.likeCount,
      this.bottom = false});

  final double? size;

  final bool like;

  final Function? likeAction;

  final Function? disLikeAction;

  final int likeCount;

  final bool? bottom;

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

  Widget _buildLayout(List<Widget> widgets) {
    bool ifBottom = widget.bottom ?? false;

    if (ifBottom) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      );
    }

    return Row(
      children: widgets,
    );
  }

  Widget _buildIconBtn() {
    return _like
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
            child: Icon(Icons.thumb_up_rounded, size: widget.size));
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayout(
      [
        _buildIconBtn(),
        widget.bottom ?? false
            ? const SizedBox(
                height: 8,
              )
            : const SizedBox(
                width: 5,
              ),
        SizedBox(
          width: 30,
          child: NumberConverter(number: _likeCount),
        )
      ],
    );
  }
}

///
/// The HateAction widget is a stateful Flutter widget that represents a "hate" action.
/// It displays an icon that can be tapped to toggle the "hate" state.
/// It accepts properties for the icon size, the initial "hate" state, and optional callbacks for the "hate" and non-hate actions.
///
class HateAction extends StatefulWidget {
  const HateAction(
      {super.key,
      this.size = 18,
      required this.hate,
      this.hateAction,
      this.disHateAction,
      this.hint = const Text("不喜欢")});

  final double? size;

  final bool hate;

  final Function? hateAction;

  final Function? disHateAction;

  final Widget? hint;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _hate
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
                child: Icon(Icons.thumb_down_alt_rounded, size: widget.size)),
          const SizedBox(height: 8,),
          widget.hint!
      ],
    );
  }
}
