part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState({
    this.isLoadingMore = false,
    this.users = const <ProfileModel>[],
  });
  final bool isLoadingMore;
  final List<ProfileModel> users;

  @override
  List<Object?> get props => [isLoadingMore, users];
}

class SearchInitialState extends SearchState {
  const SearchInitialState() : super();
}

// Get Search Users States
class SearchGetUsersLoadingState extends SearchState {
  const SearchGetUsersLoadingState({super.isLoadingMore, required super.users});
}

class SearchGetUsersSuccessState extends SearchState {
  const SearchGetUsersSuccessState({required super.users, super.isLoadingMore});

  @override
  List<Object?> get props => [users, isLoadingMore];
}

class SearchGetUsersFailureState extends SearchState {
  const SearchGetUsersFailureState({
    required this.errorMessage,
    required super.users,
    super.isLoadingMore,
  });
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage, isLoadingMore, users];
}
