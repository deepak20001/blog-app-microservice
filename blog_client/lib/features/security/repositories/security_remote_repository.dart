import 'dart:developer' as devtools show log;
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class SecurityRemoteRepository {
  // Change Password
  Future<Either<Failure, String>> changePassowrd({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  // Delete Account
  Future<Either<Failure, String>> deleteAccount({required String password});
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of SecurityRemoteRepository:::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: SecurityRemoteRepository)
class SecurityRemoteRepositoryImpl implements SecurityRemoteRepository {
  SecurityRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<Either<Failure, String>> changePassowrd({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.patch<Map<String, dynamic>>(
          ApiEndpoints.changePassword,
          data: {
            'currentPassword': currentPassword,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword,
          },
        );

        final data = response.data!;
        return data['message'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Change Password error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Change Password failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> deleteAccount({
    required String password,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.delete<Map<String, dynamic>>(
          ApiEndpoints.deleteAccount,
          data: {'password': password},
        );

        final data = response.data!;
        return data['message'] as String;
      },
      (error, stackTrace) {
        devtools.log(
          'Delete Account error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Delete Account failed. Please try again.');
      },
    ).run();
  }
}
