part of 'follow_followings_bloc.dart';

abstract class FollowFollowingsEvent extends Equatable {
  const FollowFollowingsEvent();

  @override
  List<Object?> get props => [];
}

// get followers
class FollowFollowingsGetFollowersEvent extends FollowFollowingsEvent {
  const FollowFollowingsGetFollowersEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// get followings
class FollowFollowingsGetFollowingsEvent extends FollowFollowingsEvent {
  const FollowFollowingsGetFollowingsEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id  ];
}

// follow profile
class FollowFollowingsFollowProfileEvent extends FollowFollowingsEvent {
  const FollowFollowingsFollowProfileEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// unfollow profile
class FollowFollowingsUnfollowProfileEvent extends FollowFollowingsEvent {
  const FollowFollowingsUnfollowProfileEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}
