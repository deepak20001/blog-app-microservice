part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {
  const AuthInitialState() : super();
}

// Login States
class AuthLoginLoadingState extends AuthState {
  const AuthLoginLoadingState();
}

class AuthLoginSuccessState extends AuthState {
  const AuthLoginSuccessState({required this.successMessage, required this.user});
  final String successMessage;
  final ProfileModel user;

  @override
  List<Object?> get props => [successMessage, user];
}

class AuthLoginFailureState extends AuthState {
  const AuthLoginFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Signup States
class AuthSignupLoadingState extends AuthState {
  const AuthSignupLoadingState();
}

class AuthSignupSuccessState extends AuthState {
  const AuthSignupSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class AuthSignupFailureState extends AuthState {
  const AuthSignupFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Verify Email States
class AuthVerifyEmailLoadingState extends AuthState {
  const AuthVerifyEmailLoadingState();
}

class AuthVerifyEmailSuccessState extends AuthState {
  const AuthVerifyEmailSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class AuthVerifyEmailFailureState extends AuthState {
  const AuthVerifyEmailFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Resend Verification OTP States
class AuthResendVerificationOtpLoadingState extends AuthState {
  const AuthResendVerificationOtpLoadingState();
}

class AuthResendVerificationOtpSuccessState extends AuthState {
  const AuthResendVerificationOtpSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class AuthResendVerificationOtpFailureState extends AuthState {
  const AuthResendVerificationOtpFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Forgot Password States
class AuthForgotPasswordLoadingState extends AuthState {
  const AuthForgotPasswordLoadingState();
}

class AuthForgotPasswordSuccessState extends AuthState {
  const AuthForgotPasswordSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class AuthForgotPasswordFailureState extends AuthState {
  const AuthForgotPasswordFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Verify Password Reset OTP States
class AuthVerifyPasswordResetOtpLoadingState extends AuthState {
  const AuthVerifyPasswordResetOtpLoadingState();
}

class AuthVerifyPasswordResetOtpSuccessState extends AuthState {
  const AuthVerifyPasswordResetOtpSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class AuthVerifyPasswordResetOtpFailureState extends AuthState {
  const AuthVerifyPasswordResetOtpFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Resend Password Reset OTP States
class AuthResendPasswordResetOtpLoadingState extends AuthState {
  const AuthResendPasswordResetOtpLoadingState();
}

class AuthResendPasswordResetOtpSuccessState extends AuthState {
  const AuthResendPasswordResetOtpSuccessState({required this.successMessage});
  final String successMessage;
}

class AuthResendPasswordResetOtpFailureState extends AuthState {
  const AuthResendPasswordResetOtpFailureState({required this.errorMessage});
  final String errorMessage;
}

// Reset Password States
class AuthResetPasswordLoadingState extends AuthState {
  const AuthResetPasswordLoadingState();
}

class AuthResetPasswordSuccessState extends AuthState {
  const AuthResetPasswordSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class AuthResetPasswordFailureState extends AuthState {
  const AuthResetPasswordFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
