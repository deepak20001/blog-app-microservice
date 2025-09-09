part of 'blogs_bloc.dart';

sealed class BlogsState extends Equatable {
  const BlogsState({
    this.blogs = const <BlogModel>[],
    this.categories = const <CategoryModel>[],
  });
  final List<BlogModel> blogs;
  final List<CategoryModel> categories;

  @override
  List<Object?> get props => [blogs, categories];
}

class BlogsInitialState extends BlogsState {
  const BlogsInitialState() : super();
}

// Categories Fetch States
class CategoriesFetchLoadingState extends BlogsState {
  const CategoriesFetchLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class CategoriesFetchSuccessState extends BlogsState {
  const CategoriesFetchSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class CategoriesFetchFailureState extends BlogsState {
  const CategoriesFetchFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Blogs Fetch States
class BlogsFetchLoadingState extends BlogsState {
  const BlogsFetchLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsFetchSuccessState extends BlogsState {
  const BlogsFetchSuccessState({
    required super.categories,
    required super.blogs,
  });

  @override
  List<Object?> get props => [blogs, categories];
}

class BlogsFetchFailureState extends BlogsState {
  const BlogsFetchFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Save Blog States
class SaveBlogLoadingState extends BlogsState {
  const SaveBlogLoadingState({required super.categories, required super.blogs});
}

class SaveBlogSuccessState extends BlogsState {
  const SaveBlogSuccessState({required super.categories, required super.blogs});
}

class SaveBlogFailureState extends BlogsState {
  const SaveBlogFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Unsave Blog States
class UnsaveBlogLoadingState extends BlogsState {
  const UnsaveBlogLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class UnsaveBlogSuccessState extends BlogsState {
  const UnsaveBlogSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class UnsaveBlogFailureState extends BlogsState {
  const UnsaveBlogFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Upvote Blog States
class UpvoteBlogLoadingState extends BlogsState {
  const UpvoteBlogLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class UpvoteBlogSuccessState extends BlogsState {
  const UpvoteBlogSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class UpvoteBlogFailureState extends BlogsState {
  const UpvoteBlogFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Unupvote Blog States
class UnupvoteBlogLoadingState extends BlogsState {
  const UnupvoteBlogLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class UnupvoteBlogSuccessState extends BlogsState {
  const UnupvoteBlogSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class UnupvoteBlogFailureState extends BlogsState {
  const UnupvoteBlogFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}
