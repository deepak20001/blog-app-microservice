import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:blog_client/core/common/models/profile_model.dart';

part 'comment_model.freezed.dart';

@freezed
sealed class CommentModel with _$CommentModel {
  const factory CommentModel({
    @Default(0) int id,
    @Default('') String comment,
    @JsonKey(name: 'user_id') @Default('') String userId,
    @JsonKey(name: 'blog_id') @Default(0) int blogId,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'is_voted') @Default(false) bool isVoted,
    @JsonKey(name: 'author') @Default(ProfileModel()) ProfileModel author,
  }) = _CommentModel;
  const CommentModel._();

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] as Map<String, dynamic>?;
    final author = (authorJson == null)
        ? ProfileModel.empty()
        : ProfileModel.fromJson(authorJson);

    return CommentModel(
      id: json['id'] ?? 0,
      comment: json['comment'] ?? '',
      userId: json['user_id'] ?? '',
      blogId: json['blog_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      voteCount: json['vote_count'] ?? 0,
      isVoted: json['is_voted'] ?? false,
      author: author,
    );
  }

  factory CommentModel.empty() => const CommentModel();
}
