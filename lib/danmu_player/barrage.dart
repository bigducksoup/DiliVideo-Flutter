import 'package:dili_video/danmu_player/barrage_controller.dart';

import 'package:flutter/material.dart';

class Barrage extends StatefulWidget {
  const Barrage({super.key, required this.barrageController, required this.width, required this.height});

  final BarrageController barrageController;
  final double width;
  final double height;

  @override
  State<Barrage> createState() => _BarrageState();
}

class _BarrageState extends State<Barrage> {
  @override
  void initState() {
    widget.barrageController.value.width = widget.width;
    widget.barrageController.value.height = widget.height;
    widget.barrageController.renderBullet(setState);
    super.initState();
  }


//构建count个行存放弹幕
  List<Widget> buildChannel() {
    List<Widget> rows = [];

    for (int i = 0; i < widget.barrageController.value.channelCount; i++) {
      rows.add(SizedBox(
        height: widget.barrageController.value.height/widget.barrageController.value.channelCount,
        child: Stack(children: [
          for (int j = 0;
              j < widget.barrageController.value.channels[i].length;
              j++)
            Transform.translate(
                offset: Offset(
                    widget.barrageController.value.channels[i][j].offsetX, 0),
                child: Text(
                  widget.barrageController.value.channels[i][j].content,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ))
        ]),
      ));
    }

    return rows;
  }

  @override
  void dispose() {
    widget.barrageController.renderTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.barrageController.value.height,
        width: widget.barrageController.value.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildChannel(),
        ));
  }
}
