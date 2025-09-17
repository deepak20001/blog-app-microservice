part of 'follow_followings_bloc.dart';

sealed class FollowFollowingsState extends Equatable {
  const FollowFollowingsState({this.data = const <FollowerFollowingModel>[]});
  final List<FollowerFollowingModel> data;

  @override
  List<Object?> get props => [data];
}

class FollowFollowingsInitialState extends FollowFollowingsState {
  const FollowFollowingsInitialState() : super();
}

// Get Followers States
class FollowFollowingsGetFollowersLoadingState extends FollowFollowingsState {
  const FollowFollowingsGetFollowersLoadingState({required super.data});
}

class FollowFollowingsGetFollowersSuccessState extends FollowFollowingsState {
  const FollowFollowingsGetFollowersSuccessState({required super.data});
}

class FollowFollowingsGetFollowersFailureState extends FollowFollowingsState {
  const FollowFollowingsGetFollowersFailureState({
    required super.data,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, data];
}

// Get Followings States
class FollowFollowingsGetFollowingsLoadingState extends FollowFollowingsState {
  const FollowFollowingsGetFollowingsLoadingState({required super.data});
}

class FollowFollowingsGetFollowingsSuccessState extends FollowFollowingsState {
  const FollowFollowingsGetFollowingsSuccessState({required super.data});
}

class FollowFollowingsGetFollowingsFailureState extends FollowFollowingsState {
  const FollowFollowingsGetFollowingsFailureState({
    required super.data,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, data];
}

// Follow Profile States
class FollowFollowingsFollowProfileLoadingState extends FollowFollowingsState {
  const FollowFollowingsFollowProfileLoadingState({required super.data});
}

class FollowFollowingsFollowProfileSuccessState extends FollowFollowingsState {
  const FollowFollowingsFollowProfileSuccessState({required super.data});
}

class FollowFollowingsFollowProfileFailureState extends FollowFollowingsState {
  const FollowFollowingsFollowProfileFailureState({
    required super.data,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, data];
}

// Unfollow Profile States
class FollowFollowingsUnfollowProfileLoadingState
    extends FollowFollowingsState {
  const FollowFollowingsUnfollowProfileLoadingState({required super.data});
}

class FollowFollowingsUnfollowProfileSuccessState
    extends FollowFollowingsState {
  const FollowFollowingsUnfollowProfileSuccessState({required super.data});
}

class FollowFollowingsUnfollowProfileFailureState
    extends FollowFollowingsState {
  const FollowFollowingsUnfollowProfileFailureState({
    required super.data,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, data];
}
