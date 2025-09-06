part of 'blogs_bloc.dart';

abstract class BlogsEvent extends Equatable {
  const BlogsEvent();

  @override
  List<Object?> get props => [];
}

// Blogs Fetch Event
class BlogsFetchEvent extends BlogsEvent {
  const BlogsFetchEvent();

  @override
  List<Object?> get props => [];
}
