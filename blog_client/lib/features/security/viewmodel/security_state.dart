part of 'security_bloc.dart';

sealed class SecurityState extends Equatable {
  const SecurityState();

  @override
  List<Object?> get props => [];
}

class SecurityInitialState extends SecurityState {
  const SecurityInitialState() : super();
}

// Change Password States
class SecurityChangePasswordLoadingState extends SecurityState {
  const SecurityChangePasswordLoadingState();
}

class SecurityChangePasswordSuccessState extends SecurityState {
  const SecurityChangePasswordSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class SecurityChangePasswordFailureState extends SecurityState {
  const SecurityChangePasswordFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

// Delete Account States
class SecurityDeleteAccountLoadingState extends SecurityState {
  const SecurityDeleteAccountLoadingState();
}

class SecurityDeleteAccountSuccessState extends SecurityState {
  const SecurityDeleteAccountSuccessState({required this.successMessage});
  final String successMessage;

  @override
  List<Object?> get props => [successMessage];
}

class SecurityDeleteAccountFailureState extends SecurityState {
  const SecurityDeleteAccountFailureState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
