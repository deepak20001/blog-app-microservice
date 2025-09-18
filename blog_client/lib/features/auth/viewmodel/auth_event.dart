part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Login Event
class AuthLoginEvent extends AuthEvent {
  const AuthLoginEvent({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

// Signup Event
class AuthSignupEvent extends AuthEvent {
  const AuthSignupEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.bio,
  });
  final String username;
  final String email;
  final String password;
  final String bio;

  @override
  List<Object?> get props => [username, email, password, bio];
}

// Verify Email Event
class AuthVerifyEmailEvent extends AuthEvent {
  const AuthVerifyEmailEvent({required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}

// Resend Verification OTP Event
class AuthResendVerificationOtpEvent extends AuthEvent {
  const AuthResendVerificationOtpEvent({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

// Forgot Password Event
class AuthForgotPasswordEvent extends AuthEvent {
  const AuthForgotPasswordEvent({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

// Verify Password Reset OTP Event
class AuthVerifyPasswordResetOtpEvent extends AuthEvent {
  const AuthVerifyPasswordResetOtpEvent({
    required this.email,
    required this.otp,
  });
  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}

// Resend Password Reset OTP Event
class AuthResendPasswordResetOtpEvent extends AuthEvent {
  const AuthResendPasswordResetOtpEvent({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}

// Reset Password Event
class AuthResetPasswordEvent extends AuthEvent {
  const AuthResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object?> get props => [email, otp, newPassword, confirmPassword];
}
