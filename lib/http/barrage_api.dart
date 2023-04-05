import 'package:dili_video/http/params/sendBarrageParams.dart';
import 'package:dio/dio.dart';

import 'dio_manager.dart';



Future sendBarrage( BarrageParam barrageParam ) async {
  var response = dio.post('/barrage/send',
  data: barrageParam.toJSON());
  return response;
}
