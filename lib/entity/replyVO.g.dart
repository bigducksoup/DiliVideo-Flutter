// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replyVO.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyVO _$ReplyVOFromJson(Map<String, dynamic> json) => ReplyVO(
      json['id'] as String,
      json['replierId'] as String,
      json['avatar'] as String,
      json['replierName'] as String,
      json['level'] as int,
      json['toId'] as String,
      json['toName'] as String,
      json['content'] as String,
      json['time'] as String,
      json['likeCount'] as int,
    );

Map<String, dynamic> _$ReplyVOToJson(ReplyVO instance) => <String, dynamic>{
      'id': instance.id,
      'replierId': instance.replierId,
      'avatar': instance.avatar,
      'replierName': instance.replierName,
      'level': instance.level,
      'toId': instance.toId,
      'toName': instance.toName,
      'content': instance.content,
      'time': instance.time,
      'likeCount': instance.likeCount,
    };
