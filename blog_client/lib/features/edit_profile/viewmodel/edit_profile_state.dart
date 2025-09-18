part of 'edit_profile_bloc.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState({
    this.imagePath = '',
    this.profile = const ProfileModel(),
  });
  final String imagePath;
  final ProfileModel profile;

  @override
  List<Object?> get props => [imagePath, profile];
}

class EditProfileInitialState extends EditProfileState {
  const EditProfileInitialState() : super();
}

// Get User Profile States
class EditProfileGetUserProfileLoadingState extends EditProfileState {
  const EditProfileGetUserProfileLoadingState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfileGetUserProfileSuccessState extends EditProfileState {
  const EditProfileGetUserProfileSuccessState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfileGetUserProfileFailureState extends EditProfileState {
  const EditProfileGetUserProfileFailureState({
    required super.imagePath,
    required super.profile,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, profile];
}

// Pick Image States
class EditProfilePickImageLoadingState extends EditProfileState {
  const EditProfilePickImageLoadingState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfilePickImageSuccessState extends EditProfileState {
  const EditProfilePickImageSuccessState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfilePickImageFailureState extends EditProfileState {
  const EditProfilePickImageFailureState({
    required super.imagePath,
    required super.profile,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, profile];
}

// Upload Image States
class EditProfileUploadImageLoadingState extends EditProfileState {
  const EditProfileUploadImageLoadingState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfileUploadImageSuccessState extends EditProfileState {
  const EditProfileUploadImageSuccessState({
    required super.imagePath,
    required super.profile,
    required this.uploadedImagePath,
  });
  final String uploadedImagePath;

  @override
  List<Object?> get props => [uploadedImagePath, imagePath, profile];
}

class EditProfileUploadImageFailureState extends EditProfileState {
  const EditProfileUploadImageFailureState({
    required super.imagePath,
    required super.profile,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, profile];
}

// Update Avatar States
class EditProfileUpdateAvatarLoadingState extends EditProfileState {
  const EditProfileUpdateAvatarLoadingState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfileUpdateAvatarSuccessState extends EditProfileState {
  const EditProfileUpdateAvatarSuccessState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfileUpdateAvatarFailureState extends EditProfileState {
  const EditProfileUpdateAvatarFailureState({
    required super.imagePath,
    required super.profile,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, profile];
}

// Update Profile States
class EditProfileUpdateProfileLoadingState extends EditProfileState {
  const EditProfileUpdateProfileLoadingState({
    required super.imagePath,
    required super.profile,
  });
}

class EditProfileUpdateProfileSuccessState extends EditProfileState {
  const EditProfileUpdateProfileSuccessState({
    required super.imagePath,
    required super.profile,
    required this.successMessage,
  });
  final String successMessage;

  @override
  List<Object?> get props => [successMessage, imagePath, profile];
}

class EditProfileUpdateProfileFailureState extends EditProfileState {
  const EditProfileUpdateProfileFailureState({
    required super.imagePath,
    required super.profile,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, imagePath, profile];
}
