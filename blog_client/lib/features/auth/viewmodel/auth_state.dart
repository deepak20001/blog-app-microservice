part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState({this.successMessage = '', this.errorMessage = ''});
  final String successMessage;
  final String errorMessage;

  AuthState copyWith({String? successMessage, String? errorMessage}) {
    return _AuthStateImpl(
      successMessage: successMessage ?? '',
      errorMessage: errorMessage ?? '',
    );
  }

  @override
  List<Object?> get props => [successMessage, errorMessage];
}

class _AuthStateImpl extends AuthState {
  const _AuthStateImpl({
    required super.successMessage,
    required super.errorMessage,
  });
}

class AuthInitialState extends AuthState {
  const AuthInitialState() : super();
}

// Login States
class AuthLoginLoadingState extends AuthState {
  const AuthLoginLoadingState();
}

class AuthLoginSuccessState extends AuthState {
  const AuthLoginSuccessState({required super.successMessage});
}

class AuthLoginFailureState extends AuthState {
  const AuthLoginFailureState({required super.errorMessage});
}

// Signup States
class AuthSignupLoadingState extends AuthState {
  const AuthSignupLoadingState();
}

class AuthSignupSuccessState extends AuthState {
  const AuthSignupSuccessState({required super.successMessage});
}

class AuthSignupFailureState extends AuthState {
  const AuthSignupFailureState({required super.errorMessage});
}
