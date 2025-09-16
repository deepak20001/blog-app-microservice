part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState({this.blogs = const <BlogModel>[]});
  final List<BlogModel> blogs;

  @override
  List<Object?> get props => [blogs];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState() : super();
}

// Get My Blogs States
class ProfileGetMyBlogsLoadingState extends ProfileState {
  const ProfileGetMyBlogsLoadingState();
}

class ProfileGetMyBlogsSuccessState extends ProfileState {
  const ProfileGetMyBlogsSuccessState({required super.blogs});
}

class ProfileGetMyBlogsFailureState extends ProfileState {
  const ProfileGetMyBlogsFailureState({
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blogs];
}

// Get Saved Blogs States
class ProfileGetSavedBlogsLoadingState extends ProfileState {
  const ProfileGetSavedBlogsLoadingState();
}

class ProfileGetSavedBlogsSuccessState extends ProfileState {
  const ProfileGetSavedBlogsSuccessState({required super.blogs});
}

class ProfileGetSavedBlogsFailureState extends ProfileState {
  const ProfileGetSavedBlogsFailureState({
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blogs];
}
