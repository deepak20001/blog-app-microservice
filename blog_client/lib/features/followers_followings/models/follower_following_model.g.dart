// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower_following_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowerFollowingModel _$FollowerFollowingModelFromJson(
  Map<String, dynamic> json,
) => _FollowerFollowingModel(
  id: json['_id'] as String? ?? '',
  follower: json['follower'] == null
      ? const ProfileModel()
      : ProfileModel.fromJson(json['follower'] as Map<String, dynamic>),
  following: json['following'] == null
      ? const ProfileModel()
      : ProfileModel.fromJson(json['following'] as Map<String, dynamic>),
  isFollowing: json['isFollowing'] as bool? ?? false,
);

Map<String, dynamic> _$FollowerFollowingModelToJson(
  _FollowerFollowingModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'follower': instance.follower,
  'following': instance.following,
  'isFollowing': instance.isFollowing,
};
