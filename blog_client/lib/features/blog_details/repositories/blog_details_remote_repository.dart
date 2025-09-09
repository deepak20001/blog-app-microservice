import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:blog_client/features/blogs/models/category_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class BlogDetialsRemoteRepository {
  // Categories
  Future<Either<Failure, List<CategoryModel>>> categories();
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of BlogDetialsRemoteRepository::::::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: BlogDetialsRemoteRepository)
class BlogDetialsRemoteRepositoryImpl implements BlogDetialsRemoteRepository {
  BlogDetialsRemoteRepositoryImpl({required DioClient dioClient})
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
}
