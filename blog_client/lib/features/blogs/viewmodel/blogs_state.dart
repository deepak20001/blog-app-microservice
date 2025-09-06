part of 'blogs_bloc.dart';

sealed class BlogsState extends Equatable {
  const BlogsState({this.blogs = const <BlogModel>[]});
  final List<BlogModel> blogs;

  @override
  List<Object?> get props => [blogs];
}

class BlogsInitialState extends BlogsState {
  const BlogsInitialState() : super();
}

// Blogs Fetch States
class BlogsFetchLoadingState extends BlogsState {
  const BlogsFetchLoadingState();
}

class BlogsFetchSuccessState extends BlogsState {
  const BlogsFetchSuccessState({required this.blogs});

  final List<BlogModel> blogs;

  @override
  List<Object?> get props => [blogs];
}

class BlogsFetchFailureState extends BlogsState {
  const BlogsFetchFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
