import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class BlogDetailsRemoteRepository {
  // Blog Details
  Future<Either<Failure, BlogModel>> blogDetails({required String id});

  // Save Blog
  Future<Either<Failure, String>> saveBlog({required int blogId});

  // Unsave Blog
  Future<Either<Failure, String>> unsaveBlog({required int blogId});

  // Like Blog
  Future<Either<Failure, String>> upvoteBlog({required int blogId});

  // Unlike Blog
  Future<Either<Failure, String>> unupvoteBlog({required int blogId});
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of BlogDetialsRemoteRepository::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: BlogDetailsRemoteRepository)
class BlogDetialsRemoteRepositoryImpl implements BlogDetailsRemoteRepository {
  BlogDetialsRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<Either<Failure, BlogModel>> blogDetails({required String id}) async {
    return TaskEither<Failure, BlogModel>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.blogDetails(id: id),
        );

        final data = response.data!;
        final blog = BlogModel.fromJson(data['data']);
        return blog;
      },
      (error, stackTrace) {
        devtools.log(
          'Blog Details error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Blog Details failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> saveBlog({required int blogId}) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.saveBlog,
          data: {'blog_id': blogId},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Save Blog error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Save Blog failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> unsaveBlog({required int blogId}) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.delete<Map<String, dynamic>>(
          ApiEndpoints.unsaveBlog,
          data: {'blog_id': blogId},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Unsave Blog error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Unsave Blog failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> upvoteBlog({required int blogId}) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.upvoteBlog,
          data: {'blog_id': blogId},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Upvote Blog error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Upvote Blog failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> unupvoteBlog({required int blogId}) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.delete<Map<String, dynamic>>(
          ApiEndpoints.unupvoteBlog,
          data: {'blog_id': blogId},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Unupvote Blog error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Unupvote Blog failed. Please try again.');
      },
    ).run();
  }
}
