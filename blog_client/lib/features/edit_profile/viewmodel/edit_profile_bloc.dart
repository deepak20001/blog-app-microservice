import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/features/edit_profile/repositories/edit_profile_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

@singleton
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required EditProfileRemoteRepository editProfileRemoteRepository,
    required SharedPreferencesStorageRepository storageRepository,
  }) : _editProfileRemoteRepository = editProfileRemoteRepository,
       _storageRepository = storageRepository,
       super(const EditProfileInitialState()) {
    on<EditProfileGetUserProfileEvent>(_onGetUserProfile);
    on<EditProfilePickImageEvent>(_onPickImage);
    on<EditProfileUploadImageEvent>(_onUploadAvatar);
    on<EditProfileUpdateAvatarEvent>(_onUpdateAvatar);
    on<EditProfileUpdateProfileEvent>(_onUpdateProfile);
  }
  final EditProfileRemoteRepository _editProfileRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;

  // getters
  String get userId => _storageRepository.userId;

  // Handle get user profile
  Future<void> _onGetUserProfile(
    EditProfileGetUserProfileEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state is EditProfileGetUserProfileLoadingState) return;
    emit(
      EditProfileGetUserProfileLoadingState(
        imagePath: state.imagePath,
        profile: state.profile,
      ),
    );

    try {
      final result = await _editProfileRemoteRepository.getUserProfile(
        id: userId,
      );

      await result.fold(
        (failure) {
          devtools.log('Get user profile failed: ${failure.message}');
          emit(
            EditProfileGetUserProfileFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              profile: state.profile,
            ),
          );
        },
        (ProfileModel profile) async {
          emit(
            EditProfileGetUserProfileSuccessState(
              imagePath: state.imagePath,
              profile: profile,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get user profile: $e',
        stackTrace: stackTrace,
      );
      emit(
        EditProfileGetUserProfileFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
          profile: state.profile,
        ),
      );
    }
  }

  // Handle pick image
  Future<void> _onPickImage(
    EditProfilePickImageEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state is EditProfilePickImageLoadingState) return;
    emit(
      EditProfilePickImageLoadingState(
        imagePath: state.imagePath,
        profile: state.profile,
      ),
    );
    try {
      final result = await _editProfileRemoteRepository.pickImage();

      await result.fold(
        (failure) {
          devtools.log('Pick image failed: ${failure.message}');
          emit(
            EditProfilePickImageFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              profile: state.profile,
            ),
          );
        },
        (data) async {
          final imagePath = data;
          emit(
            EditProfilePickImageSuccessState(
              imagePath: imagePath,
              profile: state.profile,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during pick image: $e',
        stackTrace: stackTrace,
      );
      emit(
        EditProfilePickImageFailureState(
          imagePath: state.imagePath,
          errorMessage: 'An unexpected error occurred. Please try again.',
          profile: state.profile,
        ),
      );
    }
  }

  // Handle upload avatar
  Future<void> _onUploadAvatar(
    EditProfileUploadImageEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state is EditProfileUploadImageLoadingState) return;
    emit(
      EditProfileUploadImageLoadingState(
        imagePath: state.imagePath,
        profile: state.profile,
      ),
    );
    try {
      final result = await _editProfileRemoteRepository.uploadImage(
        imagePath: state.imagePath,
      );

      await result.fold(
        (failure) {
          devtools.log('Upload avatar failed: ${failure.message}');
          emit(
            EditProfileUploadImageFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              profile: state.profile,
            ),
          );
        },
        (String uploadedImagePath) async {
          emit(
            EditProfileUploadImageSuccessState(
              imagePath: state.imagePath,
              profile: state.profile,
              uploadedImagePath: uploadedImagePath,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during upload avatar: $e',
        stackTrace: stackTrace,
      );
      emit(
        EditProfileUploadImageFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
          profile: state.profile,
        ),
      );
    }
  }

  // Handle update avatar
  Future<void> _onUpdateAvatar(
    EditProfileUpdateAvatarEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state is EditProfileUpdateAvatarLoadingState) return;
    emit(
      EditProfileUpdateAvatarLoadingState(
        imagePath: state.imagePath,
        profile: state.profile,
      ),
    );
    try {
      final result = await _editProfileRemoteRepository.updateAvatar(
        avatarPath: event.uploadedImagePath,
      );

      await result.fold(
        (failure) {
          devtools.log('Upload avatar failed: ${failure.message}');
          emit(
            EditProfileUpdateAvatarFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              profile: state.profile,
            ),
          );
        },
        (String uploadedImagePath) async {
          emit(
            EditProfileUpdateAvatarSuccessState(
              imagePath: state.imagePath,
              profile: state.profile,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during upload avatar: $e',
        stackTrace: stackTrace,
      );
      emit(
        EditProfileUpdateAvatarFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
          profile: state.profile,
        ),
      );
    }
  }

  // Handle update profile
  Future<void> _onUpdateProfile(
    EditProfileUpdateProfileEvent event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state is EditProfileUpdateProfileLoadingState) return;
    emit(
      EditProfileUpdateProfileLoadingState(
        imagePath: state.imagePath,
        profile: state.profile,
      ),
    );
    try {
      final result = await _editProfileRemoteRepository.updateProfile(
        userName: event.userName,
        bio: event.bio,
      );

      await result.fold(
        (failure) {
          devtools.log('Update profile failed: ${failure.message}');
          emit(
            EditProfileUpdateProfileFailureState(
              errorMessage: failure.message,
              imagePath: state.imagePath,
              profile: state.profile,
            ),
          );
        },
        (data) async {
          final (successMessage, profile) = data;
          _storageRepository.userProfileImage = profile.avatar;
          _storageRepository.userName = profile.username;
          _storageRepository.userBio = profile.bio;
          emit(
            EditProfileUpdateProfileSuccessState(
              imagePath: state.imagePath,
              profile: profile,
              successMessage: successMessage,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during update profile: $e',
        stackTrace: stackTrace,
      );
      emit(
        EditProfileUpdateProfileFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          imagePath: state.imagePath,
          profile: state.profile,
        ),
      );
    }
  }
}
