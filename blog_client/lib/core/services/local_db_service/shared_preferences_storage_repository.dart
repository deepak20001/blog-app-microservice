import 'dart:async';
import 'package:blog_client/core/constants/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesStorageRepository {
  /// ACCESS_TOKEN
  String get accessToken;
  set accessToken(String? value);

  /// IS_LOGGED_IN
  bool get isLoggedIn;
  set isLoggedIn(bool value);

  /// USER_ID
  String get userId;
  set userId(String? value);

  /// USER_NAME
  String get userName;
  set userName(String? value);

  /// USER_EMAIL
  String get userEmail;
  set userEmail(String? value);

  /// USER_PROFILE_IMAGE
  String get userProfileImage;
  set userProfileImage(String? value);

  /// CLEAR_USER_DATA
  Future<void> clearUserData();
}

@LazySingleton(as: SharedPreferencesStorageRepository)
class SharedPreferencesStorageRepositoryImpl
    implements SharedPreferencesStorageRepository {
  SharedPreferencesStorageRepositoryImpl({required SharedPreferences prefs})
    : _prefs = prefs;
  final SharedPreferences _prefs;

  /// ACCESS_TOKEN_GETTER
  @override
  String get accessToken =>
      _prefs.getString(PreferenceKeys.accessTokenKey) ?? '';

  /// ACCESS_TOKEN_SETTER
  @override
  set accessToken(String? value) {
    _prefs.setString(PreferenceKeys.accessTokenKey, value ?? '');
  }

  /// IS_LOGGED_IN_GETTER
  @override
  bool get isLoggedIn => _prefs.getBool(PreferenceKeys.isLoggedInKey) ?? false;

  /// IS_LOGGED_IN_SETTER
  @override
  set isLoggedIn(bool value) {
    _prefs.setBool(PreferenceKeys.isLoggedInKey, value);
  }

  /// USER_ID_GETTER
  @override
  String get userId => _prefs.getString(PreferenceKeys.userIdKey) ?? '';

  /// USER_ID_SETTER
  @override
  set userId(String? value) {
    _prefs.setString(PreferenceKeys.userIdKey, value ?? '');
  }

  /// USER_NAME_GETTER
  @override
  String get userName => _prefs.getString(PreferenceKeys.userNameKey) ?? '';

  /// USER_NAME_SETTER
  @override
  set userName(String? value) {
    _prefs.setString(PreferenceKeys.userNameKey, value ?? '');
  }

  /// USER_EMAIL_GETTER
  @override
  String get userEmail => _prefs.getString(PreferenceKeys.userEmailKey) ?? '';

  /// USER_EMAIL_SETTER
  @override
  set userEmail(String? value) {
    _prefs.setString(PreferenceKeys.userEmailKey, value ?? '');
  }

  /// USER_PROFILE_IMAGE_GETTER
  @override
  String get userProfileImage =>
      _prefs.getString(PreferenceKeys.userProfileImageKey) ?? '';

  /// USER_PROFILE_IMAGE_SETTER
  @override
  set userProfileImage(String? value) {
    _prefs.setString(PreferenceKeys.userProfileImageKey, value ?? '');
  }

  /// CLEAR_USER_DATA
  @override
  Future<void> clearUserData() async {
    await _prefs.clear();
  }
}
