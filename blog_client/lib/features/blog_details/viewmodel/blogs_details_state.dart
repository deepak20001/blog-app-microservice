part of 'blogs_details_bloc.dart';

sealed class BlogDetailsState extends Equatable {
  const BlogDetailsState({this.blog = const BlogModel()});
  final BlogModel blog;

  @override
  List<Object?> get props => [blog];
}

class BlogDetailsInitialState extends BlogDetailsState {
  const BlogDetailsInitialState() : super();
}

// Blog Details Fetch States
class BlogDetailsFetchLoadingState extends BlogDetailsState {
  const BlogDetailsFetchLoadingState();
}

class BlogDetailsFetchSuccessState extends BlogDetailsState {
  const BlogDetailsFetchSuccessState({required super.blog});
}

class BlogDetailsFetchFailureState extends BlogDetailsState {
  const BlogDetailsFetchFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Save Blog States
class BlogDetailsSaveBlogLoadingState extends BlogDetailsState {
  const BlogDetailsSaveBlogLoadingState({required super.blog});
}

class BlogDetailsSaveBlogSuccessState extends BlogDetailsState {
  const BlogDetailsSaveBlogSuccessState({required super.blog});
}

class BlogDetailsSaveBlogFailureState extends BlogDetailsState {
  const BlogDetailsSaveBlogFailureState({
    required super.blog,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog];
}

// Unsave Blog States
class BlogDetailsUnsaveBlogLoadingState extends BlogDetailsState {
  const BlogDetailsUnsaveBlogLoadingState({required super.blog});
}

class BlogDetailsUnsaveBlogSuccessState extends BlogDetailsState {
  const BlogDetailsUnsaveBlogSuccessState({required super.blog});
}

class BlogDetailsUnsaveBlogFailureState extends BlogDetailsState {
  const BlogDetailsUnsaveBlogFailureState({
    required super.blog,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog];
}

// Upvote Blog States
class BlogDetailsUpvoteBlogLoadingState extends BlogDetailsState {
  const BlogDetailsUpvoteBlogLoadingState({required super.blog});
}

class BlogDetailsUpvoteBlogSuccessState extends BlogDetailsState {
  const BlogDetailsUpvoteBlogSuccessState({required super.blog});
}

class BlogDetailsUpvoteBlogFailureState extends BlogDetailsState {
  const BlogDetailsUpvoteBlogFailureState({
    required super.blog,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog];
}

// Unupvote Blog States
class BlogDetailsUnupvoteBlogLoadingState extends BlogDetailsState {
  const BlogDetailsUnupvoteBlogLoadingState({required super.blog});
}

class BlogDetailsUnupvoteBlogSuccessState extends BlogDetailsState {
  const BlogDetailsUnupvoteBlogSuccessState({required super.blog});
}

class BlogDetailsUnupvoteBlogFailureState extends BlogDetailsState {
  const BlogDetailsUnupvoteBlogFailureState({
    required super.blog,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog];
}
