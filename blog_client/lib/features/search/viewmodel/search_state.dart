part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {
  const SearchInitialState() : super();
}

// Get Search Users States
class SearchGetUsersLoadingState extends SearchState {
  const SearchGetUsersLoadingState();
}

class SearchGetUsersSuccessState extends SearchState {
  const SearchGetUsersSuccessState({required this.users});
  final List<ProfileModel> users;

  @override
  List<Object?> get props => [users];
}

class SearchGetUsersFailureState extends SearchState {
  const SearchGetUsersFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
