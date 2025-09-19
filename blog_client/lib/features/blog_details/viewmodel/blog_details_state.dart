part of 'blog_details_bloc.dart';

sealed class BlogDetailsState extends Equatable {
  const BlogDetailsState({
    this.blog = const BlogModel(),
    this.comments = const <CommentModel>[],
    this.blogDetailsApiState = ApiStateEnums.initial,
    this.commentsApiState = ApiStateEnums.initial,
    this.isLoadingMore = false,
  });
  final BlogModel blog;
  final List<CommentModel> comments;
  final ApiStateEnums blogDetailsApiState;
  final ApiStateEnums commentsApiState;
  final bool isLoadingMore;

  @override
  List<Object?> get props => [
    blog,
    comments,
    blogDetailsApiState,
    commentsApiState,
    isLoadingMore,
  ];
}

class BlogDetailsInitialState extends BlogDetailsState {
  const BlogDetailsInitialState() : super();
}

// Blog Details Fetch States
class BlogDetailsFetchLoadingState extends BlogDetailsState {
  const BlogDetailsFetchLoadingState({
    required super.commentsApiState,
    super.blogDetailsApiState = ApiStateEnums.loading,
    required super.comments,
  });
}

class BlogDetailsFetchSuccessState extends BlogDetailsState {
  const BlogDetailsFetchSuccessState({
    required super.blog,
    super.blogDetailsApiState = ApiStateEnums.success,
    required super.commentsApiState,
    required super.comments,
  });
}

class BlogDetailsFetchFailureState extends BlogDetailsState {
  const BlogDetailsFetchFailureState({
    required this.errorMessage,
    required super.commentsApiState,
    super.blogDetailsApiState = ApiStateEnums.failure,
    required super.comments,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [
    errorMessage,
    comments,
    blogDetailsApiState,
    commentsApiState,
  ];
}

// Save Blog States
class BlogDetailsSaveBlogLoadingState extends BlogDetailsState {
  const BlogDetailsSaveBlogLoadingState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsSaveBlogSuccessState extends BlogDetailsState {
  const BlogDetailsSaveBlogSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsSaveBlogFailureState extends BlogDetailsState {
  const BlogDetailsSaveBlogFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Unsave Blog States
class BlogDetailsUnsaveBlogLoadingState extends BlogDetailsState {
  const BlogDetailsUnsaveBlogLoadingState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUnsaveBlogSuccessState extends BlogDetailsState {
  const BlogDetailsUnsaveBlogSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUnsaveBlogFailureState extends BlogDetailsState {
  const BlogDetailsUnsaveBlogFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Upvote Blog States
class BlogDetailsUpvoteBlogLoadingState extends BlogDetailsState {
  const BlogDetailsUpvoteBlogLoadingState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUpvoteBlogSuccessState extends BlogDetailsState {
  const BlogDetailsUpvoteBlogSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUpvoteBlogFailureState extends BlogDetailsState {
  const BlogDetailsUpvoteBlogFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Unupvote Blog States
class BlogDetailsUnupvoteBlogLoadingState extends BlogDetailsState {
  const BlogDetailsUnupvoteBlogLoadingState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUnupvoteBlogSuccessState extends BlogDetailsState {
  const BlogDetailsUnupvoteBlogSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUnupvoteBlogFailureState extends BlogDetailsState {
  const BlogDetailsUnupvoteBlogFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Get Comments States
class BlogDetailsGetCommentsLoadingState extends BlogDetailsState {
  const BlogDetailsGetCommentsLoadingState({
    required super.blog,
    super.commentsApiState = ApiStateEnums.loading,
    required super.blogDetailsApiState,
    super.isLoadingMore,
    required super.comments,
  });
}

class BlogDetailsGetCommentsSuccessState extends BlogDetailsState {
  const BlogDetailsGetCommentsSuccessState({
    required super.blog,
    super.commentsApiState = ApiStateEnums.success,
    required super.blogDetailsApiState,
    required super.comments,
    super.isLoadingMore,
  });
}

class BlogDetailsGetCommentsFailureState extends BlogDetailsState {
  const BlogDetailsGetCommentsFailureState({
    required super.blog,
    required this.errorMessage,
    super.commentsApiState = ApiStateEnums.failure,
    required super.blogDetailsApiState,
    super.isLoadingMore,
    required super.comments,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [
    errorMessage,
    blog,
    blogDetailsApiState,
    commentsApiState,
    comments,
    isLoadingMore,
  ];
}

// Create Comment States
class BlogDetailsCreateCommentLoadingState extends BlogDetailsState {
  const BlogDetailsCreateCommentLoadingState({
    required super.blog,
    required super.comments,
    required this.successMessage,
  });
  final String successMessage;

  @override
  List<Object?> get props => [successMessage, blog, comments];
}

class BlogDetailsCreateCommentSuccessState extends BlogDetailsState {
  const BlogDetailsCreateCommentSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsCreateCommentFailureState extends BlogDetailsState {
  const BlogDetailsCreateCommentFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Upvote Comment States
class BlogDetailsUpvoteCommentLoadingState extends BlogDetailsState {
  const BlogDetailsUpvoteCommentLoadingState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUpvoteCommentSuccessState extends BlogDetailsState {
  const BlogDetailsUpvoteCommentSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUpvoteCommentFailureState extends BlogDetailsState {
  const BlogDetailsUpvoteCommentFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Unupvote Comment States
class BlogDetailsUnupvoteCommentLoadingState extends BlogDetailsState {
  const BlogDetailsUnupvoteCommentLoadingState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUnupvoteCommentSuccessState extends BlogDetailsState {
  const BlogDetailsUnupvoteCommentSuccessState({
    required super.blog,
    required super.comments,
  });
}

class BlogDetailsUnupvoteCommentFailureState extends BlogDetailsState {
  const BlogDetailsUnupvoteCommentFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}

// Delete Comment States
class BlogDetailsDeleteCommentLoadingState extends BlogDetailsState {
  const BlogDetailsDeleteCommentLoadingState({
    required super.blog,
    required super.comments,
    required this.commentId,
  });
  final int commentId;

  @override
  List<Object?> get props => [commentId, blog, comments];
}

class BlogDetailsDeleteCommentSuccessState extends BlogDetailsState {
  const BlogDetailsDeleteCommentSuccessState({
    required super.blog,
    required super.comments,
    required this.successMessage,
  });
  final String successMessage;

  @override
  List<Object?> get props => [successMessage, blog, comments];
}

class BlogDetailsDeleteCommentFailureState extends BlogDetailsState {
  const BlogDetailsDeleteCommentFailureState({
    required super.blog,
    required super.comments,
    required this.errorMessage,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, blog, comments];
}
