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
