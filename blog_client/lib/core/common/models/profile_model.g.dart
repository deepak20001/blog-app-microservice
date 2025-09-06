// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? 'Anonymous',
      email: json['email'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      role: json['role'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingsCount: (json['followingsCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'bio': instance.bio,
      'avatar': instance.avatar,
      'role': instance.role,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'followersCount': instance.followersCount,
      'followingsCount': instance.followingsCount,
    };
