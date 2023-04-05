import 'bullet.dart';

class BarrageStates {
  int channelCount;

  late List<List<Bullet>> channels;

  bool ifStop = false;

  late double width;

  late double height;

  BarrageStates(
      {this.channelCount = 5}) {
    channels = [];
    for (int i = 0; i < channelCount; i++) {
      channels.add([]);
    }
  }
}
