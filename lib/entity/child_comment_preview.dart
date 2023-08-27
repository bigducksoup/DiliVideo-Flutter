
import 'package:json_annotation/json_annotation.dart';


part 'child_comment_preview.g.dart';

@JsonSerializable()
class ChildPreviewComment{

  String id;
  String userId;
  String nickName;
  String content;


  ChildPreviewComment(this.id,this.content,this.nickName,this.userId);

  factory ChildPreviewComment.fromJson(Map<String,dynamic> json) => _$ChildPreviewCommentFromJson(json);

  Map<String, dynamic> toJson() => _$ChildPreviewCommentToJson(this);

}