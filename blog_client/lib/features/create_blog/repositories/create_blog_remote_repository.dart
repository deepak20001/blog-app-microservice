import 'dart:developer' as devtools show log;
import 'dart:io';
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
  Future<Either<Failure, String>> createBlog({
    required String imagePath,
    required String title,
    required String description,
    required int categoryId,
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
        if (fileSize > 5 * 1024 * 1024) {
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
  Future<Either<Failure, String>> createBlog({
    required String imagePath,
    required String title,
    required String description,
    required int categoryId,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.createBlog,
          data: {
            'image': imagePath,
            'title': title,
            'description': description,
            'category_id': categoryId,
          },
        );

        final data = response.data!;
        return data['message'] as String;
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
    ).run();
  }
}
