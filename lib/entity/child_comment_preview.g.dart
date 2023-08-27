// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_comment_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildPreviewComment _$ChildPreviewCommentFromJson(Map<String, dynamic> json) =>
    ChildPreviewComment(
      json['id'] as String,
      json['content'] as String,
      json['nickName'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$ChildPreviewCommentToJson(
        ChildPreviewComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'nickName': instance.nickName,
      'content': instance.content,
    };
