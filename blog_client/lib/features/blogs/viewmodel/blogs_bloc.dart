import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/features/blogs/models/category_model.dart';
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
    on<CategoriesFetchEvent>(_onCategoriesFetchRequested);
    on<SaveBlogEvent>(_onSaveBlogRequested);
    on<UnsaveBlogEvent>(_onUnsaveBlogRequested);
    on<UpvoteBlogEvent>(_onUpvoteBlogRequested);
    on<UnupvoteBlogEvent>(_onUnupvoteBlogRequested);
  }
  final BlogsRemoteRepository _blogsRemoteRepository;
  final int _page = 1;
  final int _limit = 10;

  // Handle categories fetch
  Future<void> _onCategoriesFetchRequested(
    CategoriesFetchEvent event,
    Emitter<BlogsState> emit,
  ) async {
    emit(
      CategoriesFetchLoadingState(
        categories: state.categories,
        blogs: state.blogs,
      ),
    );

    try {
      final result = await _blogsRemoteRepository.categories();

      await result.fold(
        (failure) {
          devtools.log('Categories fetch failed: ${failure.message}');
          emit(
            CategoriesFetchFailureState(
              errorMessage: failure.message,
              categories: state.categories,
              blogs: state.blogs,
            ),
          );
        },
        (data) async {
          final categories = data;
          categories.insert(
            0,
            CategoryModel(id: 0, title: 'All', isSelected: true),
          );
          emit(
            CategoriesFetchSuccessState(
              categories: categories,
              blogs: state.blogs,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during categories fetch: $e',
        stackTrace: stackTrace,
      );
      emit(
        CategoriesFetchFailureState(
          categories: state.categories,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle blogs fetch
  Future<void> _onBlogsFetchRequested(
    BlogsFetchEvent event,
    Emitter<BlogsState> emit,
  ) async {
    final updatedCategories = state.categories.map((category) {
      if (category.id == event.categoryId) {
        return category.copyWith(isSelected: true);
      }
      return category.copyWith(isSelected: false);
    }).toList();
    emit(
      BlogsFetchLoadingState(categories: updatedCategories, blogs: state.blogs),
    );

    try {
      final result = await _blogsRemoteRepository.blogs(
        page: _page,
        limit: _limit,
        categoryId: event.categoryId,
        search: event.search,
      );

      await result.fold(
        (failure) {
          devtools.log('Blogs fetch failed: ${failure.message}');
          emit(
            BlogsFetchFailureState(
              errorMessage: failure.message,
              categories: state.categories,
              blogs: state.blogs,
            ),
          );
        },
        (data) async {
          final blogs = data;
          emit(
            BlogsFetchSuccessState(categories: state.categories, blogs: blogs),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during blogs fetch: $e',
        stackTrace: stackTrace,
      );
      emit(
        BlogsFetchFailureState(
          categories: state.categories,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle save blog
  Future<void> _onSaveBlogRequested(
    SaveBlogEvent event,
    Emitter<BlogsState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isSaved: true);
      }
      return blog;
    }).toList();

    emit(
      SaveBlogLoadingState(categories: state.categories, blogs: updatedBlogs),
    );

    try {
      final result = await _blogsRemoteRepository.saveBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Save Blog failed: ${failure.message}');
          emit(
            SaveBlogFailureState(
              errorMessage: failure.message,
              categories: state.categories,
              blogs: state.blogs,
            ),
          );
        },
        (_) async {
          emit(
            SaveBlogSuccessState(
              categories: state.categories,
              blogs: state.blogs,
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
        SaveBlogFailureState(
          categories: state.categories,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle unsave blog
  Future<void> _onUnsaveBlogRequested(
    UnsaveBlogEvent event,
    Emitter<BlogsState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isSaved: false);
      }
      return blog;
    }).toList();
    emit(
      UnsaveBlogLoadingState(categories: state.categories, blogs: updatedBlogs),
    );

    try {
      final result = await _blogsRemoteRepository.unsaveBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unsave Blog failed: ${failure.message}');
          emit(
            UnsaveBlogFailureState(
              errorMessage: failure.message,
              categories: state.categories,
              blogs: state.blogs,
            ),
          );
        },
        (_) async {
          emit(
            UnsaveBlogSuccessState(
              categories: state.categories,
              blogs: state.blogs,
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
        UnsaveBlogFailureState(
          categories: state.categories,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle upvote blog
  Future<void> _onUpvoteBlogRequested(
    UpvoteBlogEvent event,
    Emitter<BlogsState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isLiked: true, voteCount: blog.voteCount + 1);
      }
      return blog;
    }).toList();
    emit(
      UpvoteBlogLoadingState(categories: state.categories, blogs: updatedBlogs),
    );

    try {
      final result = await _blogsRemoteRepository.upvoteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Upvote Blog failed: ${failure.message}');
          emit(
            UpvoteBlogFailureState(
              errorMessage: failure.message,
              categories: state.categories,
              blogs: state.blogs,
            ),
          );
        },
        (_) async {
          emit(
            UpvoteBlogSuccessState(
              categories: state.categories,
              blogs: state.blogs,
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
        UpvoteBlogFailureState(
          categories: state.categories,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle unupvote blog
  Future<void> _onUnupvoteBlogRequested(
    UnupvoteBlogEvent event,
    Emitter<BlogsState> emit,
  ) async {
    final updatedBlogs = state.blogs.map((blog) {
      if (blog.id == event.blogId) {
        return blog.copyWith(isLiked: false, voteCount: blog.voteCount - 1);
      }
      return blog;
    }).toList();
    emit(
      UnupvoteBlogLoadingState(
        categories: state.categories,
        blogs: updatedBlogs,
      ),
    );

    try {
      final result = await _blogsRemoteRepository.unupvoteBlog(
        blogId: event.blogId,
      );

      await result.fold(
        (failure) {
          devtools.log('Unupvote Blog failed: ${failure.message}');
          emit(
            UnupvoteBlogFailureState(
              errorMessage: failure.message,
              categories: state.categories,
              blogs: state.blogs,
            ),
          );
        },
        (_) async {
          emit(
            UnupvoteBlogSuccessState(
              categories: state.categories,
              blogs: state.blogs,
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
        UnupvoteBlogFailureState(
          categories: state.categories,
          blogs: state.blogs,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
