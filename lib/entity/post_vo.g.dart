// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostVO _$PostVOFromJson(Map<String, dynamic> json) => PostVO(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      topicId: json['topicId'] as String,
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      shareCount: json['shareCount'] as int,
      createTime: json['createTime'] as String,
      status: json['status'] as String,
      moduleVO: ModuleVO.fromJson(json['moduleVO'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostVOToJson(PostVO instance) => <String, dynamic>{
      'id': instance.id,
      'moduleId': instance.moduleId,
      'topicId': instance.topicId,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'createTime': instance.createTime,
      'status': instance.status,
      'moduleVO': instance.moduleVO,
    };
