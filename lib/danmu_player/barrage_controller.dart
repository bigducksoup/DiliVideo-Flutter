import 'dart:async';

import 'package:dili_video/danmu_player/barrage_states.dart';
import 'package:flutter/material.dart';

import 'bullet.dart';

class BarrageController extends ValueNotifier<BarrageStates> {
  BarrageController({required int channelCount})
      : super(BarrageStates(channelCount: channelCount));

  late Timer renderTimer;

  addToChannel(int index, String content) {
    value.channels[index].add(Bullet(
        content: content,
        key: UniqueKey(),
        right: 0,
        seconds: 0,
        screenWidth: value.width));
  }

  void renderBullet(Function setState) {
    renderTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (value.ifStop == false) {
        setState((){
          for (int i = 0; i < value.channels.length; i++) {
          for (var element in value.channels[i]) {
            element.moveOneFrame();
          }
          value.channels[i].removeWhere((element) => !element.status);
        }
        });
      }
    });
  }
}
