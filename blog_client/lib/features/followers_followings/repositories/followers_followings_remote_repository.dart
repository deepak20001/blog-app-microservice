import 'dart:developer' as devtools show log;
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:blog_client/features/followers_followings/models/follower_following_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class FollowersFollowingsRemoteRepository {
  // Get followers
  Future<Either<Failure, List<FollowerFollowingModel>>> getFollowers({
    required String id,
  });

  // Get followings
  Future<Either<Failure, List<FollowerFollowingModel>>> getFollowings({
    required String id,
  });

  // Follow profile
  Future<Either<Failure, String>> followProfile({required String id});

  // Unfollow profile
  Future<Either<Failure, String>> unfollowProfile({required String id});
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of FollowersFollowingsRemoteRepository::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: FollowersFollowingsRemoteRepository)
class FollowersFollowingsRemoteRepositoryImpl
    implements FollowersFollowingsRemoteRepository {
  FollowersFollowingsRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<Either<Failure, List<FollowerFollowingModel>>> getFollowers({
    required String id,
  }) async {
    return TaskEither<Failure, List<FollowerFollowingModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.getFollowers(id: id),
        );

        final data = response.data!;
        return (data['data'] as List<dynamic>)
            .map((e) => FollowerFollowingModel.fromJson(e))
            .toList();
      },
      (error, stackTrace) {
        devtools.log(
          'Get Followers error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Get Followers failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, List<FollowerFollowingModel>>> getFollowings({
    required String id,
  }) async {
    return TaskEither<Failure, List<FollowerFollowingModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.getFollowings(id: id),
        );

        final data = response.data!;
        return (data['data'] as List<dynamic>)
            .map((e) => FollowerFollowingModel.fromJson(e))
            .toList();
      },
      (error, stackTrace) {
        devtools.log(
          'Get Followings error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Get Followings failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> followProfile({required String id}) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.followProfile,
          data: {'id': id},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Follow Profile error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Follow Profile failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> unfollowProfile({required String id}) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.unfollowProfile,
          data: {'id': id},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Unfollow Profile error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Unfollow Profile failed. Please try again.');
      },
    ).run();
  }
}
