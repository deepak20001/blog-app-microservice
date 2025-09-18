import 'dart:developer' as devtools show log;
import 'dart:io';
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract interface class EditProfileRemoteRepository {
  // Get User Profile
  Future<Either<Failure, ProfileModel>> getUserProfile({required String id});

  // Pick Image
  Future<Either<Failure, String>> pickImage();

  // Upload Image
  Future<Either<Failure, String>> uploadImage({required String imagePath});

  // Update Avatar
  Future<Either<Failure, String>> updateAvatar({required String avatarPath});

  // Update Profile
  Future<Either<Failure, (String successMessage, ProfileModel profile)>>
  updateProfile({required String userName, required String bio});
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of EditProfileRemoteRepository::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: EditProfileRemoteRepository)
class EditProfileRemoteRepositoryImpl implements EditProfileRemoteRepository {
  EditProfileRemoteRepositoryImpl({
    required DioClient dioClient,
    required ImagePicker imagePicker,
  }) : _dioClient = dioClient,
       _imagePicker = imagePicker;
  final DioClient _dioClient;
  final ImagePicker _imagePicker;
  final fileSize = 5 * 1024 * 1024;

  @override
  Future<Either<Failure, ProfileModel>> getUserProfile({
    required String id,
  }) async {
    return TaskEither<Failure, ProfileModel>.tryCatch(
      () async {
        final response = await _dioClient.get<Map<String, dynamic>>(
          ApiEndpoints.profile(id: id),
        );

        final data = response.data!;
        return ProfileModel.fromJson(data['data']);
      },
      (error, stackTrace) {
        devtools.log(
          'Get User Profile error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Get User Profile failed. Please try again.');
      },
    ).run();
  }

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
          ApiEndpoints.uploadAvatar,
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
  Future<Either<Failure, String>> updateAvatar({
    required String avatarPath,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.patch<Map<String, dynamic>>(
          ApiEndpoints.updateAvatar,
          data: {'avatar': avatarPath},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Update Avatar error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Update Avatar failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, (String successMessage, ProfileModel profile)>>
  updateProfile({required String userName, required String bio}) async {
    return TaskEither<
          Failure,
          (String successMessage, ProfileModel profile)
        >.tryCatch(
          () async {
            final response = await _dioClient.patch<Map<String, dynamic>>(
              ApiEndpoints.updateProfile,
              data: {'username': userName, 'bio': bio},
            );

            final data = response.data!;
            final message = data['message'] as String;
            final profile = ProfileModel.fromJson(
              data['data'] as Map<String, dynamic>,
            );
            return (message, profile);
          },
          (error, stackTrace) {
            devtools.log(
              'Update Profile error: $error',
              error: error,
              stackTrace: stackTrace,
            );
            if (error is NetworkException) {
              return Failure(error.message);
            }
            return Failure('Update Profile failed. Please try again.');
          },
        )
        .run();
  }
}
