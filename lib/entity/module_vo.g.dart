// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleVO _$ModuleVOFromJson(Map<String, dynamic> json) => ModuleVO(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String,
      userAvatarPath: json['userAvatarPath'] as String,
      userNickname: json['userNickname'] as String,
      description: json['description'] as String,
      typeId: json['typeId'] as String,
      videoInfoId: json['videoInfoId'] as String,
      childPostId: json['childPostId'] as String,
      imgs: (json['imgs'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ModuleVOToJson(ModuleVO instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userAvatarUrl': instance.userAvatarUrl,
      'userAvatarPath': instance.userAvatarPath,
      'userNickname': instance.userNickname,
      'description': instance.description,
      'typeId': instance.typeId,
      'videoInfoId': instance.videoInfoId,
      'childPostId': instance.childPostId,
      'imgs': instance.imgs,
    };
