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
class BlogsCategoriesFetchLoadingState extends BlogsState {
  const BlogsCategoriesFetchLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsCategoriesFetchSuccessState extends BlogsState {
  const BlogsCategoriesFetchSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsCategoriesFetchFailureState extends BlogsState {
  const BlogsCategoriesFetchFailureState({
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
class BlogsSaveLoadingState extends BlogsState {
  const BlogsSaveLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsSaveSuccessState extends BlogsState {
  const BlogsSaveSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsSaveFailureState extends BlogsState {
  const BlogsSaveFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Unsave Blog States
class BlogsUnsaveLoadingState extends BlogsState {
  const BlogsUnsaveLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsUnsaveSuccessState extends BlogsState {
  const BlogsUnsaveSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsUnsaveFailureState extends BlogsState {
  const BlogsUnsaveFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Upvote Blog States
class BlogsUpvoteLoadingState extends BlogsState {
  const BlogsUpvoteLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsUpvoteSuccessState extends BlogsState {
  const BlogsUpvoteSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsUpvoteFailureState extends BlogsState {
  const BlogsUpvoteFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}

// Unupvote Blog States
class BlogsUnupvoteLoadingState extends BlogsState {
  const BlogsUnupvoteLoadingState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsUnupvoteSuccessState extends BlogsState {
  const BlogsUnupvoteSuccessState({
    required super.categories,
    required super.blogs,
  });
}

class BlogsUnupvoteFailureState extends BlogsState {
  const BlogsUnupvoteFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs];
}
