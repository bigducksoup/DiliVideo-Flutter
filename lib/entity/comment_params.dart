
import 'package:json_annotation/json_annotation.dart';


part 'comment_params.g.dart';

@JsonSerializable()
class CommentDisplayParams{

  String id;
  String content;
  String userNickname;
  String userId;
  String userAvatarUrl;
  String createTime;
  int likeCount;
  int userLevel;

  CommentDisplayParams(this.id,this.content,this.userNickname,this.userAvatarUrl,this.createTime,this.likeCount,this.userLevel,this.userId);

  factory CommentDisplayParams.fromJson(Map<String,dynamic> json) => _$CommentDisplayParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDisplayParamsToJson(this);

}