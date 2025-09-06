import 'dart:developer' as devtools show log;
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/features/auth/repositories/auth_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@singleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRemoteRepository authRemoteRepository,
    required SharedPreferencesStorageRepository storageRepository,
  }) : _authRemoteRepository = authRemoteRepository,
       _storageRepository = storageRepository,
       super(const AuthInitialState()) {
    on<AuthLoginEvent>(_onLoginRequested);
    on<AuthSignupEvent>(_onSignupRequested);
  }
  final AuthRemoteRepository _authRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;

  /// Handle login request
  Future<void> _onLoginRequested(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoginLoadingState());

    try {
      final result = await _authRemoteRepository.login(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Login failed: ${failure.message}');
          emit(AuthLoginFailureState(errorMessage: failure.message));
        },
        (data) async {
          final (successMessage, token) = data;
          _storageRepository.accessToken = token;
          emit(AuthLoginSuccessState(successMessage: successMessage));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log('Unexpected error during login: $e', stackTrace: stackTrace);
      emit(
        const AuthLoginFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle signup request
  Future<void> _onSignupRequested(
    AuthSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSignupLoadingState());

    try {
      final result = await _authRemoteRepository.signup(
        email: event.email.trim(),
        password: event.password.trim(),
        bio: event.bio.trim(),
        username: event.username.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Signup failed: ${failure.message}');
          emit(AuthSignupFailureState(errorMessage: failure.message));
        },
        (data) async {
          final (successMessage, token) = data;
          _storageRepository.accessToken = token;
          emit(AuthSignupSuccessState(successMessage: successMessage));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during signup: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthSignupFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
