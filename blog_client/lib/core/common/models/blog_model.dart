import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:blog_client/core/common/models/profile_model.dart';

part 'blog_model.freezed.dart';
part 'blog_model.g.dart';

@freezed
sealed class BlogModel with _$BlogModel {
  const factory BlogModel({
    @Default(0) int id,
    @Default('') String title,
    @JsonKey(name: 'short_description') @Default('') String shortDescription,
    @Default('') String description,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'category_id') @Default('') String categoryId,
    @JsonKey(name: 'author_id') @Default('') String authorId,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @JsonKey(name: 'is_voted') @Default(false) bool isLiked,
    @JsonKey(name: 'is_saved') @Default(false) bool isSaved,
    @Default(ProfileModel()) ProfileModel author,
  }) = _BlogModel;
  const BlogModel._();

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);

  factory BlogModel.empty() => const BlogModel();
}
