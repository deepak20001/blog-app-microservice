import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class SearchRemoteRepository {
  // Search users
  Future<Either<Failure, List<ProfileModel>>> searchUsers({
    required String search,
    required int page,
    required int limit,
  });
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of SearchRemoteRepository:::::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: SearchRemoteRepository)
class SearchRemoteRepositoryImpl implements SearchRemoteRepository {
  SearchRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<Either<Failure, List<ProfileModel>>> searchUsers({
    required String search,
    required int page,
    required int limit,
  }) async {
    return TaskEither<Failure, List<ProfileModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.searchUsers(search: search, page: page, limit: limit),
        );

        final data = response.data!;
        return (data['data'] as List<dynamic>)
            .map((e) => ProfileModel.fromJson(e))
            .toList();
      },
      (error, stackTrace) {
        devtools.log(
          'Search Users error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Search Users failed. Please try again.');
      },
    ).run();
  }
}
