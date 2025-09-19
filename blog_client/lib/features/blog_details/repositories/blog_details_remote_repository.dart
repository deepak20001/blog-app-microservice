import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:blog_client/features/blog_details/models/comment_model.dart';
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

  // Get Comments
  Future<Either<Failure, List<CommentModel>>> getComments({
    required int blogId,
    required int page,
    required int limit,
  });

  // Create Comment
  Future<Either<Failure, CommentModel>> createComment({
    required int blogId,
    required String comment,
  });

  // Delete Comment
  Future<Either<Failure, String>> deleteComment({
    required int commentId,
    required int blogId,
  });

  // Upvote Comment
  Future<Either<Failure, String>> upvoteComment({
    required int commentId,
    required int blogId,
  });

  // Unupvote Comment
  Future<Either<Failure, String>> unupvoteComment({
    required int commentId,
    required int blogId,
  });
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

  @override
  Future<Either<Failure, List<CommentModel>>> getComments({
    required int blogId,
    required int page,
    required int limit,
  }) async {
    return TaskEither<Failure, List<CommentModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.fetchComments(blogId: blogId, page: page, limit: limit),
        );

        final data = response.data!;
        final comments = data['data'] as List<dynamic>;
        final commentModels = (comments)
            .map((comment) => CommentModel.fromJson(comment))
            .toList();
        return commentModels;
      },
      (error, stackTrace) {
        devtools.log(
          'Get Comments error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Get Comments failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, CommentModel>> createComment({
    required int blogId,
    required String comment,
  }) async {
    return TaskEither<Failure, CommentModel>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.createComment,
          data: {'blog_id': blogId, 'comment': comment},
        );

        final data = response.data!;
        return CommentModel.fromJson(data['data']);
      },
      (error, stackTrace) {
        devtools.log(
          'Create Comment error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Create Comment failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> deleteComment({
    required int blogId,
    required int commentId,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.delete<Map<String, dynamic>>(
          ApiEndpoints.deleteComment,
          data: {'blog_id': blogId, 'comment_id': commentId},
        );

        final data = response.data;
        return data?['message'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Delete Comment error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Delete Comment failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> upvoteComment({
    required int blogId,
    required int commentId,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.upvoteComment,
          data: {'blog_id': blogId, 'comment_id': commentId},
        );

        final data = response.data;
        return data?['message'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Upvote Comment error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Upvote Comment failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> unupvoteComment({
    required int blogId,
    required int commentId,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.delete<Map<String, dynamic>>(
          ApiEndpoints.unupvoteComment,
          data: {'blog_id': blogId, 'comment_id': commentId},
        );

        final data = response.data;
        return data?['message'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Unupvote Comment error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Unupvote Comment failed. Please try again.');
      },
    ).run();
  }
}
