// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => _BlogModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  imageUrl: json['image_url'] as String? ?? '',
  categoryId: json['category_id'] as String? ?? '',
  authorId: json['author_id'] as String? ?? '',
  createdAt: json['created_at'] as String? ?? '',
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
  isLiked: json['is_voted'] as bool? ?? false,
  isSaved: json['is_saved'] as bool? ?? false,
  author: json['author'] == null
      ? const ProfileModel()
      : ProfileModel.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BlogModelToJson(_BlogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'category_id': instance.categoryId,
      'author_id': instance.authorId,
      'created_at': instance.createdAt,
      'vote_count': instance.voteCount,
      'is_voted': instance.isLiked,
      'is_saved': instance.isSaved,
      'author': instance.author,
    };
