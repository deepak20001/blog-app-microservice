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
  const BlogsFetchEvent({
    required this.categoryId,
    required this.search,
    this.isLoadMore = false,
  });
  final int categoryId;
  final String search;
  final bool isLoadMore;

  @override
  List<Object?> get props => [categoryId, search, isLoadMore];
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

// Added Blog Event
class BlogsAddedBlogEvent extends BlogsEvent {
  const BlogsAddedBlogEvent({required this.blog});
  final BlogModel blog;

  @override
  List<Object?> get props => [blog];
}

// Update Like
class BlogsUpdateLikeEvent extends BlogsEvent {
  const BlogsUpdateLikeEvent({required this.blogId, required this.isLiked});
  final int blogId;
  final bool isLiked;

  @override
  List<Object?> get props => [blogId, isLiked];
}

// Update Save Event
class BlogsUpdateSaveEvent extends BlogsEvent {
  const BlogsUpdateSaveEvent({required this.blogId, required this.isSaved});
  final int blogId;
  final bool isSaved;

  @override
  List<Object?> get props => [blogId, isSaved];
}
