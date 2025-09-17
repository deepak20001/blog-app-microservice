import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
sealed class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @JsonKey(name: '_id') @Default('') String id,
    @Default('Anonymous') String username,
    @Default('') String email,
    @Default('') String bio,
    @Default('') String avatar,
    @Default('') String role,
    @Default(false) bool isVerified,
    @Default('') String createdAt,
    @Default('') String updatedAt,
    @Default(0) int followersCount,
    @Default(0) int followingsCount,
    @Default(0) int userPostedBlogsCount, 
  }) = _ProfileModel;
  const ProfileModel._();

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => const ProfileModel();
  bool get isEmpty => id.isEmpty || username == 'Unknown User';
}
