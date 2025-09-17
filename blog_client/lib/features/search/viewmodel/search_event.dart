part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

// get users
class SearchGetUsersEvent extends SearchEvent {
  const SearchGetUsersEvent({required this.search});
  final String search;
  @override
  List<Object?> get props => [search];
}
