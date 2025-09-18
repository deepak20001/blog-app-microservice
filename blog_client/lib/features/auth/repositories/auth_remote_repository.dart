import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/error/failures.dart';
import 'package:blog_client/core/services/network_service/api_end_points.dart';
import 'package:blog_client/core/services/network_service/dio_client.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteRepository {
  // Login
  Future<
    Either<Failure, (String successMessage, String token, ProfileModel user)>
  >
  login({required String email, required String password});

  // Signup
  Future<Either<Failure, String>> signup({
    required String username,
    required String email,
    required String password,
    required String bio,
  });

  // Verify Email
  Future<
    Either<Failure, (String successMessage, String token, ProfileModel user)>
  >
  verifyEmail({required String email, required String otp});

  // Resend Verification OTP
  Future<Either<Failure, String>> resendVerificationOtp({
    required String email,
  });

  // Forgot Password
  Future<Either<Failure, String>> forgotPassword({required String email});

  // Veify Password Reset OTP
  Future<Either<Failure, String>> verifyPasswordResetOtp({
    required String email,
    required String otp,
  });

  // Resend Password Reset OTP
  Future<Either<Failure, String>> resendPasswordResetOtp({
    required String email,
  });

  // Reset Password
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  });
}

// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// :::::::::::::::::::::::::::::::Implementation of AuthRemoteRepository:::::::::::::::::::::::::::::::
// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@LazySingleton(as: AuthRemoteRepository)
class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  AuthRemoteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<
    Either<Failure, (String successMessage, String token, ProfileModel user)>
  >
  login({required String email, required String password}) async {
    return TaskEither<
          Failure,
          (String successMessage, String token, ProfileModel user)
        >.tryCatch(
          () async {
            final response = await _dioClient.post<Map<String, dynamic>>(
              ApiEndpoints.login,
              data: {'email': email, 'password': password},
            );

            final data = response.data!;
            final message = data['message'] as String? ?? '';
            final token = data['data']['token'] as String? ?? '';
            final user = (data['data']['user'] != null)
                ? ProfileModel.fromJson(
                    data['data']['user'] as Map<String, dynamic>,
                  )
                : ProfileModel.empty();

            return (message, token, user);
          },
          (error, stackTrace) {
            devtools.log(
              'Login error: $error',
              error: error,
              stackTrace: stackTrace,
            );
            if (error is NetworkException) {
              return Failure(error.message);
            }
            return Failure('Login failed. Please try again.');
          },
        )
        .run();
  }

  @override
  Future<Either<Failure, String>> signup({
    required String username,
    required String email,
    required String password,
    required String bio,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.register,
          data: {
            'email': email,
            'password': password,
            'bio': bio,
            'username': username,
            'role': 'user',
          },
        );

        final data = response.data!;
        final message = data['message'] as String;

        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Signup error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Signup failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<
    Either<Failure, (String successMessage, String token, ProfileModel user)>
  >
  verifyEmail({required String email, required String otp}) async {
    return TaskEither<
          Failure,
          (String successMessage, String token, ProfileModel user)
        >.tryCatch(
          () async {
            final response = await _dioClient.post<Map<String, dynamic>>(
              ApiEndpoints.verifyEmail,
              data: {'email': email, 'otp': otp},
            );

            final data = response.data!;
            final message = data['message'] as String;
            final token = data['data']['token'] as String;
            final user = ProfileModel.fromJson(
              data['data']['user'] as Map<String, dynamic>,
            );
            return (message, token, user);
          },
          (error, stackTrace) {
            devtools.log(
              'Verify Email error: $error',
              error: error,
              stackTrace: stackTrace,
            );
            if (error is NetworkException) {
              return Failure(error.message);
            }
            return Failure('Verify Email failed. Please try again.');
          },
        )
        .run();
  }

  @override
  Future<Either<Failure, String>> resendVerificationOtp({
    required String email,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.resendVerificationOtp,
          data: {'email': email},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Resend Verification OTP error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Resend Verification OTP failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.forgotPassword,
          data: {'email': email},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Forgot Password error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Forgot Password failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.verifyPasswordResetOtp,
          data: {'email': email, 'otp': otp},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Verify Password Reset OTP error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Verify Password Reset OTP failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> resendPasswordResetOtp({
    required String email,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.resendPasswordResetOtp,
          data: {'email': email},
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Resend Password Reset OTP error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Resend Password Reset OTP failed. Please try again.');
      },
    ).run();
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return TaskEither<Failure, String>.tryCatch(
      () async {
        final response = await _dioClient.post<Map<String, dynamic>>(
          ApiEndpoints.resetPassword,
          data: {
            'email': email,
            'otp': otp,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword,
          },
        );

        final data = response.data!;
        final message = data['message'] as String;
        return message;
      },
      (error, stackTrace) {
        devtools.log(
          'Reset Password error: $error',
          error: error,
          stackTrace: stackTrace,
        );
        if (error is NetworkException) {
          return Failure(error.message);
        }
        return Failure('Reset Password failed. Please try again.');
      },
    ).run();
  }
}
