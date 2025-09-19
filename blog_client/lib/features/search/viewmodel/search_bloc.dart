import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/features/search/repositories/search_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'search_event.dart';
part 'search_state.dart';

@singleton
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchRemoteRepository searchRemoteRepository})
    : _searchRemoteRepository = searchRemoteRepository,
      super(const SearchInitialState()) {
    on<SearchGetUsersEvent>(_onGetUsersRequested);
  }
  final SearchRemoteRepository _searchRemoteRepository;
  int _page = 1;
  int _limit = 20;
  bool allItemsLoaded = false;

  // Handle get users
  Future<void> _onGetUsersRequested(
    SearchGetUsersEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (!event.isLoadMore) {
      _page = 0;
      allItemsLoaded = false;
    }
    if (allItemsLoaded) {
      return;
    }
    _page++;

    emit(
      SearchGetUsersLoadingState(
        isLoadingMore: event.isLoadMore,
        users: state.users,
      ),
    );
    try {
      final result = await _searchRemoteRepository.searchUsers(
        search: event.search,
        page: _page,
        limit: _limit,
      );

      await result.fold(
        (failure) {
          devtools.log('Get Users failed: ${failure.message}');
          emit(
            SearchGetUsersFailureState(
              errorMessage: failure.message,
              users: state.users,
            ),
          ); 
        },
        (List<ProfileModel> data) async {
          if (data.isEmpty || data.length < _limit) {
            allItemsLoaded = true;
          }
          final updatedUsers = event.isLoadMore
              ? [...state.users, ...data]
              : data;
          emit(
            SearchGetUsersSuccessState(
              users: updatedUsers,
              isLoadingMore: false,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get users: $e',
        stackTrace: stackTrace,
      );
      emit(
        SearchGetUsersFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
          users: state.users,
          isLoadingMore: false,
        ),
      );
    }
  }
}
