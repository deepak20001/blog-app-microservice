part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Get User Profile Event
class ProfileGetUserProfileEvent extends ProfileEvent {
  const ProfileGetUserProfileEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// Get User Profile Stats Event
class ProfileGetUserProfileStatsEvent extends ProfileEvent {
  const ProfileGetUserProfileStatsEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// Get My Blogs Event
class ProfileGetMyBlogsEvent extends ProfileEvent {
  const ProfileGetMyBlogsEvent();

  @override
  List<Object?> get props => [];
}

// Get Saved Blogs Event
class ProfileGetSavedBlogsEvent extends ProfileEvent {
  const ProfileGetSavedBlogsEvent();

  @override
  List<Object?> get props => [];
}

// Save Blog Event
class ProfileSaveBlogEvent extends ProfileEvent {
  const ProfileSaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unsave Blog Event
class ProfileUnsaveBlogEvent extends ProfileEvent {
  const ProfileUnsaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Upvote Blog Event
class ProfileUpvoteBlogEvent extends ProfileEvent {
  const ProfileUpvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unupvote Blog Event
class ProfileUnupvoteBlogEvent extends ProfileEvent {
  const ProfileUnupvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Get updated data from local storage
class ProfileGetUpdatedDataFromLocalStorageEvent extends ProfileEvent {
  const ProfileGetUpdatedDataFromLocalStorageEvent();

  @override
  List<Object?> get props => [];
}

// Logout Event
class ProfileLogoutEvent extends ProfileEvent {
  const ProfileLogoutEvent();

  @override
  List<Object?> get props => [];
}
