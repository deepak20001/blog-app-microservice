part of 'blogs_bloc.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();

  @override
  List<Object?> get props => [];
}

// Categories Fetch Event
class CategoriesFetchEvent extends BlogsEvent {
  const CategoriesFetchEvent();

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
class SaveBlogEvent extends BlogsEvent {
  const SaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unsave Blog Event
class UnsaveBlogEvent extends BlogsEvent {
  const UnsaveBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Upvote Blog Event
class UpvoteBlogEvent extends BlogsEvent {
  const UpvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}

// Unupvote Blog Event
class UnupvoteBlogEvent extends BlogsEvent {
  const UnupvoteBlogEvent({required this.blogId});
  final int blogId;

  @override
  List<Object?> get props => [blogId];
}
