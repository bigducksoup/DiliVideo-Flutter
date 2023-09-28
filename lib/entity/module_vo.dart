import 'package:json_annotation/json_annotation.dart';

part 'module_vo.g.dart';

@JsonSerializable()
class ModuleVO {
  

  String id;

  String userId;

  String userAvatarUrl;

  String userAvatarPath;

  String userNickname;

  String description;

  String typeId;

  String videoInfoId;

  String childPostId;

  List<String>? imgs;




  ModuleVO({required this.id,
    required this.userId,
    required this.userAvatarUrl,
    required this.userAvatarPath,
    required this.userNickname,
    required this.description,
    required this.typeId,
    required this.videoInfoId,
    required this.childPostId,
    this.imgs});

  factory ModuleVO.fromJson(Map<String, dynamic> json) => _$ModuleVOFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleVOToJson(this);
}