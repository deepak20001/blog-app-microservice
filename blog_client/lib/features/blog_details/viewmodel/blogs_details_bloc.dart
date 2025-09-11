import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/features/blog_details/repositories/blog_details_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'blog_details_event.dart';
part 'blogs_details_state.dart';

@singleton
class BlogDetailsBloc extends Bloc<BlogDetailsEvent, BlogDetailsState> {
  BlogDetailsBloc({
    required BlogDetailsRemoteRepository blogDetailsRemoteRepository,
  }) : _blogDetailsRemoteRepository = blogDetailsRemoteRepository,
       super(const BlogDetailsInitialState()) {
    on<BlogDetailsFetchEvent>(_onBlogDetailsFetchRequested);
    on<SaveBlogEvent>(_onSaveBlogRequested);
    on<UnsaveBlogEvent>(_onUnsaveBlogRequested);
    on<UpvoteBlogEvent>(_onUpvoteBlogRequested);
    on<UnupvoteBlogEvent>(_onUnupvoteBlogRequested);
  }
  final BlogDetailsRemoteRepository _blogDetailsRemoteRepository;

  // Handle blog details fetch
  Future<void> _onBlogDetailsFetchRequested(
    BlogDetailsFetchEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    emit(BlogDetailsFetchLoadingState());

    try {
      final result = await _blogDetailsRemoteRepository.blogDetails(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Blog details fetch failed: ${failure.message}');
          emit(BlogDetailsFetchFailureState(errorMessage: failure.message));
        },
        (BlogModel blog) async {
          emit(BlogDetailsFetchSuccessState(blog: blog));
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
        ),
      );
    }
  }

  /// Handle save blog
  Future<void> _onSaveBlogRequested(
    SaveBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(isSaved: true);
    emit(BlogDetailsSaveBlogLoadingState(blog: updatedBlog));

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
            ),
          );
        },
        (_) async {
          emit(BlogDetailsSaveBlogSuccessState(blog: updatedBlog));
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
        ),
      );
    }
  }

  /// Handle unsave blog
  Future<void> _onUnsaveBlogRequested(
    UnsaveBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(isSaved: false);
    emit(BlogDetailsUnsaveBlogLoadingState(blog: updatedBlog));

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
            ),
          );
        },
        (_) async {
          emit(BlogDetailsUnsaveBlogSuccessState(blog: updatedBlog));
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
        ),
      );
    }
  }

  /// Handle upvote blog
  Future<void> _onUpvoteBlogRequested(
    UpvoteBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(
      isLiked: true,
      voteCount: state.blog.voteCount + 1,
    );
    emit(BlogDetailsUpvoteBlogLoadingState(blog: updatedBlog));

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
            ),
          );
        },
        (_) async {
          emit(BlogDetailsUpvoteBlogSuccessState(blog: updatedBlog));
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
        ),
      );
    }
  }

  /// Handle unupvote blog
  Future<void> _onUnupvoteBlogRequested(
    UnupvoteBlogEvent event,
    Emitter<BlogDetailsState> emit,
  ) async {
    final updatedBlog = state.blog.copyWith(
      isLiked: false,
      voteCount: state.blog.voteCount - 1,
    );
    emit(BlogDetailsUnupvoteBlogLoadingState(blog: updatedBlog));

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
            ),
          );
        },
        (_) async {
          emit(BlogDetailsUnupvoteBlogSuccessState(blog: updatedBlog));
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
        ),
      );
    }
  }
}
