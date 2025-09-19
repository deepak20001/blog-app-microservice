import 'dart:core';
import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/enums/api_state_enums.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:blog_client/features/profile/repositories/profile_remote_repository.dart';
import 'package:blog_client/injection_container.dart';
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
    on<ProfileGetUpdatedDataFromLocalStorageEvent>(
      _onGetUpdatedDataFromLocalStorageRequested,
    );
    on<ProfileGetUserProfileEvent>(_onGetUserProfileRequested);
    on<ProfileGetMyBlogsEvent>(_onGetMyBlogsRequested);
    on<ProfileGetSavedBlogsEvent>(_onGetSavedBlogsRequested);
    on<ProfileSaveBlogEvent>(_onSaveBlogRequested);
    on<ProfileUnsaveBlogEvent>(_onUnsaveBlogRequested);
    on<ProfileUpvoteBlogEvent>(_onUpvoteBlogRequested);
    on<ProfileUnupvoteBlogEvent>(_onUnupvoteBlogRequested);
    on<ProfileLogoutEvent>(_onLogoutRequested);
    on<ProfileFollowProfileEvent>(_onFollowProfileRequested);
    on<ProfileUnfollowProfileEvent>(_onUnfollowProfileRequested);
    on<ProfileUpdateFollowFollowingsDataEvent>(
      _onUpdateFollowFollowingsDataRequested,
    );
    on<ProfileDeleteBlogEvent>(_onDeleteBlogRequested);
  }
  final ProfileRemoteRepository _profileRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;
  int _page = 1;
  int _limit = 5;
  bool allItemsLoaded = false;

  // getters
  String get userProfileImage => _storageRepository.userProfileImage;
  String get userName => _storageRepository.userName;
  String get userBio => _storageRepository.userBio;
  String get userId => _storageRepository.userId;

  // Handle get updated data from local storage
  Future<void> _onGetUpdatedDataFromLocalStorageRequested(
    ProfileGetUpdatedDataFromLocalStorageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    _storageRepository.userProfileImage = userProfileImage;
    _storageRepository.userName = userName;
    _storageRepository.userBio = userBio;

    final updatedProfileData = state.profileData.copyWith(
      avatar: userProfileImage,
      username: userName,
      bio: userBio,
    );

    emit(
      ProfileGetUserProfileSuccessState(
        blogs: state.blogs,
        blogsApiState: state.blogsApiState,
        profileData: updatedProfileData,
      ),
    );
  }

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
    if (!event.isLoadMore) {
      _page = 0;
      allItemsLoaded = false;
    }
    if (allItemsLoaded) {
      return;
    }
    _page++;

    emit(
      ProfileGetMyBlogsLoadingState(
        blogs: state.blogs,
        profileApiState: state.profileApiState,
        profileData: state.profileData,
        isLoadingMore: event.isLoadMore,
      ),
    );

    try {
      final result = await _profileRemoteRepository.getMyBlogs(
        id: event.id.isNotEmpty ? event.id : _storageRepository.userId,
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get My Blogs failed: ${failure.message}');
          emit(
            ProfileGetMyBlogsFailureState(
              errorMessage: failure.message,
              blogs: state.blogs,
              profileApiState: state.profileApiState,
              profileData: state.profileData,
            ),
          );
        },
        (List<BlogModel> blogs) async {
          if (blogs.isEmpty || blogs.length < _limit) {
            allItemsLoaded = true;
          }
          final updatedBlogs = event.isLoadMore
              ? [...state.blogs, ...blogs]
              : blogs;
          emit(
            ProfileGetMyBlogsSuccessState(
              blogs: updatedBlogs,
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
          blogs: state.blogs,
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
    if (!event.isLoadMore) {
      _page = 0;
      allItemsLoaded = false;
    }
    if (allItemsLoaded) {
      return;
    }
    _page++;

    emit(
      ProfileGetSavedBlogsLoadingState(
        blogs: state.blogs,
        profileApiState: state.profileApiState,
        profileData: state.profileData,
        isLoadingMore: event.isLoadMore,
      ),
    );

    try {
      final result = await _profileRemoteRepository.getSavedBlogs(
        id: event.id.isNotEmpty ? event.id : _storageRepository.userId,
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get Saved Blogs failed: ${failure.message}');
          emit(
            ProfileGetSavedBlogsFailureState(
              errorMessage: failure.message,
              blogs: state.blogs,
              profileApiState: state.profileApiState,
              profileData: state.profileData,
            ),
          );
        },
        (List<BlogModel> blogs) async {
          if (blogs.isEmpty || blogs.length < _limit) {
            allItemsLoaded = true;
          }
          final updatedBlogs = event.isLoadMore
              ? [...state.blogs, ...blogs]
              : blogs;
          devtools.log('updatedBlogs: $updatedBlogs');
          emit(
            ProfileGetSavedBlogsSuccessState(
              blogs: updatedBlogs,
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
          blogs: state.blogs,
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
          getIt<BlogsBloc>().add(
            BlogsUpdateSaveEvent(blogId: event.blogId, isSaved: true),
          );
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
          getIt<BlogsBloc>().add(
            BlogsUpdateSaveEvent(blogId: event.blogId, isSaved: false),
          );
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
          getIt<BlogsBloc>().add(
            BlogsUpdateLikeEvent(blogId: event.blogId, isLiked: true),
          );
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
          getIt<BlogsBloc>().add(
            BlogsUpdateLikeEvent(blogId: event.blogId, isLiked: false),
          );
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

  /// Handle logout request
  Future<void> _onLogoutRequested(
    ProfileLogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _storageRepository.clearUserData();
    emit(
      ProfileLogoutState(profileData: state.profileData, blogs: state.blogs),
    );
  }

  // Handle follow profile request
  Future<void> _onFollowProfileRequested(
    ProfileFollowProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedProfileData = state.profileData.copyWith(isFollowing: true);
    emit(
      ProfileFollowProfileLoadingState(
        profileData: updatedProfileData,
        blogs: state.blogs,
      ),
    );

    try {
      final result = await _profileRemoteRepository.followProfile(id: event.id);

      await result.fold(
        (failure) {
          devtools.log('Follow Profile failed: ${failure.message}');
          emit(
            ProfileFollowProfileFailureState(
              errorMessage: failure.message,
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
        (_) async {
          final updatedProfileData = state.profileData.copyWith(
            followersCount: state.profileData.followersCount + 1,
          );
          emit(
            ProfileFollowProfileSuccessState(
              blogs: state.blogs,
              profileData: updatedProfileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during follow profile: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileFollowProfileFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }

  // Handle unfollow profile request
  Future<void> _onUnfollowProfileRequested(
    ProfileUnfollowProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedProfileData = state.profileData.copyWith(isFollowing: false);
    emit(
      ProfileUnfollowProfileLoadingState(
        profileData: updatedProfileData,
        blogs: state.blogs,
      ),
    );

    try {
      final result = await _profileRemoteRepository.unfollowProfile(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Unfollow Profile failed: ${failure.message}');
          emit(
            ProfileUnfollowProfileFailureState(
              errorMessage: failure.message,
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
        (_) async {
          final updatedProfileData = state.profileData.copyWith(
            followersCount: state.profileData.followersCount - 1,
          );
          emit(
            ProfileUnfollowProfileSuccessState(
              blogs: state.blogs,
              profileData: updatedProfileData,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during unfollow profile: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileUnfollowProfileFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }

  // Handle update follow-followings data request
  Future<void> _onUpdateFollowFollowingsDataRequested(
    ProfileUpdateFollowFollowingsDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final updatedProfileData = state.profileData.copyWith(
      followingsCount: event.isFollowing
          ? state.profileData.followingsCount + 1
          : state.profileData.followingsCount - 1,
    );
    emit(
      ProfileGetUserProfileSuccessState(
        profileData: updatedProfileData,
        blogsApiState: state.blogsApiState,
        blogs: state.blogs,
      ),
    );
  }

  // Handle delete blog request
  Future<void> _onDeleteBlogRequested(
    ProfileDeleteBlogEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      ProfileDeleteBlogLoadingState(
        profileData: state.profileData,
        blogId: event.blogId,
        blogs: state.blogs,
      ),
    );

    try {
      final result = await _profileRemoteRepository.deleteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Delete Blog failed: ${failure.message}');
          emit(
            ProfileDeleteBlogFailureState(
              errorMessage: failure.message,
              blogs: state.blogs,
              profileData: state.profileData,
            ),
          );
        },
        (String successMessage) async {
          final updatedBlogs = state.blogs
              .where((blog) => blog.id != event.blogId)
              .toList();

          emit(
            ProfileDeleteBlogSuccessState(
              blogs: updatedBlogs,
              profileData: state.profileData,
              successMessage: successMessage,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during delete blog: $e',
        stackTrace: stackTrace,
      );
      emit(
        ProfileDeleteBlogFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          blogs: state.blogs,
          profileData: state.profileData,
        ),
      );
    }
  }
}
