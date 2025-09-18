part of 'security_bloc.dart';

abstract class SecurityEvent extends Equatable {
  const SecurityEvent();

  @override
  List<Object?> get props => [];
}

// Change Password Event
class SecurityChangePasswordEvent extends SecurityEvent {
  const SecurityChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

// Delete Account Event
class SecurityDeleteAccountEvent extends SecurityEvent {
  const SecurityDeleteAccountEvent({required this.password});
  final String password;

  @override
  List<Object?> get props => [password];
}