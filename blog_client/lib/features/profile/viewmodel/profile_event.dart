part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
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
