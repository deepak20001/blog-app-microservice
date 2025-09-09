import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:blog_client/features/blogs/models/category_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class BlogsRemoteRepository {
  // Categories
  Future<Either<Failure, List<CategoryModel>>> categories();

  // Blogs Filter
  Future<Either<Failure, List<BlogModel>>> blogs({
    required int page,
    required int limit,
    required int categoryId,
    required String search,
  });

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
// :::::::::::::::::::::::::::::::Implementation of BlogsRemoteRepository::::::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: BlogsRemoteRepository)
class BlogsRemoteRepositoryImpl implements BlogsRemoteRepository {
  BlogsRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<Either<Failure, List<CategoryModel>>> categories() async {
    return TaskEither<Failure, List<CategoryModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.categories,
        );

        final data = response.data!;
        final categories = (data['data'] as List<dynamic>)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        return categories;
      },
      (error, stackTrace) {
        devtools.log(
          'Categories error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Categories failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, List<BlogModel>>> blogs({
    required int page,
    required int limit,
    required int categoryId,
    required String search,
  }) async {
    return TaskEither<Failure, List<BlogModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.blogsFilter(
            page: page,
            limit: limit,
            categoryId: categoryId,
            search: search,
          ),
        );

        final data = response.data!;
        final blogs = (data['data'] as List<dynamic>)
            .map((e) => BlogModel.fromJson(e))
            .toList();
        return blogs;
      },
      (error, stackTrace) {
        devtools.log(
          'Blogs error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Blogs failed. Please try again.');
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
