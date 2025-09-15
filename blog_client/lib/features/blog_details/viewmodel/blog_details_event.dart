part of 'blogs_details_bloc.dart';

abstract class BlogDetailsEvent extends Equatable {
  const BlogDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Blog Details Fetch Event
class BlogDetailsFetchEvent extends BlogDetailsEvent {
  const BlogDetailsFetchEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

// Save Blog Event
class BlogDetailsSaveBlogEvent extends BlogDetailsEvent {
  const BlogDetailsSaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unsave Blog Event
class BlogDetailsUnsaveBlogEvent extends BlogDetailsEvent {
  const BlogDetailsUnsaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Upvote Blog Event
class BlogDetailsUpvoteBlogEvent extends BlogDetailsEvent {
  const BlogDetailsUpvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unupvote Blog Event
class BlogDetailsUnupvoteBlogEvent extends BlogDetailsEvent {
  const BlogDetailsUnupvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Get Comments Event
class BlogDetailsGetCommentsEvent extends BlogDetailsEvent {
  const BlogDetailsGetCommentsEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Create Comment Event
class BlogDetailsCreateCommentEvent extends BlogDetailsEvent {
  const BlogDetailsCreateCommentEvent({
    required this.blogId,
    required this.comment,
  });
  final int blogId;
  final String comment;

  @override
  List<Object?> get props => [blogId, comment];
}

// Delete Comment Event
class BloDetailsDeleteCommentEvent extends BlogDetailsEvent {
  const BloDetailsDeleteCommentEvent({
    required this.commentId,
    required this.blogId,
  });
  final int commentId;
  final int blogId;

  @override
  List<Object?> get props => [commentId, blogId];
}

// Upvote Comment Event
class BlogDetailsUpvoteCommentEvent extends BlogDetailsEvent {
  const BlogDetailsUpvoteCommentEvent({
    required this.commentId,
    required this.blogId,
  });
  final int commentId;
  final int blogId;

  @override
  List<Object?> get props => [commentId, blogId];
}

// Unupvote Comment Event
class BlogDetailsUnupvoteCommentEvent extends BlogDetailsEvent {
  const BlogDetailsUnupvoteCommentEvent({
    required this.commentId,
    required this.blogId,
  });
  final int commentId;
  final int blogId;

  @override
  List<Object?> get props => [commentId, blogId];
}
