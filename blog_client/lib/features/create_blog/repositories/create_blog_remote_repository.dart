import 'dart:developer' as devtools show log;
import 'dart:io';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:blog_client/features/blogs/models/category_model.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract interface class CreateBlogRemoteRepository {
  // Pick Image
  Future<Either<Failure, String>> pickImage();

  // Categories
  Future<Either<Failure, List<CategoryModel>>> categories();

  // Upload image
  Future<Either<Failure, String>> uploadImage({required String imagePath});

  // Create blog
  Future<Either<Failure, (String successMessage, BlogModel blog)>> createBlog({
    required String imagePath,
    required String title,
    required String shortDescription,
    required String description,
    required int categoryId,
  });

  // Generate ai title
  Future<Either<Failure, String>> generateAiTitle({required String title});

  // Generate ai short description
  Future<Either<Failure, String>> generateAiShortDescription({
    required String title,
    required String shortDescription,
  });

  // Generate ai description
  Future<Either<Failure, String>> generateAiDescription({
    required String title,
    required String shortDescription,
    required String description,
  });
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of CreateBlogRemoteRepository:::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: CreateBlogRemoteRepository)
class BlogsRemoteRepositoryImpl implements CreateBlogRemoteRepository {
  BlogsRemoteRepositoryImpl({
    required DioClient dioClient,
    required ImagePicker imagePicker,
  }) : _dioClient = dioClient,
       _imagePicker = imagePicker;
  final DioClient _dioClient;
  final ImagePicker _imagePicker;
  final fileSize = 5 * 1024 * 1024;

  @override
  Future<Either<Failure, String>> pickImage() async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
        );
        if (image == null) {
          throw Exception('Image not picked');
        }

        final file = File(image.path);
        final fileSize = file.lengthSync();
        if (fileSize > fileSize) {
          throw Exception('Image size is too large');
        }

        return file.path;
      },
      (error, stackTrace) {
        devtools.log(
          'Pick image error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Pick image failed. Please try again.');
      },
    ).run();
  }

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
  Future<Either<Failure, String>> uploadImage({
    required String imagePath,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        devtools.log('Uploading image: $imagePath');
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(imagePath),
        });

        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.uploadBlogImage,
          data: formData,
          isFormData: true,
        );

        final data = response.data!;
        return data['url'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Upload image error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Upload image failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, (String successMessage, BlogModel blog)>> createBlog({
    required String imagePath,
    required String title,
    required String shortDescription,
    required String description,
    required int categoryId,
  }) async {
    return TaskEither<
          Failure,
          (String successMessage, BlogModel blog)
        >.tryCatch(
          () async {
            final response = await _dioClient.post<Map<String, dynamic>>(
              ApiEndpoints.createBlog,
              data: {
                'image': imagePath,
                'title': title,
                'short_description': shortDescription,
                'description': description,
                'category_id': categoryId,
              },
            );

            final data = response.data!;
            return (
              data['message'] as String? ?? 'Blog created successfully',
              (data['data'] != null)
                  ? BlogModel.fromJson(data['data'])
                  : BlogModel.empty(),
            );
          },
          (error, stackTrace) {
            devtools.log(
              'Create blog error: $error',
              error: error,
              stackTrace: stackTrace,
            );
            if (error is NetworkException) {
              return Failure(error.message);
            }
            return Failure('Create blog failed. Please try again.');
          },
        )
        .run();
  }

  @override
  Future<Either<Failure, String>> generateAiTitle({
    required String title,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.generateAiTitle,
          data: {'title': title},
        );

        final data = response.data!;
        return data['data'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Generate ai title error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Generate ai title failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> generateAiShortDescription({
    required String title,
    required String shortDescription,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.generateAiShortDescription,
          data: {'title': title, 'short_description': shortDescription},
        );

        final data = response.data!;
        return data['data'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Generate ai short description error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure(
          'Generate ai short description failed. Please try again.',
        );
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> generateAiDescription({
    required String title,
    required String shortDescription,
    required String description,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.generateAiDescription,
          data: {
            'title': title,
            'short_description': shortDescription,
            'description': description,
          },
        );

        final data = response.data!;
        return data['data'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Generate ai description error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Generate ai description failed. Please try again.');
      },
    ).run();
  }
}
