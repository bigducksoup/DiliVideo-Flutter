import 'package:json_annotation/json_annotation.dart';

part 'replyVO.g.dart';

@JsonSerializable()
class ReplyVO {
  /// The generated code assumes these values exist in JSON.
  final String id;

  final String replierId;

  final String avatar;

  final String replierName;

  final int level;

  final String toId;

  final String toName;

  final String content;

  final String time;

  final int likeCount;



  ReplyVO(this.id, this.replierId, this.avatar, this.replierName, this.level, this.toId, this.toName, this.content, this.time, this.likeCount);

  factory ReplyVO.fromJson(Map<String, dynamic> json) => _$ReplyVOFromJson(json);


  Map<String, dynamic> toJson() => _$ReplyVOToJson(this);
}