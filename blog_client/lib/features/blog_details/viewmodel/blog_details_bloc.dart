import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/enums/api_state_enums.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/features/blog_details/models/comment_model.dart';
import 'package:blog_client/features/blog_details/repositories/blog_details_remote_repository.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'blog_details_event.dart';
part 'blog_details_state.dart';

@singleton
class BlogDetailsBloc extends Bloc<BlogDetailsEvent, BlogDetailsState> {
  BlogDetailsBloc({
    required BlogDetailsRemoteRepository blogDetailsRemoteRepository,
    required SharedPreferencesStorageRepository storageRepository,
  }) : _blogDetailsRemoteRepository = blogDetailsRemoteRepository,
       _storageRepository = storageRepository,
       super(const BlogDetailsInitialState()) {
    on<BlogDetailsFetchEvent>(_onBlogDetailsFetchRequested);
    on<BlogDetailsSaveBlogEvent>(_onSaveBlogRequested);
    on<BlogDetailsUnsaveBlogEvent>(_onUnsaveBlogRequested);
    on<BlogDetailsUpvoteBlogEvent>(_onUpvoteBlogRequested);
    on<BlogDetailsUnupvoteBlogEvent>(_onUnupvoteBlogRequested);
    on<BlogDetailsGetCommentsEvent>(_onGetCommentsRequested);
    on<BlogDetailsCreateCommentEvent>(_onCreateCommentRequested);
    on<BlogDetailsUpvoteCommentEvent>(_onUpvoteCommentRequested);
    on<BlogDetailsUnupvoteCommentEvent>(_onUnupvoteCommentRequested);
    on<BlogDetailsDeleteCommentEvent>(_onDeleteCommentRequested);
  }
  final BlogDetailsRemoteRepository _blogDetailsRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;
  int _page = 0;
  int _limit = 10;
  bool allItemsLoaded = false;

  // getters
  String get userProfileImage => _storageRepository.userProfileImage;
  String get userId => _storageRepository.userId;

  // Handle blog details fetch
  Future<void> _onBlogDetailsFetchRequested(
    BlogDetailsFetchEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    emit(
      BlogDetailsFetchLoadingState(
        commentsApiState: state.commentsApiState,
        comments: state.comments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.blogDetails(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Blog details fetch failed: ${failure.message}');
          emit(
            BlogDetailsFetchFailureState(
              errorMessage: failure.message,
              commentsApiState: state.commentsApiState,
              comments: state.comments,
            ),
          );
        },
        (BlogModel blog) async {
          emit(
            BlogDetailsFetchSuccessState(
              blog: blog,
              commentsApiState: state.commentsApiState,
              comments: state.comments,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during blog details fetch: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogDetailsFetchFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          commentsApiState: state.commentsApiState,
          comments: state.comments,
        ),
      );
    }
  }

  /// Handle save blog
  Future<void> _onSaveBlogRequested(
    BlogDetailsSaveBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(isSaved: true);
    emit(
      BlogDetailsSaveBlogLoadingState(
        blog: updatedBlog,
        comments: state.comments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.saveBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Save Blog failed: ${failure.message}');
          emit(
            BlogDetailsSaveBlogFailureState(
              errorMessage: failure.message,
              blog: updatedBlog,
              comments: state.comments,
            ),
          );
        },
        (_) async {
          getIt<BlogsBloc>().add(
            BlogsUpdateSaveEvent(blogId: event.blogId, isSaved: true),
          );
          emit(
            BlogDetailsSaveBlogSuccessState(
              blog: updatedBlog,
              comments: state.comments,
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
        BlogDetailsSaveBlogFailureState(
          blog: updatedBlog,
          errorMessage: 'An unexpected error occurred. Please try again.',
          comments: state.comments,
        ),
      );
    }
  }

  /// Handle unsave blog
  Future<void> _onUnsaveBlogRequested(
    BlogDetailsUnsaveBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(isSaved: false);
    emit(
      BlogDetailsUnsaveBlogLoadingState(
        blog: updatedBlog,
        comments: state.comments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.unsaveBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unsave Blog failed: ${failure.message}');
          emit(
            BlogDetailsUnsaveBlogFailureState(
              errorMessage: failure.message,
              blog: updatedBlog,
              comments: state.comments,
            ),
          );
        },
        (_) async {
          getIt<BlogsBloc>().add(
            BlogsUpdateSaveEvent(blogId: event.blogId, isSaved: false),
          );
          emit(
            BlogDetailsUnsaveBlogSuccessState(
              blog: updatedBlog,
              comments: state.comments,
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
        BlogDetailsUnsaveBlogFailureState(
          blog: updatedBlog,
          errorMessage: 'An unexpected error occurred. Please try again.',
          comments: state.comments,
        ),
      );
    }
  }

  /// Handle upvote blog
  Future<void> _onUpvoteBlogRequested(
    BlogDetailsUpvoteBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(
      isLiked: true,
      voteCount: state.blog.voteCount + 1,
    );
    emit(
      BlogDetailsUpvoteBlogLoadingState(
        blog: updatedBlog,
        comments: state.comments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.upvoteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Upvote Blog failed: ${failure.message}');
          emit(
            BlogDetailsUpvoteBlogFailureState(
              errorMessage: failure.message,
              blog: updatedBlog,
              comments: state.comments,
            ),
          );
        },
        (_) async {
          getIt<BlogsBloc>().add(
            BlogsUpdateLikeEvent(blogId: event.blogId, isLiked: true),
          );
          emit(
            BlogDetailsUpvoteBlogSuccessState(
              blog: updatedBlog,
              comments: state.comments,
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
        BlogDetailsUpvoteBlogFailureState(
          blog: updatedBlog,
          errorMessage: 'An unexpected error occurred. Please try again.',
          comments: state.comments,
        ),
      );
    }
  }

  /// Handle unupvote blog
  Future<void> _onUnupvoteBlogRequested(
    BlogDetailsUnupvoteBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(
      isLiked: false,
      voteCount: state.blog.voteCount - 1,
    );
    emit(
      BlogDetailsUnupvoteBlogLoadingState(
        blog: updatedBlog,
        comments: state.comments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.unupvoteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unupvote Blog failed: ${failure.message}');
          emit(
            BlogDetailsUnupvoteBlogFailureState(
              errorMessage: failure.message,
              blog: updatedBlog,
              comments: state.comments,
            ),
          );
        },
        (_) async {
          getIt<BlogsBloc>().add(
            BlogsUpdateLikeEvent(blogId: event.blogId, isLiked: false),
          );
          emit(
            BlogDetailsUnupvoteBlogSuccessState(
              blog: updatedBlog,
              comments: state.comments,
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
        BlogDetailsUnupvoteBlogFailureState(
          blog: updatedBlog,
          errorMessage: 'An unexpected error occurred. Please try again.',
          comments: state.comments,
        ),
      );
    }
  }

  /// Handle get comments
  Future<void> _onGetCommentsRequested(
    BlogDetailsGetCommentsEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    if (!event.isLoadMore) {
      _page = 0;
      allItemsLoaded = false;
    }
    if (allItemsLoaded) {
      return;
    }
    _page++;
    if (state.commentsApiState == ApiStateEnums.loading) {
      return;
    }
    emit(
      BlogDetailsGetCommentsLoadingState(
        blog: state.blog,
        blogDetailsApiState: state.blogDetailsApiState,
        comments: state.comments,
        isLoadingMore: event.isLoadMore,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.getComments(
        blogId: event.blogId,
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Unupvote Blog failed: ${failure.message}');
          emit(
            BlogDetailsGetCommentsFailureState(
              errorMessage: failure.message,
              blogDetailsApiState: state.blogDetailsApiState,
              blog: state.blog,
              comments: state.comments,
            ),
          );
        },
        (List<CommentModel> comments) async {
          if (comments.isEmpty || comments.length < _limit) {
            allItemsLoaded = true;
          }
          final updatedComments = event.isLoadMore
              ? [...state.comments, ...comments]
              : comments;
          emit(
            BlogDetailsGetCommentsSuccessState(
              blog: state.blog,
              blogDetailsApiState: state.blogDetailsApiState,
              comments: updatedComments,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get comments: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogDetailsGetCommentsFailureState(
          blog: state.blog,
          blogDetailsApiState: state.blogDetailsApiState,
          comments: state.comments,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle create comment
  Future<void> _onCreateCommentRequested(
    BlogDetailsCreateCommentEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    if (state is BlogDetailsCreateCommentLoadingState) {
      return;
    }

    final commentId = DateTime.now().millisecondsSinceEpoch;
    final updatedComments = [
      CommentModel(
        id: commentId,
        comment: event.comment,
        userId: _storageRepository.userId,
        blogId: event.blogId,
        createdAt: DateTime.now().toIso8601String(),
        voteCount: 0,
        isVoted: false,
        author: ProfileModel(
          id: _storageRepository.userId,
          username: _storageRepository.userName,
          avatar: _storageRepository.userProfileImage,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      ),
      ...state.comments,
    ];
    emit(
      BlogDetailsCreateCommentLoadingState(
        blog: state.blog,
        comments: updatedComments,
        successMessage: 'Comment created successfully',
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.createComment(
        blogId: event.blogId,
        comment: event.comment,
      );

      await result.fold(
        (failure) {
          devtools.log('Create Comment failed: ${failure.message}');
          emit(
            BlogDetailsCreateCommentFailureState(
              errorMessage: failure.message,
              comments: state.comments,
              blog: state.blog,
            ),
          );
        },
        (CommentModel comment) async {
          final updatedComment = state.comments.first.copyWith(
            id: comment.id,
            createdAt: comment.createdAt,
            voteCount: comment.voteCount,
            isVoted: comment.isVoted,
          );
          final updatedComments = [
            updatedComment,
            ...state.comments.skip(1).toList(),
          ];
          emit(
            BlogDetailsCreateCommentSuccessState(
              blog: state.blog,
              comments: updatedComments.toList(),
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during create comment: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogDetailsCreateCommentFailureState(
          blog: state.blog,
          comments: state.comments,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle delete comment
  Future<void> _onDeleteCommentRequested(
    BlogDetailsDeleteCommentEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    emit(
      BlogDetailsDeleteCommentLoadingState(
        blog: state.blog,
        comments: state.comments,
        commentId: event.commentId,
      ),
    );
    try {
      final result = await _blogDetailsRemoteRepository.deleteComment(
        blogId: event.blogId,
        commentId: event.commentId,
      );

      await result.fold(
        (failure) {
          devtools.log('Delete Comment failed: ${failure.message}');
          emit(
            BlogDetailsDeleteCommentFailureState(
              errorMessage: failure.message,
              comments: state.comments,
              blog: state.blog,
            ),
          );
        },
        (final successMessage) async {
          final updatedComments = state.comments
              .where((comment) => comment.id != event.commentId)
              .toList();
          emit(
            BlogDetailsDeleteCommentSuccessState(
              blog: state.blog,
              comments: updatedComments,
              successMessage: successMessage,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during create comment: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogDetailsCreateCommentFailureState(
          blog: state.blog,
          comments: state.comments,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle upvote comment
  Future<void> _onUpvoteCommentRequested(
    BlogDetailsUpvoteCommentEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    if (state is BlogDetailsUpvoteCommentLoadingState) {
      return;
    }

    final updatedComments = state.comments.map((comment) {
      if (comment.id == event.commentId) {
        return comment.copyWith(
          isVoted: true,
          voteCount: comment.voteCount + 1,
        );
      }
      return comment;
    }).toList();
    emit(
      BlogDetailsUpvoteCommentLoadingState(
        blog: state.blog,
        comments: updatedComments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.upvoteComment(
        blogId: event.blogId,
        commentId: event.commentId,
      );

      await result.fold(
        (failure) {
          devtools.log('Upvote Comment failed: ${failure.message}');
          emit(
            BlogDetailsUpvoteCommentFailureState(
              errorMessage: failure.message,
              comments: state.comments,
              blog: state.blog,
            ),
          );
        },
        (_) async {
          emit(
            BlogDetailsUpvoteCommentSuccessState(
              blog: state.blog,
              comments: state.comments,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during upvote comment: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogDetailsUpvoteCommentFailureState(
          blog: state.blog,
          comments: state.comments,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle unupvote comment
  Future<void> _onUnupvoteCommentRequested(
    BlogDetailsUnupvoteCommentEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedComments = state.comments.map((comment) {
      if (comment.id == event.commentId) {
        return comment.copyWith(
          isVoted: false,
          voteCount: comment.voteCount - 1,
        );
      }
      return comment;
    }).toList();
    emit(
      BlogDetailsUnupvoteCommentLoadingState(
        blog: state.blog,
        comments: updatedComments,
      ),
    );

    try {
      final result = await _blogDetailsRemoteRepository.unupvoteComment(
        blogId: event.blogId,
        commentId: event.commentId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unupvote Comment failed: ${failure.message}');
          emit(
            BlogDetailsUnupvoteCommentFailureState(
              errorMessage: failure.message,
              comments: state.comments,
              blog: state.blog,
            ),
          );
        },
        (_) async {
          emit(
            BlogDetailsUnupvoteCommentSuccessState(
              blog: state.blog,
              comments: state.comments,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during unupvote comment: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogDetailsUnupvoteCommentFailureState(
          blog: state.blog,
          comments: state.comments,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
