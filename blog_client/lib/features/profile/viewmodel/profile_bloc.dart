import 'dart:core';
import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/enums/api_state_enums.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/models/profile_model.dart';
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
    on<ProfileGetUserProfileEvent>(_onGetUserProfileRequested);
    on<ProfileGetMyBlogsEvent>(_onGetMyBlogsRequested);
    on<ProfileGetSavedBlogsEvent>(_onGetSavedBlogsRequested);
    on<ProfileSaveBlogEvent>(_onSaveBlogRequested);
    on<ProfileUnsaveBlogEvent>(_onUnsaveBlogRequested);
    on<ProfileUpvoteBlogEvent>(_onUpvoteBlogRequested);
    on<ProfileUnupvoteBlogEvent>(_onUnupvoteBlogRequested);
  }
  final ProfileRemoteRepository _profileRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;
  final int _page = 1;
  final int _limit = 10;

  // getters
  String get userProfileImage => _storageRepository.userProfileImage;
  String get userName => _storageRepository.userName;
  String get userBio => _storageRepository.userBio;

  /// Handle get user profile request
  Future<void> _onGetUserProfileRequested(
    ProfileGetUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileGetUserProfileLoadingState(
        blogsApiState: state.blogsApiState,
        blogs: state.blogs,
      ),
    );

    try {
      final result = await _profileRemoteRepository.getUserProfile(
        id: (event.id.isNotEmpty) ? event.id : _storageRepository.userId,
      );

      await result.fold(
        (failure) {
          devtools.log('Get User Profile failed: ${failure.message}');
          emit(
            ProfileGetUserProfileFailureState(
              errorMessage: failure.message,
              blogsApiState: state.blogsApiState,
              blogs: state.blogs,
            ),
          );
        },
        (ProfileModel profileData) async {
          emit(
            ProfileGetUserProfileSuccessState(
              blogs: state.blogs,
              blogsApiState: state.blogsApiState,
              profileData: profileData,
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
        ProfileGetUserProfileFailureState(
          blogsApiState: state.blogsApiState,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle get my blogs request
  Future<void> _onGetMyBlogsRequested(
    ProfileGetMyBlogsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileGetMyBlogsLoadingState(
        profileApiState: state.profileApiState,
        profileData: state.profileData,
      ),
    );

    try {
      final result = await _profileRemoteRepository.getMyBlogs(
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get My Blogs failed: ${failure.message}');
          emit(
            ProfileGetMyBlogsFailureState(
              errorMessage: failure.message,
              profileApiState: state.profileApiState,
              profileData: state.profileData,
            ),
          );
        },
        (List<BlogModel> blogs) async {
          emit(
            ProfileGetMyBlogsSuccessState(
              blogs: blogs,
              profileApiState: state.profileApiState,
              profileData: state.profileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get my blogs: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileGetMyBlogsFailureState(
          profileApiState: state.profileApiState,
          errorMessage: 'An unexpected error occurred. Please try again.',
          profileData: state.profileData,
        ),
      );
    }
  }

  /// Handle get saved blogs request
  Future<void> _onGetSavedBlogsRequested(
    ProfileGetSavedBlogsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileGetSavedBlogsLoadingState(
        profileApiState: state.profileApiState,
        profileData: state.profileData,
      ),
    );

    try {
      final result = await _profileRemoteRepository.getSavedBlogs(
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get Saved Blogs failed: ${failure.message}');
          emit(
            ProfileGetSavedBlogsFailureState(
              errorMessage: failure.message,
              profileApiState: state.profileApiState,
              profileData: state.profileData,
            ),
          );
        },
        (List<BlogModel> blogs) async {
          emit(
            ProfileGetSavedBlogsSuccessState(
              blogs: blogs,
              profileApiState: state.profileApiState,
              profileData: state.profileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get saved blogs: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileGetSavedBlogsFailureState(
          profileApiState: state.profileApiState,
          profileData: state.profileData,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle save blog request
  Future<void> _onSaveBlogRequested(
    ProfileSaveBlogEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isSaved: true);
      }
      return blog;
    }).toList();
    emit(
      ProfileSaveLoadingState(
        blogs: updatedBlogs,
        profileData: state.profileData,
      ),
    );

    try {
      final result = await _profileRemoteRepository.saveBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Save Blog failed: ${failure.message}');
          emit(
            ProfileSaveFailureState(
              errorMessage: failure.message,
              blogs: updatedBlogs,
              profileData: state.profileData,
            ),
          );
        },
        (_) async {
          emit(
            ProfileSaveSuccessState(
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during save blog: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileSaveFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }

  /// Handle unsave blog request
  Future<void> _onUnsaveBlogRequested(
    ProfileUnsaveBlogEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isSaved: false);
      }
      return blog;
    }).toList();
    emit(
      ProfileUnsaveLoadingState(
        blogs: updatedBlogs,
        profileData: state.profileData,
      ),
    );

    try {
      final result = await _profileRemoteRepository.unsaveBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unsave Blog failed: ${failure.message}');
          emit(
            ProfileUnsaveFailureState(
              errorMessage: failure.message,
              blogs: updatedBlogs,
              profileData: state.profileData,
            ),
          );
        },
        (_) async {
          emit(
            ProfileUnsaveSuccessState(
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during unsave blog: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileUnsaveFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }

  /// Handle upvote blog request
  Future<void> _onUpvoteBlogRequested(
    ProfileUpvoteBlogEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isLiked: true, voteCount: blog.voteCount + 1);
      }
      return blog;
    }).toList();
    emit(
      ProfileUpvoteLoadingState(
        blogs: updatedBlogs,
        profileData: state.profileData,
      ),
    );

    try {
      final result = await _profileRemoteRepository.upvoteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Upvote Blog failed: ${failure.message}');
          emit(
            ProfileUpvoteFailureState(
              errorMessage: failure.message,
              blogs: updatedBlogs,
              profileData: state.profileData,
            ),
          );
        },
        (_) async {
          emit(
            ProfileUpvoteSuccessState(
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during upvote blog: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileUpvoteFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }

  /// Handle unupvote blog request
  Future<void> _onUnupvoteBlogRequested(
    ProfileUnupvoteBlogEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isLiked: false, voteCount: blog.voteCount - 1);
      }
      return blog;
    }).toList();
    emit(
      ProfileUnupvoteLoadingState(
        blogs: updatedBlogs,
        profileData: state.profileData,
      ),
    );

    try {
      final result = await _profileRemoteRepository.unupvoteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unupvote Blog failed: ${failure.message}');
          emit(
            ProfileUnupvoteFailureState(
              errorMessage: failure.message,
              blogs: updatedBlogs,
              profileData: state.profileData,
            ),
          );
        },
        (_) async {
          emit(
            ProfileUnupvoteSuccessState(
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during unupvote blog: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileUnupvoteFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }
}
