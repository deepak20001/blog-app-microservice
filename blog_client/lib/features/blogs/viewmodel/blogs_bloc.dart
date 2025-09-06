import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/features/blogs/repositories/blogs_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'blogs_event.dart';
part 'blogs_state.dart';

@singleton
class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc({required BlogsRemoteRepository blogsRemoteRepository})
    : _blogsRemoteRepository = blogsRemoteRepository,
      super(const BlogsInitialState()) {
    on<BlogsFetchEvent>(_onBlogsFetchRequested);
  }
  final BlogsRemoteRepository _blogsRemoteRepository;

  /// Handle blogs fetch
  Future<void> _onBlogsFetchRequested(
    BlogsFetchEvent event,
    Emitter<BlogsState> emit,
  ) async {
    emit(const BlogsFetchLoadingState());

    try {
      final result = await _blogsRemoteRepository.blogs();

      await result.fold(
        (failure) {
          devtools.log('Blogs fetch failed: ${failure.message}');
          emit(BlogsFetchFailureState(errorMessage: failure.message));
        },
        (data) async {
          final blogs = data;
          emit(BlogsFetchSuccessState(blogs: blogs));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during blogs fetch: $e',
        stackTrace: stackTrace,
      );
      emit(
        const BlogsFetchFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
