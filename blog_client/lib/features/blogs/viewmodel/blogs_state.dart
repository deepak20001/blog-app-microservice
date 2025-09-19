part of 'blogs_bloc.dart';

sealed class BlogsState extends Equatable {
  const BlogsState({
    this.blogs = const <BlogModel>[],
    this.categories = const <CategoryModel>[],
    this.blogsApiState = ApiStateEnums.initial,
    this.isLoadingMore = false,
  });
  final List<BlogModel> blogs;
  final List<CategoryModel> categories;
  final ApiStateEnums blogsApiState;
  final bool isLoadingMore;

  @override
  List<Object?> get props => [blogs, categories, isLoadingMore, blogsApiState];
}

class BlogsInitialState extends BlogsState {
  const BlogsInitialState() : super();
}

// Categories Fetch States
class BlogsCategoriesFetchLoadingState extends BlogsState {
  const BlogsCategoriesFetchLoadingState({
    required super.categories,
    required super.blogs,
    required super.blogsApiState,
  });
}

class BlogsCategoriesFetchSuccessState extends BlogsState {
  const BlogsCategoriesFetchSuccessState({
    required super.categories,
    required super.blogs,
    required super.blogsApiState,
  });
}

class BlogsCategoriesFetchFailureState extends BlogsState {
  const BlogsCategoriesFetchFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
    required super.blogsApiState,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, categories, blogs, blogsApiState];
}

// Blogs Fetch States
class BlogsFetchLoadingState extends BlogsState {
  const BlogsFetchLoadingState({
    required super.categories,
    required super.blogs,
    super.isLoadingMore = false,
    super.blogsApiState = ApiStateEnums.loading,
  });
}

class BlogsFetchSuccessState extends BlogsState {
  const BlogsFetchSuccessState({
    required super.categories,
    required super.blogs,
    super.isLoadingMore = false,
    super.blogsApiState = ApiStateEnums.success,
  });

  @override
  List<Object?> get props => [blogs, categories, isLoadingMore, blogsApiState];
}

class BlogsFetchFailureState extends BlogsState {
  const BlogsFetchFailureState({
    required super.categories,
    required super.blogs,
    required this.errorMessage,
    super.isLoadingMore = false,
    super.blogsApiState = ApiStateEnums.failure,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [
    errorMessage,
    categories,
    blogs,
    isLoadingMore,
    blogsApiState,
  ];
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
