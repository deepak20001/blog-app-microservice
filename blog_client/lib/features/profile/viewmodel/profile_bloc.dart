import 'dart:core';
import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/features/profile/repositories/profile_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@singleton
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileRemoteRepository profileRemoteRepository,
    required SharedPreferencesStorageRepository storageRepository,
  }) : _profileRemoteRepository = profileRemoteRepository,
       _storageRepository = storageRepository,
       super(const ProfileInitialState()) {
    on<ProfileGetMyBlogsEvent>(_onGetMyBlogsRequested);
    on<ProfileGetSavedBlogsEvent>(_onGetSavedBlogsRequested);
  }
  final ProfileRemoteRepository _profileRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;
  final int _page = 1;
  final int _limit = 10;

  // getters
  String get userProfileImage => _storageRepository.userProfileImage;
  String get userName => _storageRepository.userName;
  String get userBio => _storageRepository.userBio;

  /// Handle get my blogs request
  Future<void> _onGetMyBlogsRequested(
    ProfileGetMyBlogsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileGetMyBlogsLoadingState());

    try {
      final result = await _profileRemoteRepository.getMyBlogs(
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get My Blogs failed: ${failure.message}');
          emit(ProfileGetMyBlogsFailureState(errorMessage: failure.message));
        },
        (List<BlogModel> blogs) async {
          emit(ProfileGetMyBlogsSuccessState(blogs: blogs));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get my blogs: $e',
        stackTrace: stackTrace,
      );
      emit(
        const ProfileGetMyBlogsFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle get saved blogs request
  Future<void> _onGetSavedBlogsRequested(
    ProfileGetSavedBlogsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileGetSavedBlogsLoadingState());

    try {
      final result = await _profileRemoteRepository.getSavedBlogs(
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get Saved Blogs failed: ${failure.message}');
          emit(ProfileGetSavedBlogsFailureState(errorMessage: failure.message));
        },
        (List<BlogModel> blogs) async {
          emit(ProfileGetSavedBlogsSuccessState(blogs: blogs));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get saved blogs: $e',
        stackTrace: stackTrace,
      );
      emit(
        const ProfileGetSavedBlogsFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
