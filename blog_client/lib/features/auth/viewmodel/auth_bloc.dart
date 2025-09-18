import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/models/profile_model.dart';
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
    on<AuthVerifyEmailEvent>(_onVerifyEmailRequested);
    on<AuthResendVerificationOtpEvent>(_onResendVerificationOtpRequested);
    on<AuthForgotPasswordEvent>(_onForgotPasswordRequested);
    on<AuthVerifyPasswordResetOtpEvent>(_onVerifyPasswordResetOtpRequested);
    on<AuthResendPasswordResetOtpEvent>(_onResendPasswordResetOtpRequested);
    on<AuthResetPasswordEvent>(_onResetPasswordRequested);
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
          final (successMessage, token, user) = data;
          if (user.isVerified) {
            _storageRepository.accessToken = token;
            _storageRepository.userId = user.id;
            _storageRepository.userName = user.username;
            _storageRepository.userEmail = user.email;
            _storageRepository.userBio = user.bio;
            _storageRepository.userProfileImage = user.avatar;
            _storageRepository.isLoggedIn = true;
            
          }
          emit(
            AuthLoginSuccessState(successMessage: successMessage, user: user),
          );
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
        (String successMessage) async {
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

  /// Handle verify email request
  Future<void> _onVerifyEmailRequested(
    AuthVerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthVerifyEmailLoadingState());

    try {
      final result = await _authRemoteRepository.verifyEmail(
        email: event.email.trim(),
        otp: event.otp.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Verify email failed: ${failure.message}');
          emit(AuthVerifyEmailFailureState(errorMessage: failure.message));
        },
        (data) async {
          final (successMessage, token, user) = data;
          _storageRepository.accessToken = token;
          _storageRepository.userId = user.id;
          _storageRepository.userName = user.username;
          _storageRepository.userEmail = user.email;
          _storageRepository.userBio = user.bio;
          _storageRepository.userProfileImage = user.avatar;
          _storageRepository.isLoggedIn = true;
          emit(AuthVerifyEmailSuccessState(successMessage: successMessage));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during verify email: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthVerifyEmailFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle resend verification OTP request
  Future<void> _onResendVerificationOtpRequested(
    AuthResendVerificationOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthResendVerificationOtpLoadingState());

    try {
      final result = await _authRemoteRepository.resendVerificationOtp(
        email: event.email.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Resend verification OTP failed: ${failure.message}');
          emit(
            AuthResendVerificationOtpFailureState(
              errorMessage: failure.message,
            ),
          );
        },
        (String successMessage) async {
          emit(
            AuthResendVerificationOtpSuccessState(
              successMessage: successMessage,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during resend verification OTP: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthResendVerificationOtpFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle forgot password request
  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthForgotPasswordLoadingState());

    try {
      final result = await _authRemoteRepository.forgotPassword(
        email: event.email.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Forgot password failed: ${failure.message}');
          emit(AuthForgotPasswordFailureState(errorMessage: failure.message));
        },
        (String successMessage) async {
          emit(AuthForgotPasswordSuccessState(successMessage: successMessage));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during forgot password: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthForgotPasswordFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle verify password reset OTP request
  Future<void> _onVerifyPasswordResetOtpRequested(
    AuthVerifyPasswordResetOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthVerifyPasswordResetOtpLoadingState());

    try {
      final result = await _authRemoteRepository.verifyPasswordResetOtp(
        email: event.email.trim(),
        otp: event.otp.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Verify password reset OTP failed: ${failure.message}');
          emit(
            AuthVerifyPasswordResetOtpFailureState(
              errorMessage: failure.message,
            ),
          );
        },
        (String successMessage) async {
          emit(
            AuthVerifyPasswordResetOtpSuccessState(
              successMessage: successMessage,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during verify password reset OTP: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthVerifyPasswordResetOtpFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle resend password reset OTP request
  Future<void> _onResendPasswordResetOtpRequested(
    AuthResendPasswordResetOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthResendPasswordResetOtpLoadingState());

    try {
      final result = await _authRemoteRepository.resendPasswordResetOtp(
        email: event.email.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Resend password reset OTP failed: ${failure.message}');
          emit(
            AuthResendPasswordResetOtpFailureState(
              errorMessage: failure.message,
            ),
          );
        },
        (String successMessage) async {
          emit(
            AuthResendPasswordResetOtpSuccessState(
              successMessage: successMessage,
            ),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during resend password reset OTP: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthResendPasswordResetOtpFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handle reset password request
  Future<void> _onResetPasswordRequested(
    AuthResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthResetPasswordLoadingState());

    try {
      final result = await _authRemoteRepository.resetPassword(
        email: event.email.trim(),
        otp: event.otp.trim(),
        newPassword: event.newPassword.trim(),
        confirmPassword: event.confirmPassword.trim(),
      );

      await result.fold(
        (failure) {
          devtools.log('Reset password failed: ${failure.message}');
          emit(AuthResetPasswordFailureState(errorMessage: failure.message));
        },
        (String successMessage) async {
          emit(AuthResetPasswordSuccessState(successMessage: successMessage));
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during reset password: $e',
        stackTrace: stackTrace,
      );
      emit(
        const AuthResetPasswordFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
