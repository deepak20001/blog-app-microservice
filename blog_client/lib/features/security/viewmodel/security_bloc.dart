import 'dart:developer' as devtools show log;
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/features/security/repositories/security_remote_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'security_event.dart';
part 'security_state.dart';

@singleton
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc({
    required SecurityRemoteRepository securityRemoteRepository,
    required SharedPreferencesStorageRepository storageRepository,
  }) : _securityRemoteRepository = securityRemoteRepository,
       _storageRepository = storageRepository,
       super(const SecurityInitialState()) {
    on<SecurityChangePasswordEvent>(_onChangePassword);
    on<SecurityDeleteAccountEvent>(_onDeleteAccount);
  }
  final SecurityRemoteRepository _securityRemoteRepository;
  final SharedPreferencesStorageRepository _storageRepository;

  // Handle change password
  Future<void> _onChangePassword(
    SecurityChangePasswordEvent event,
    Emitter<SecurityState> emit,
  ) async {
    if (state is SecurityChangePasswordLoadingState) return;
    emit(SecurityChangePasswordLoadingState());

    try {
      final result = await _securityRemoteRepository.changePassowrd(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );

      await result.fold(
        (failure) {
          devtools.log('Change password failed: ${failure.message}');
          emit(
            SecurityChangePasswordFailureState(errorMessage: failure.message),
          );
        },
        (String successMessage) async {
          emit(
            SecurityChangePasswordSuccessState(successMessage: successMessage),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during change password: $e',
        stackTrace: stackTrace,
      );
      emit(
        SecurityChangePasswordFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  // Handle delete account
  Future<void> _onDeleteAccount(
    SecurityDeleteAccountEvent event,
    Emitter<SecurityState> emit,
  ) async {
    if (state is SecurityDeleteAccountLoadingState) return;
    emit(SecurityDeleteAccountLoadingState());

    try {
      final result = await _securityRemoteRepository.deleteAccount(
        password: event.password,
      );

      await result.fold(
        (failure) {
          devtools.log('Delete account failed: ${failure.message}');
          emit(
            SecurityDeleteAccountFailureState(errorMessage: failure.message),
          );
        },
        (String successMessage) async {
          await _storageRepository.clearUserData();
          emit(
            SecurityDeleteAccountSuccessState(successMessage: successMessage),
          );
        },
      );
    } on Exception catch (e, stackTrace) {
      devtools.log(
        'Unexpected error during delete account: $e',
        stackTrace: stackTrace,
      );
      emit(
        SecurityDeleteAccountFailureState(
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }
}
