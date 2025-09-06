import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:blog_client/core/common/models/profile_model.dart';

part 'blog_model.freezed.dart';

@freezed
sealed class BlogModel with _$BlogModel {
  const factory BlogModel({
    required int id,
    required String title,
    required String description,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @JsonKey(name: 'category_id') @Default('') String categoryId,
    @JsonKey(name: 'author_id') @Default('') String authorId,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    required ProfileModel author,
  }) = _BlogModel;
  const BlogModel._();

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] as Map<String, dynamic>?;
    final author = (authorJson == null)
        ? ProfileModel.empty()
        : ProfileModel.fromJson(authorJson);

    return BlogModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      categoryId: json['category_id'] ?? '',
      authorId: json['author_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      author: author,
    );
  }
}
