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
  Future<Either<Failure, (String successMessage, String token)>> signup({
    required String username,
    required String email,
    required String password,
    required String bio,
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
            final message = data['message'] as String;
            final token = data['data']['token'] as String;
            final user = ProfileModel.fromJson(
              data['data']['user'] as Map<String, dynamic>,
            );

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
  Future<Either<Failure, (String successMessage, String token)>> signup({
    required String username,
    required String email,
    required String password,
    required String bio,
  }) async {
    return TaskEither<Failure, (String successMessage, String token)>.tryCatch(
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
        final token = data['data']['token'] as String;

        return (message, token);
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
}
