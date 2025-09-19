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
  const ProfileGetMyBlogsEvent({required this.id, this.isLoadMore = false});
  final String id;
  final bool isLoadMore;

  @override
  List<Object?> get props => [isLoadMore];
}

// Get Saved Blogs Event
class ProfileGetSavedBlogsEvent extends ProfileEvent {
  const ProfileGetSavedBlogsEvent({required this.id, this.isLoadMore = false});
  final String id;
  final bool isLoadMore;

  @override
  List<Object?> get props => [id, isLoadMore];
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

// Follow Profile Event
class ProfileFollowProfileEvent extends ProfileEvent {
  const ProfileFollowProfileEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// Unfollow Profile Event
class ProfileUnfollowProfileEvent extends ProfileEvent {
  const ProfileUnfollowProfileEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// Update follow-followings data
class ProfileUpdateFollowFollowingsDataEvent extends ProfileEvent {
  const ProfileUpdateFollowFollowingsDataEvent({required this.isFollowing});
  final bool isFollowing;

  @override
  List<Object?> get props => [isFollowing];
}

// Delete Blog Event
class ProfileDeleteBlogEvent extends ProfileEvent {
  const ProfileDeleteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}
