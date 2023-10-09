

import 'package:dili_video/entity/module_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_vo.g.dart';

@JsonSerializable()
class PostVO {

  String id;

  String moduleId;

  String topicId;

  int likeCount;

  int commentCount;

  int shareCount;

  String createTime;

  int status;

  ModuleVO moduleVO;


  PostVO({
    required this.id,
    required this.moduleId,
    required this.topicId,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.createTime,
    required this.status,
    required this.moduleVO
  });


  factory PostVO.fromJson(Map<String, dynamic> json) => _$PostVOFromJson(json);


  Map<String, dynamic> toJson() => _$PostVOToJson(this);
}