part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState({
    this.profileData = const ProfileModel(),
    this.blogs = const <BlogModel>[],
    this.profileApiState = ApiStateEnums.initial,
    this.blogsApiState = ApiStateEnums.initial,
  });
  final ProfileModel profileData;
  final List<BlogModel> blogs;
  final ApiStateEnums profileApiState;
  final ApiStateEnums blogsApiState;

  @override
  List<Object?> get props => [
    profileData,
    blogs,
    profileApiState,
    blogsApiState,
  ];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState() : super();
}

// Get User Profile States
class ProfileGetUserProfileLoadingState extends ProfileState {
  const ProfileGetUserProfileLoadingState({
    super.profileApiState = ApiStateEnums.loading,
    required super.blogsApiState,
    required super.blogs,
  });
}

class ProfileGetUserProfileSuccessState extends ProfileState {
  const ProfileGetUserProfileSuccessState({
    super.profileApiState = ApiStateEnums.success,
    required super.profileData,
    required super.blogsApiState,
    required super.blogs,
  });
}

class ProfileGetUserProfileFailureState extends ProfileState {
  const ProfileGetUserProfileFailureState({
    required this.errorMessage,
    super.profileApiState = ApiStateEnums.failure,
    required super.blogsApiState,
    required super.blogs,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [
    errorMessage,
    blogs,
    profileApiState,
    blogsApiState,
  ];
}

// Get My Blogs States
class ProfileGetMyBlogsLoadingState extends ProfileState {
  const ProfileGetMyBlogsLoadingState({
    super.blogsApiState = ApiStateEnums.loading,
    required super.profileApiState,
    required super.profileData,
  });
}

class ProfileGetMyBlogsSuccessState extends ProfileState {
  const ProfileGetMyBlogsSuccessState({
    required super.blogs,
    required super.profileApiState,
    required super.profileData,
    super.blogsApiState = ApiStateEnums.success,
  });
}

class ProfileGetMyBlogsFailureState extends ProfileState {
  const ProfileGetMyBlogsFailureState({
    required this.errorMessage,
    super.blogsApiState = ApiStateEnums.failure,
    required super.profileApiState,
    required super.profileData,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [
    errorMessage,
    profileApiState,
    blogsApiState,
    profileData,
  ];
}

// Get Saved Blogs States
class ProfileGetSavedBlogsLoadingState extends ProfileState {
  const ProfileGetSavedBlogsLoadingState({
    super.blogsApiState = ApiStateEnums.loading,
    required super.profileApiState,
    required super.profileData,
  });
}

class ProfileGetSavedBlogsSuccessState extends ProfileState {
  const ProfileGetSavedBlogsSuccessState({
    required super.blogs,
    required super.profileApiState,
    required super.profileData,
    super.blogsApiState = ApiStateEnums.success,
  });
}

class ProfileGetSavedBlogsFailureState extends ProfileState {
  const ProfileGetSavedBlogsFailureState({
    required this.errorMessage,
    super.blogsApiState = ApiStateEnums.failure,
    required super.profileApiState,
    required super.profileData,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, profileApiState, blogsApiState, profileData];
}

// Save Blog States
class ProfileSaveLoadingState extends ProfileState {
  const ProfileSaveLoadingState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileSaveSuccessState extends ProfileState {
  const ProfileSaveSuccessState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileSaveFailureState extends ProfileState {
  const ProfileSaveFailureState({
    required this.errorMessage,
    required super.profileData,
    required super.blogs,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, profileApiState, blogsApiState];
}

// Unsave Blog States
class ProfileUnsaveLoadingState extends ProfileState {
  const ProfileUnsaveLoadingState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileUnsaveSuccessState extends ProfileState {
  const ProfileUnsaveSuccessState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileUnsaveFailureState extends ProfileState {
  const ProfileUnsaveFailureState({
    required this.errorMessage,
    required super.profileData,
    required super.blogs,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, profileApiState, blogsApiState];
}

// Upvote Blog States
class ProfileUpvoteLoadingState extends ProfileState {
  const ProfileUpvoteLoadingState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileUpvoteSuccessState extends ProfileState {
  const ProfileUpvoteSuccessState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileUpvoteFailureState extends ProfileState {
  const ProfileUpvoteFailureState({
    required super.profileData,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, profileApiState, blogsApiState];
}

// Unupvote Blog States
class ProfileUnupvoteLoadingState extends ProfileState {
  const ProfileUnupvoteLoadingState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileUnupvoteSuccessState extends ProfileState {
  const ProfileUnupvoteSuccessState({
    required super.profileData,
    required super.blogs,
  });
}

class ProfileUnupvoteFailureState extends ProfileState {
  const ProfileUnupvoteFailureState({
    required this.errorMessage,
    required super.profileData,
    required super.blogs,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, profileApiState, blogsApiState];
}
