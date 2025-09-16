import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class ProfileRemoteRepository {
  // Get My Blogs
  Future<Either<Failure, List<BlogModel>>> getMyBlogs({
    required int page,
    required int limit,
  });
  // Get Saved Blogs
  Future<Either<Failure, List<BlogModel>>> getSavedBlogs({
    required int page,
    required int limit,
  });
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of ProfileRemoteRepository::::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: ProfileRemoteRepository)
class ProfileRemoteRepositoryImpl implements ProfileRemoteRepository {
  ProfileRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<Either<Failure, List<BlogModel>>> getMyBlogs({
    required int page,
    required int limit,
  }) async {
    return TaskEither<Failure, List<BlogModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.getMyBlogs,
          queryParameters: {'page': page, 'limit': limit},
        );

        final data = response.data!;
        final blogs = (data['data'] as List<dynamic>)
            .map((e) => BlogModel.fromJson(e))
            .toList();
        return blogs;
      },
      (error, stackTrace) {
        devtools.log(
          'Get My Blogs error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Get My Blogs failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, List<BlogModel>>> getSavedBlogs({
    required int page,
    required int limit,
  }) async {
    return TaskEither<Failure, List<BlogModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.getSavedBlogs,
          queryParameters: {'page': page, 'limit': limit},
        );

        final data = response.data!;
        final blogs = (data['data'] as List<dynamic>)
            .map((e) => BlogModel.fromJson(e))
            .toList();
        return blogs;
      },
      (error, stackTrace) {
        devtools.log(
          'Get Saved Blogs error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Get Saved Blogs failed. Please try again.');
      },
    ).run();
  }
}
