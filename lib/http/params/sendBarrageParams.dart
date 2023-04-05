

class BarrageParam{

  String content;

  int color;

  int seconds;

  String videoInfoId;

  int ifMid;

  BarrageParam({required this.content,required this.color,required this.seconds,required this.videoInfoId , required this.ifMid});


  Map<String,dynamic> toJSON(){
    return {
      "content":content,
      "color":color,
      "seconds":seconds,
      "videoInfoId":videoInfoId,
      "ifMid":ifMid
    };
  }




}