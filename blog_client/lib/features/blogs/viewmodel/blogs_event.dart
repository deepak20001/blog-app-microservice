part of 'blogs_bloc.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();

  @override
  List<Object?> get props => [];
}

// Categories Fetch Event
class BlogsCategoriesFetchEvent extends BlogsEvent {
  const BlogsCategoriesFetchEvent();

  @override
  List<Object?> get props => [];
}

// Blogs Fetch Event
class BlogsFetchEvent extends BlogsEvent {
  const BlogsFetchEvent({required this.categoryId, required this.search});
  final int categoryId;
  final String search;

  @override
  List<Object?> get props => [categoryId, search];
}

// Save Blog Event
class BlogsSaveBlogEvent extends BlogsEvent {
  const BlogsSaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unsave Blog Event
class BlogsUnsaveBlogEvent extends BlogsEvent {
  const BlogsUnsaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Upvote Blog Event
class BlogsUpvoteBlogEvent extends BlogsEvent {
  const BlogsUpvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unupvote Blog Event
class BlogsUnupvoteBlogEvent extends BlogsEvent {
  const BlogsUnupvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}
