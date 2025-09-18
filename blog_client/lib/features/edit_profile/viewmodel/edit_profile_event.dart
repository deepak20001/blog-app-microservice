part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

// Get User Profile Event
class EditProfileGetUserProfileEvent extends EditProfileEvent {
  const EditProfileGetUserProfileEvent();

  @override
  List<Object?> get props => [];
}

// Pick Image Event
class EditProfilePickImageEvent extends EditProfileEvent {
  const EditProfilePickImageEvent();

  @override
  List<Object?> get props => [];
}

// Upload Image Event
class EditProfileUploadImageEvent extends EditProfileEvent {
  const EditProfileUploadImageEvent();

  @override
  List<Object?> get props => [];
}

// Update Avatar Event
class EditProfileUpdateAvatarEvent extends EditProfileEvent {
  const EditProfileUpdateAvatarEvent({required this.uploadedImagePath});
  final String uploadedImagePath;

  @override
  List<Object?> get props => [uploadedImagePath];
}

// Update Profile Event
class EditProfileUpdateProfileEvent extends EditProfileEvent {
  const EditProfileUpdateProfileEvent({
    required this.userName,
    required this.bio,
  });
  final String userName;
  final String bio;

  @override
  List<Object?> get props => [userName, bio];
}
