import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower_following_model.freezed.dart';
part 'follower_following_model.g.dart';

@freezed
sealed class FollowerFollowingModel with _$FollowerFollowingModel {
  const factory FollowerFollowingModel({
    @JsonKey(name: '_id') @Default('') String id,
    @JsonKey(name: 'follower') @Default(ProfileModel()) ProfileModel follower,
    @JsonKey(name: 'following') @Default(ProfileModel()) ProfileModel following,
    @JsonKey(name: 'isFollowing') @Default(false) bool isFollowing,
  }) = _FollowerFollowingModel;
  const FollowerFollowingModel._();

  factory FollowerFollowingModel.fromJson(Map<String, dynamic> json) =>
      _$FollowerFollowingModelFromJson(json);

  factory FollowerFollowingModel.empty() => const FollowerFollowingModel();
}
