import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class BlogsRemoteRepository {
  // Login
  Future<Either<Failure, List<BlogModel>>> blogs();
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
  Future<Either<Failure, List<BlogModel>>> blogs() async {
    return TaskEither<Failure, List<BlogModel>>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.blogs,
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
}
