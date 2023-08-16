// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDisplayParams _$CommentDisplayParamsFromJson(
        Map<String, dynamic> json) =>
    CommentDisplayParams(
      json['id'] as String,
      json['content'] as String,
      json['userNickname'] as String,
      json['userAvatarUrl'] as String,
      json['createTime'] as String,
      json['likeCount'] as int,
      json['userLevel'] as int,
      json['userId'] as String,
    );

Map<String, dynamic> _$CommentDisplayParamsToJson(
        CommentDisplayParams instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'userNickname': instance.userNickname,
      'userId': instance.userId,
      'userAvatarUrl': instance.userAvatarUrl,
      'createTime': instance.createTime,
      'likeCount': instance.likeCount,
      'userLevel': instance.userLevel,
    };
