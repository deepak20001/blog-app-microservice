import 'dart:developer' as devtools show log;
import 'package:blog_client/features/followers_followings/models/follower_following_model.dart';
import 'package:blog_client/features/followers_followings/repositories/followers_followings_remote_repository.dart';
import 'package:blog_client/features/profile/viewmodel/profile_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'follow_followings_event.dart';
part 'follow_followings_state.dart';

@singleton
class FollowFollowingsBloc
    extends Bloc<FollowFollowingsEvent, FollowFollowingsState> {
  FollowFollowingsBloc({
    required FollowersFollowingsRemoteRepository
    followersFollowingsRemoteRepository,
  }) : _followersFollowingsRemoteRepository =
           followersFollowingsRemoteRepository,
       super(const FollowFollowingsInitialState()) {
    on<FollowFollowingsGetFollowersEvent>(_onGetFollowersRequested);
    on<FollowFollowingsGetFollowingsEvent>(_onGetFollowingsRequested);
    on<FollowFollowingsFollowProfileEvent>(_onFollowProfileRequested);
    on<FollowFollowingsUnfollowProfileEvent>(_onUnfollowProfileRequested);
  }
  final FollowersFollowingsRemoteRepository
  _followersFollowingsRemoteRepository;
  final int _page = 1;
  final int _limit = 10;

  // Handle get followers
  Future<void> _onGetFollowersRequested(
    FollowFollowingsGetFollowersEvent event,
    Emitter<FollowFollowingsState> emit,
  ) async {
    emit(FollowFollowingsGetFollowersLoadingState(data: state.data));

    try {
      final result = await _followersFollowingsRemoteRepository.getFollowers(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Get Followers failed: ${failure.message}');
          emit(
            FollowFollowingsGetFollowersFailureState(
              errorMessage: failure.message,
              data: state.data,
            ),
          );
        },
        (List<FollowerFollowingModel> data) async {
          emit(FollowFollowingsGetFollowersSuccessState(data: data));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get followers: $e',
        stackTrace: stackTrace,
      );
      emit(
        FollowFollowingsGetFollowersFailureState(
          data: state.data,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  // Handle get followings
  Future<void> _onGetFollowingsRequested(
    FollowFollowingsGetFollowingsEvent event,
    Emitter<FollowFollowingsState> emit,
  ) async {
    emit(FollowFollowingsGetFollowingsLoadingState(data: state.data));

    try {
      final result = await _followersFollowingsRemoteRepository.getFollowings(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Get Followings failed: ${failure.message}');
          emit(
            FollowFollowingsGetFollowingsFailureState(
              errorMessage: failure.message,
              data: state.data,
            ),
          );
        },
        (List<FollowerFollowingModel> data) async {
          emit(FollowFollowingsGetFollowingsSuccessState(data: data));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during get followings: $e',
        stackTrace: stackTrace,
      );
      emit(
        FollowFollowingsGetFollowingsFailureState(
          data: state.data,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  // Handle follow profile
  Future<void> _onFollowProfileRequested(
    FollowFollowingsFollowProfileEvent event,
    Emitter<FollowFollowingsState> emit,
  ) async {
    final updatedData = state.data.map((data) {
      final isTargetProfile =
          data.follower.id == event.id || data.following.id == event.id;
      if (isTargetProfile) {
        return data.copyWith(isFollowing: true);
      }
      return data;
    }).toList();
    emit(FollowFollowingsFollowProfileLoadingState(data: updatedData));

    try {
      final result = await _followersFollowingsRemoteRepository.followProfile(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Follow Profile failed: ${failure.message}');
          emit(
            FollowFollowingsFollowProfileFailureState(
              errorMessage: failure.message,
              data: state.data,
            ),
          );
        },
        (_) async {
          getIt<ProfileBloc>().add(
            ProfileUpdateFollowFollowingsDataEvent(isFollowing: true),
          );
          emit(FollowFollowingsFollowProfileSuccessState(data: updatedData));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during follow profile: $e',
        stackTrace: stackTrace,
      );
      emit(
        FollowFollowingsFollowProfileFailureState(
          data: state.data,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  // Handle unfollow profile
  Future<void> _onUnfollowProfileRequested(
    FollowFollowingsUnfollowProfileEvent event,
    Emitter<FollowFollowingsState> emit,
  ) async {
    final updatedData = state.data.map((data) {
      final isTargetProfile =
          data.follower.id == event.id || data.following.id == event.id;
      if (isTargetProfile) {
        return data.copyWith(isFollowing: false);
      }
      return data;
    }).toList();
    emit(FollowFollowingsUnfollowProfileLoadingState(data: updatedData));

    try {
      final result = await _followersFollowingsRemoteRepository.unfollowProfile(
        id: event.id,
      );

      await result.fold(
        (failure) {
          devtools.log('Unfollow Profile failed: ${failure.message}');
          emit(
            FollowFollowingsUnfollowProfileFailureState(
              errorMessage: failure.message,
              data: state.data,
            ),
          );
        },
        (_) async {
          getIt<ProfileBloc>().add(
            ProfileUpdateFollowFollowingsDataEvent(isFollowing: false),
          );
          emit(FollowFollowingsUnfollowProfileSuccessState(data: updatedData));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during unfollow profile: $e',
        stackTrace: stackTrace,
      );
      emit(
        FollowFollowingsUnfollowProfileFailureState(
          data: state.data,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
