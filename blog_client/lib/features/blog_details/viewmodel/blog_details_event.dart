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
class SaveBlogEvent extends BlogDetailsEvent {
  const SaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unsave Blog Event
class UnsaveBlogEvent extends BlogDetailsEvent {
  const UnsaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Upvote Blog Event
class UpvoteBlogEvent extends BlogDetailsEvent {
  const UpvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unupvote Blog Event
class UnupvoteBlogEvent extends BlogDetailsEvent {
  const UnupvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}
